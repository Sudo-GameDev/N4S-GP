extends VehicleBody3D
#https://www.youtube.com/watch?v=ib4lkBURb0M
#https://www.youtube.com/watch?v=10ER8VbkicE&list=PLe63S5Eft1KapdW0-o824gCbG8LPvzxSA&index=8
@onready	var brakeLights = get_node("BrakeLights")
@onready	var reverseLights = get_node("ReverseLights")

#use high traction wheels (friction slip 1.1) for testing, then reduce once power curve set
#use stock cars in force and reference the power curve, 0-1 in godot = power / redline in forza curve
#IROC weight is 3400LBS or 1542 kg but godot seems to not like that, faking value for now.
#IROC topspeed is 130-140MPH depending on model
#Sudo-GameDev changed wheels Friction Slip from default 10.5 in inspector, 0.75 for burn outs, 1.0 is normal
#old test values: radius=0.333 rssssest legnth=0.25 friction slip= 0.75 travel=0.25 stiffness=50 max force=6000 compression=1.9 relaxation=2
var gripR
#https://www.youtube.com/watch?v=D_lvkcjC2Ls

@export var MAX_ENGINE_FORCE = 700.0 #215HP for IROC Tuned Port Injection LB9 TPI 305 (5.0L V8) 
@export var MAX_BRAKE_FORCE = 50.0
#make sure to set these in GUI, leave code values as is here as reference from tutorial
@export var gear_ratios : Array = [ 2.69, 2.01, 1.59, 1.32, 1.13, 1.0 ]
#T56 transmission = [ 2.66, 1.78, 1.3, 1, 0.74, 0.5 ]
#T5 transmission = [ 2.95, 1.94, 1.34, 1, 0.63, 0.5 ] #0.5 6th gear is assumed but T5 is a 5speed
@export var reverse_ratio : float = -2.5
@export var final_drive_ratio : float = 3.38 #rear gears? like 3.73 or 4.10 according to GPT...
@export var max_engine_rpm : float = 8000.0
@export var power_curve : Curve

var current_gear = 0 # -1 reverse, 0 = neutral, 1 - 6 = gear 1 to 6.
var clutch_position : float = 1.0 # 0.0 = clutch engaged
var current_speed_mps = 0.0
@onready var last_pos = position

var gear_shift_time = 0.3
var gear_timer = 0.0

func _physics_process(delta):
	steering = lerp(steering, Input.get_axis("right", "left") * 0.4, 5 * delta)

#https://www.youtube.com/watch?v=oDSc3vZEm04&t=48s
	#Tire smoke on traction loss
	gripR = $RRW_VehicleWheel3D.get_skidinfo() # Gets the wheel slip / skid info
	if gripR < 0.3: #Turn on smoke
		$RRW_Smoke.emitting = true
		$RLW_Smoke.emitting = true
		if not $TireScreech_AudioStreamPlayer3D.playing:
			$TireScreech_AudioStreamPlayer3D.play()
	else: #Turn off smoke
		$RRW_Smoke.emitting = false
		$RLW_Smoke.emitting = false
		$TireScreech_AudioStreamPlayer3D.stop()
	
	
	#new transmission code:
	_process_gear_inputs(delta)
	current_speed_mps = (position - last_pos).length() / delta # how fast are we going in meters per second?
	
	# get our keyboard/joystick inputs
	var throttle_val = NfsgpInputMap.get_throttle_input()
	var brake_val = NfsgpInputMap.get_brake_input()
	
	var rpm = calculate_rpm()
	var rpm_factor = clamp(rpm / max_engine_rpm, 0.0, 1.0)
	var power_factor = power_curve.sample_baked(rpm_factor)
	
	if current_gear == -1:
		engine_force = clutch_position * throttle_val * power_factor * reverse_ratio * final_drive_ratio * MAX_ENGINE_FORCE
	elif current_gear > 0 and current_gear <= gear_ratios.size():
		engine_force = clutch_position * throttle_val * power_factor * gear_ratios[current_gear - 1] * final_drive_ratio * MAX_ENGINE_FORCE
	else:
		engine_force = 0.0
	
	brake = brake_val * MAX_BRAKE_FORCE
	if brake_val > 0.1:
		brakeLights.set_visible(true)
	else:
		brakeLights.set_visible(false)
	#if current_gear == -1 > 0.1:
	if current_gear == -1:
		reverseLights.set_visible(true)
	else:
		reverseLights.set_visible(false)
		
	last_pos = position # remember where we are for speed measurements
	
	NfsgpSingleton.globalRPM = rpm #update HUD with new RPM w/ transmission
	NfsgpSingleton.globalSpeed = round(current_speed_mps * 2.237) #convert from meters to MPH
	
	#set snow to fall at different amounts based off vehicle elevation
	if round(position.y) > 94: #elevation 94 for vehicle min
		#NfsgpSingleton.snowFX = round(position.y) + 500 #doesn't look good, refreshes/reloads each Y change
		NfsgpSingleton.snowFX = 600 #currently hard coded, but looks nice
	else:
		NfsgpSingleton.snowFX = 10 #must be min 1 or game will crash, currently looks nice even in tunnels at 10
		
#	#play falling sound and restart race if car falls off the world
	NfsgpSingleton.vehicleElevation = round(position.y) #set vehicle y since camera y never changes
	if round(position.y) < -10: #MysticPeaks starts at elevation -1 ish
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
	
	var wheel_circumference : float = 2.0 * PI * $RRW_VehicleWheel3D.wheel_radius
	var wheel_rotation_speed : float = 60.0 * current_speed_mps / wheel_circumference
	var drive_shaft_rotation_speed : float = wheel_rotation_speed * final_drive_ratio
	if current_gear == -1:
		# we are in reverse
		return drive_shaft_rotation_speed * -reverse_ratio
	elif current_gear <= gear_ratios.size():
		return drive_shaft_rotation_speed * gear_ratios[current_gear - 1]
	else:
		return 0.0
