extends VehicleBody3D
#https://www.youtube.com/watch?v=ib4lkBURb0M

#var steer = 0
var max_torque = 300 #was 100
var max_rpm = 1000 #was 500

#Sudo-GameDev changed wheels Friction Slip from default 10.5 in inspector, 0.5 for burn outs, 1.0 is normal
var gripR
#https://www.youtube.com/watch?v=D_lvkcjC2Ls

#moved to snow node script
##check if car is in sunlight or not to determine if snow should occur
#@onready var car = $BASE_A
#@onready var sunlight = $SunDirectionalLight3D
#
#func _physics_process(delta):
#	# Perform a raycast from the car to the sunlight
#	var space_state = get_world_3d().direct_space_state
#	var params = PhysicsRayQueryParameters3D.new()
#	params.from = car.global_transform.origin
#	params.to = sunlight.global_transform.origin
#	var result = space_state.intersect_ray(params)
#
#	# If the raycast hit something before reaching the sunlight, then the car is not in direct sunlight
#	if result:
#		print("The car is not in direct sunlight.")
#	else:
#		print("The car is in direct sunlight.")

#existing tire smoke code
func _physics_process(delta):
	#steer = lerp(steer, Input.get_axis("right", "left") * 0.4, 5 * delta)
	#steering = steer 
	steering = lerp(steering, Input.get_axis("right", "left") * 0.4, 5 * delta)
	var acceleration = Input.get_axis("back", "forward")
	var rpm = abs($RLW_VehicleWheel3D.get_rpm())
	$RLW_VehicleWheel3D.engine_force = acceleration * max_torque * (1 - rpm / max_rpm)
	rpm = abs($RRW_VehicleWheel3D.get_rpm())
	$RRW_VehicleWheel3D.engine_force = acceleration * max_torque * (1 - rpm / max_rpm)
	
	#set singleton RPM for engine noise & MPH for HUD
	NfsgpSingleton.globalRPM = rpm
	NfsgpSingleton.globalSpeed = get_speed_mph(self) #Vehicle_IROC/VehicleBody3D used to test
	#print("vehicle speed is " + str(NfsgpSingleton.globalSpeed))
	#print("internal godot RPM speed is actually " + str(NfsgpSingleton.globalRPM))

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


#short Sudo-GameDev function to return speed
func get_speed_mph(vehicle: VehicleBody3D) -> float:
	# Calculate speed in meters per second
	var speed_mps = vehicle.linear_velocity.dot(vehicle.global_transform.basis.z)
	
	# Convert meters per second to miles per hour (1 m/s is approximately 2.237 mph)
	var speed_mph = round(speed_mps * 2.237)
	return speed_mph
