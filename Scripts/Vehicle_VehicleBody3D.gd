extends VehicleBody3D
#https://www.youtube.com/watch?v=ib4lkBURb0M
#https://www.youtube.com/watch?v=10ER8VbkicE&list=PLe63S5Eft1KapdW0-o824gCbG8LPvzxSA&index=8
@onready	var brakeLights = get_node("BrakeLights")
@onready	var reverseLights = get_node("ReverseLights")
@onready var rearLeftWheel = get_node("RLW_VehicleWheel3D")
@onready var rearRightWheel = get_node("RRW_VehicleWheel3D")
@onready var rearLeftSmoke = get_node("RLW_VehicleWheel3D/RLW_Smoke")
@onready var rearRightSmoke = get_node("RRW_VehicleWheel3D/RRW_Smoke")

#use high traction wheels (friction slip 1.1) for testing, then reduce once power curve set
#use stock cars in force and reference the power curve, 0-1 in godot = power / redline in forza curve
#IROC weight is 3400LBS or 1542 kg but godot seems to not like that, faking value for now.
#IROC topspeed is 130-140MPH depending on model
#changed wheels Friction Slip from default 10.5 in inspector, 0.75 for burn outs, 1.0 is normal
#old test values: radius=0.333 rssssest legnth=0.25 friction slip= 0.75 travel=0.25 stiffness=50 max force=6000 compression=1.9 relaxation=2
var gripR
#https://www.youtube.com/watch?v=D_lvkcjC2Ls

#using gui solution for bouncing VehicleBody3D > RigidBody3D > Physics Material Override > Bounce (0 - 1 values) 0.8 is nice, this works with native coll!
#https://www.youtube.com/watch?v=jrUsf1eS8iE

@export var MAX_ENGINE_FORCE = 700.0 #165HP for 1972 Porsche Base Model 911 Targa with 2.7L flat six engine
@export var MAX_BRAKE_FORCE = 50.0
#make sure to set these in GUI, leave code values as is here as reference from tutorial
@export var gear_ratios : Array = [ 2.69, 2.01, 1.59, 1.32, 1.13, 1.0 ]
#T56 transmission = [ 2.66, 1.78, 1.3, 1, 0.74, 0.5 ]
#Targa transmission = [ 3.18, 1.83, 1.36, 1.03, 0.79, 0.5 ] #0.5 6th gear is assumed but Targa has a 5speed
#Mclaren transmission = [ 3.23, 2.19, 1.71, 1.39, 1.16, 0.93 ] with rear gears 2.37:1 with 618HP with 0.31 meter radius wheels
#1997 McLaren F1 with a 17-inch wheel and a tire size of 235/40R17, is approximately 309.9 millimeters, total car 1,138 kg (using Lambo GT engine FX)
@export var reverse_ratio : float = -2.5
@export var final_drive_ratio : float = 3.38 #rear gears? like 3.73 or 4.10 according to GPT... targa has 3.89
@export var max_engine_rpm : float = 8000.0 #6500 targa redline
@export var power_curve : Curve

var current_gear = 0 # -1 reverse, 0 = neutral, 1 - 6 = gear 1 to 6.
var clutch_position : float = 1.0 # 0.0 = clutch engaged
var current_speed_mps = 0.0
@onready var last_pos = position

var gear_shift_time = 0.3
var gear_timer = 0.0

#Tracking bounce variables to play crash sound
var previous_velocity: Vector3 = Vector3.ZERO
@export var speed_threshold: float = 1.0  # Minimum speed to consider bounce detection #was 10
@export var direction_change_threshold: float = 1.0  # Minimum difference in speed to consider it a bounce #was 20
@export var direction_change_explode: float = 30.0  # custom car go boom-boom thing i made


