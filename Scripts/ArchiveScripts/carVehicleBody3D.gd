extends VehicleBody3D

#turned off for IROC Camaro
#var max_rpm = 500
#var max_torque = 200
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	steering = lerp(steering, Input.get_axis("right", "left") * 0.4, 5 * delta)
#	var acceleration = Input.get_axis("back","forward")
#	var rpm = abs($back_left_VehicleWheel3D.get_rpm())
#	$back_left_VehicleWheel3D.engine_force = acceleration * max_torque * (1 - rpm / max_rpm)
#	rpm = abs($back_right_VehicleWheel3D.get_rpm())
#	$back_right_VehicleWheel3D.engine_force = acceleration * max_torque * (1 - rpm / max_rpm)



#reference code from 3.4.2

#turned off for lilbandit
#func _physics_process(delta):
#	steer = lerp(steer, Input.get_axis("right", "left") * 0.4, 5 * delta)
#	steering = steer 
#	var acceleration = Input.get_axis("back", "forward")
#	var rpm = abs($back_left_wheel.get_rpm())
#	$back_left_wheel.engine_force = acceleration * max_torque * (1 - rpm / max_rpm)
#	rpm = abs($back_right_wheel.get_rpm())
#	$back_right_wheel.engine_force = acceleration * max_torque * (1 - rpm / max_rpm)	
#
