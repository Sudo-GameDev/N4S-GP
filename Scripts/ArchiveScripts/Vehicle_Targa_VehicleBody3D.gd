extends VehicleBody3D
#https://www.youtube.com/watch?v=ib4lkBURb0M

var max_torque = 300 #was 100
var max_rpm = 1000 #was 500

var gripR #Sudo-GameDev changed wheels Friction Slip from default 10.5 in inspector, 0.5 for burn outs, 1.0 is normal
#https://www.youtube.com/watch?v=D_lvkcjC2Ls

@onready var rearLeftWheel = get_node("RLW_VehicleWheel3D")
@onready var rearRightWheel = get_node("RRW_VehicleWheel3D")
@onready var rearLeftSmoke = get_node("RLW_VehicleWheel3D/RLW_Smoke")
@onready var rearRightSmoke = get_node("RRW_VehicleWheel3D/RRW_Smoke")

#existing tire smoke code
func _physics_process(delta):
	steering = lerp(steering, Input.get_axis("right", "left") * 0.4, 5 * delta)
	var acceleration = Input.get_axis("back", "forward")
	var rpm = abs(rearLeftWheel.get_rpm())
	rearLeftWheel.engine_force = acceleration * max_torque * (1 - rpm / max_rpm)
	rpm = abs(rearRightWheel.get_rpm())
	rearRightWheel.engine_force = acceleration * max_torque * (1 - rpm / max_rpm)

	#set singleton RPM for engine noise
	NfsgpSingleton.globalRPM = rpm

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