func _physics_process(delta):
	NfsgpSingleton.player_position = global_position #this is used for pursuit vehicle tracking & the review mirror
	NfsgpSingleton.player_rotation = global_rotation #this is used for the review mirror

	#Tracking bounce to play crash sound
	var current_velocity = linear_velocity
	var current_speed = current_velocity.length()
	if current_speed > speed_threshold: # ignores small movements
		var velocity_difference = (current_velocity - previous_velocity).length()
		if velocity_difference > direction_change_explode && NfsgpSingleton.carExploding == false: #doesn't interrupt if already in explosion
			NfsgpSingleton.carExploding  = true #see code in Vehicle_camera_pivotNode3D.gd
			#print("EXPLOSION occurred! Previous velocity: ", previous_velocity, ", Current velocity: ", current_velocity)
		else: #if only a minor crash, it'll probably buff out.
			if velocity_difference > direction_change_threshold && NfsgpSingleton.carExploding == false:
				#print("Bounce occurred! Previous velocity: ", previous_velocity, ", Current velocity: ", current_velocity)
				$CarCrash_AudioStreamPlayer3D.play()

	previous_velocity = current_velocity # Update previous_velocity for the next frame


	#The rest of the vehicle motion code
	steering = lerp(steering, Input.get_axis("right", "left") * 0.4, 5 * delta)

	#https://www.youtube.com/watch?v=oDSc3vZEm04&t=48s
	#Tire smoke on traction loss
	gripR = rearRightWheel.get_skidinfo() # Gets the wheel slip / skid info
	if gripR < 0.3: #Turn on smoke
		rearRightSmoke.emitting = true
		rearLeftSmoke.emitting = true
		if not $TireScreech_AudioStreamPlayer3D.playing:
			$TireScreech_AudioStreamPlayer3D.play()
	else: #Turn off smoke
		rearRightSmoke.emitting = false
		rearLeftSmoke.emitting = false
		$TireScreech_AudioStreamPlayer3D.stop()
	
	
	#new transmission code:
	_process_gear_inputs(delta)
	current_speed_mps = (position - last_pos).length() / delta # how fast are we going in meters per second?
	
	# get our keyboard/joystick inputs
	var throttle_val = NfsgpInputMap.get_throttle_input()
	var brake_val = NfsgpInputMap.get_brake_input()
	var ebrake_val = NfsgpInputMap.get_ebrake_input()
	
	var rpm = calculate_rpm()
	NfsgpSingleton.globalRedLine = max_engine_rpm #provide global for engine audio
	var rpm_factor = clamp(rpm / max_engine_rpm, 0.0, 1.0)
	var power_factor = power_curve.sample_baked(rpm_factor)
	
	if current_gear == -1:
		engine_force = clutch_position * throttle_val * power_factor * reverse_ratio * final_drive_ratio * MAX_ENGINE_FORCE
	elif current_gear > 0 and current_gear <= gear_ratios.size():
		engine_force = clutch_position * throttle_val * power_factor * gear_ratios[current_gear - 1] * final_drive_ratio * MAX_ENGINE_FORCE
	else:
		engine_force = 0.0

	if NfsgpSingleton.startLineCams == true: #force breaks when 3,2,1 starting see NFSGP_VehicleStart.gd
		#brake_val = 1.0 #replaced with e brake so textures look nicer
		ebrake_val = 1.0
		current_gear = 0

	# Handle normal braking (isolated from e-brake, still tied to brake_val)
	brake = brake_val * MAX_BRAKE_FORCE
	if brake_val > 0.1:
		brakeLights.set_visible(true)
		rearRightWheel.brake = brake  # Normal brakes applied to all wheels
		rearLeftWheel.brake = brake
	else:
		brakeLights.set_visible(false)
		rearRightWheel.brake = 0  # Release normal brakes from rear wheels
		rearLeftWheel.brake = 0

	# Handle E-brake logic, allowing e-brake to be applied with throttle
	if ebrake_val:  # E-brake can apply even when throttle is pressed (though it isn't very effective)
		rearRightWheel.brake = MAX_BRAKE_FORCE * 2  # Apply e-brake only when spacebar is pressed
		rearLeftWheel.brake = MAX_BRAKE_FORCE * 2
		#print("E-brake applied to rear wheels")
	else:
		# Only reset e-brake if normal brake is not being applied
		if brake_val <= 0.1:
			rearRightWheel.brake = 0
			rearLeftWheel.brake = 0

	if current_gear == -1:
		reverseLights.set_visible(true)
	else:
		reverseLights.set_visible(false)
		
	last_pos = position # remember where we are for speed measurements
	
	NfsgpSingleton.globalRPM = rpm #update HUD with new RPM w/ transmission
	NfsgpSingleton.globalSpeed = round(current_speed_mps * 2.237) #convert from meters to MPH
	
	#set snow to fall at different amounts based off vehicle elevation for mystic peaks
	if NfsgpSingleton.track == "Track_NFS2_TR07_MysticPeaks":
		if round(position.y) > 94: #elevation 94 for vehicle min
			#NfsgpSingleton.snowFX = round(position.y) + 500 #doesn't look good, refreshes/reloads each Y change
			NfsgpSingleton.snowFX = 600 #currently hard coded, but looks nice
		else:
			NfsgpSingleton.snowFX = 10 #must be min 1 or game will crash, currently looks nice even in tunnels at 10
	else:
		NfsgpSingleton.snowFX = 100 #reset back to normal for other tracks

#	#play falling sound and restart race if car falls off the world
	NfsgpSingleton.vehicleElevation = round(position.y) #set vehicle y since camera y never changes
	if round(position.y) < -100: #Lost Canyons -92, LastResort lowest is -52, MysticPeaks starts at elevation -1 ish
		current_gear = 0 #cut the engine to reduce clashing audio
	#see the rest of the code in camera_pivotNode3D for restart_Race()

# Update current transmission gear with shift delay for realism
func _process_gear_inputs(delta : float):
	if gear_timer > 0.0:
		gear_timer = max(0.0, gear_timer - delta)
		clutch_position = 0.0
	else:
		if NfsgpInputMap.get_shift_down() and current_gear > -1:
			if (NfsgpSingleton.globalSpeed > 20) and (current_gear < 2):
				pass #quality of life improvement: don't downshift into N or R if moving too fast
			else:
				current_gear = current_gear - 1
				gear_timer = gear_shift_time
				clutch_position = 0.0
				if not $GearShift_AudioStreamPlayer2D.playing:
					$GearShift_AudioStreamPlayer2D.play()
		elif NfsgpInputMap.get_shift_up() and current_gear < gear_ratios.size():
			current_gear = current_gear + 1
			gear_timer = gear_shift_time
			clutch_position = 0.0
			if not $GearShift_AudioStreamPlayer2D.playing:
				$GearShift_AudioStreamPlayer2D.play()
		else:
			clutch_position = 1.0
	NfsgpSingleton.globalGear = current_gear #update HUD current gear

# calculate the RPM of our engine based on the current velocity of our car
func calculate_rpm() -> float:
	# if we are in neutral, no rpm
	if current_gear == 0:
		return 0.0
	
	var wheel_circumference : float = 2.0 * PI * rearRightWheel.wheel_radius
	var wheel_rotation_speed : float = 60.0 * current_speed_mps / wheel_circumference
	var drive_shaft_rotation_speed : float = wheel_rotation_speed * final_drive_ratio
	if current_gear == -1:
		# we are in reverse
		return drive_shaft_rotation_speed * -reverse_ratio
	elif current_gear <= gear_ratios.size():
		return drive_shaft_rotation_speed * gear_ratios[current_gear - 1]
	else:
		return 0.0
