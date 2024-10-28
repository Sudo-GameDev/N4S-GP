extends VehicleBody3D

@export var turnFaster: float = 0.8
@export var moPowa: float = 300
@export var detection_range: float = 100.0
@export var wait_time: float = 2.0  # Time to wait after stopping
@export var slow_down_factor: float = 50.0  # How much to reduce speed when distance increases
var spawn_position: Vector3
var last_distance: float = 0.0  # Track the last distance to the player
var stopped_timer: float = 0.0  # Timer for how long we've been stopped
var is_stopped: bool = false  # Flag to indicate if the vehicle has stopped

func _ready():
	spawn_position = global_position  # Save the spawn position of the pursuit vehicle

func _physics_process(delta):
	var player_pos = NfsgpSingleton.player_position
	var distance_to_player = global_position.distance_to(player_pos)

	# Check if within detection range
	if distance_to_player <= detection_range:
		var direction_to_player = (player_pos - global_position).normalized()
		var forward_dir = -global_transform.basis.z.normalized()

		# Steering logic
		if forward_dir.cross(direction_to_player).y > 0:
			steering = lerp(steering, -turnFaster, 10 * delta)
		else:
			steering = lerp(steering, turnFaster, 10 * delta)

		if is_stopped:
			stopped_timer += delta  # Increment the stopped timer
			
			if stopped_timer >= wait_time:
				# After waiting, resume moving forward
				is_stopped = false
				stopped_timer = 0.0  # Reset timer
				engine_force = moPowa * 0.5  # Gradually start moving forward
			else:
				engine_force = 0  # Maintain zero speed while stopped
		else:
			# Check if the distance is increasing
			if distance_to_player > last_distance:
				engine_force = max(0, engine_force - slow_down_factor * delta)  # Gradually slow down
				if engine_force == 0:
					is_stopped = true  # Stop once engine force reaches zero
					stopped_timer = 0.0  # Reset the stopped timer
			else:
				engine_force = moPowa  # Full power if getting closer
	else:
		# Reset to spawn if out of range
		global_position = spawn_position
		linear_velocity = Vector3.ZERO  # Reset velocity to zero
		steering = 0
		engine_force = 0
		is_stopped = false  # Reset stopped state
		stopped_timer = 0.0  # Reset timer when out of range

	# Update last distance for next frame
	last_distance = distance_to_player
