extends VehicleBody3D

@onready var rearLeftWheel = get_node("RLW_VehicleWheel3D")
@onready var rearRightWheel = get_node("RRW_VehicleWheel3D")

# Your existing variables
var max_torque = 300
var max_rpm = 1000

# Variables for the bounce effect
@export var bounce_intensity = 60.0 #20.0 (100 too much, 40 too little, 50 close, 60.0 perfect) 70 works well with coll just above frame

func _physics_process(delta):
	steering = lerp(steering, Input.get_axis("right", "left") * 0.4, 5 * delta)
	var acceleration = Input.get_axis("back", "forward")
	var rpm = abs(rearLeftWheel.get_rpm())
	rearLeftWheel.engine_force = acceleration * max_torque * (1 - rpm / max_rpm)
	rpm = abs(rearRightWheel.get_rpm())
	rearRightWheel.engine_force = acceleration * max_torque * (1 - rpm / max_rpm)


#got bounce working!!! now perhaps maybe get the car to do a flip?
#secret sauce was setting signal from Area3D within VehicleBody3D back to script (attached to VehicleBody3D
#also CollisionShape3D child of Area3D was a copy of VehicleBody3D's coll but 4FPS happened, so right now its a box infront....
#also would be nice to avoid bouncing on sides for easier user experience

func _on_bounce_area_3d_body_entered(_body):
	print("Collision Detected")
	var velocity = get_linear_velocity()
	print(str(velocity) + " velocity")
	var bounce_direction = -velocity.normalized()
	var bounce_force = bounce_direction * bounce_intensity * velocity.length()
	apply_central_impulse(bounce_force)
	print(str(bounce_force) + "  bounce applied")
