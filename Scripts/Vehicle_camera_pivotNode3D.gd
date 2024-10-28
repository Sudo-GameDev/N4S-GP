#syntax changed in GD 4
#original guide in godot 3.x uses "Spatial" which was replaced with Node3D in Godot 4
#https://www.youtube.com/watch?v=6A6tp-rKy3Y
extends Node3D

#setup dynamic speed based camera FOV:
# Minimum and Maximum FOV values
var min_fov: float = 60 #46 lowest looks good, default 75 #60 perfect
var max_fov: float = 110 #100 looked good #120 perfect
var current_fov: float = 46  # start with your minimum FOV
var min_vol: float = -80
var max_vol: float = 12 # was 24 before audio was rebalanced in buses
var current_vol: float = -80  # start with your minimum window noise volume
# Minimum and Maximum Speed values
var min_speed = 0
var max_speed = 100 # was 50
var fallingCarAudio = 0 #false
var restarting_Race: bool = false #used to address falling vehicle reset twice bug


var direction = Vector3.FORWARD
#syntax changed in GD 4
#https://www.reddit.com/r/godot/comments/m4k0rq/cant_export_vars_in_40/
#export (float,1,10,0.1) var smooth_speed = 2.5
@export_range(1, 10, 0.1) var smooth_speed: float = 2.5

func _ready():
	if NfsgpSingleton.track == "Track_NFS2_TR00_ProvingGrounds":
		$Track_FX_RainGroup.set_visible(true)
	if NfsgpSingleton.track == "Track_NFS2_TR07_MysticPeaks":
		$Track_NFS2_MysticPeaks_SnowFX.set_visible(true)
	if NfsgpSingleton.track == "Track_NFS4_05_CountryWoods":
		$Track_NFS2_MysticPeaks_SnowFX.set_visible(true)
	if NfsgpSingleton.track == "Track_NFS4_07_Aquatica":
		$Track_FX_RainGroup.set_visible(true)
	if NfsgpSingleton.track == "Track_NFS4_08_TheSummit":
		$Track_NFS2_MysticPeaks_SnowFX.set_visible(true)
	if NfsgpSingleton.track == "Track_NFS4_09_EmpireCity":
		$Track_FX_RainGroup.set_visible(true)
	
	restarting_Race = false #used to address falling vehicle reset twice bug
	NfsgpSingleton.carExploding = false #used to reset car status if level is reset
	

func _physics_process(delta):
	if NfsgpSingleton.startLineCams == false:
		$FixedCamera3D.make_current()
		#see NFSGP_VehicleStart.gd for additional starting cameras
		#future idea, make other cam views that follow car using "C" such as hood cam, dash cam, etc
	
	#print(str(NfsgpSingleton.track))
	if NfsgpSingleton.carExploding == true && not $CarExplode_AudioStreamPlayer3D.playing:
		explode_Car()
		await get_tree().create_timer(8.0).timeout #Vehicle_Explode.wav is 8 seconds total #was 6.5 shortened but seems to work fine now at 8
		$LoadingTextureRect.set_visible(true)
	
	var current_velocity = get_parent().get_linear_velocity()
	current_velocity.y = 0
	if current_velocity.length_squared() > 1:
		direction = lerp(direction, -current_velocity.normalized(), smooth_speed * delta) #was current_velocity but lil bandaid since camera backwards???
	#set the rotation of this camera_pivot to the point in the direction vector
	#problem? its a vector and we need a rotation (basis!!)
	global_transform.basis = get_rotation_from_direction(direction)
	
	#update dynamic speed based wind sound & camera FOV:
	update_camera_fov(NfsgpSingleton.globalSpeed, delta)
	update_wind_noise(NfsgpSingleton.globalSpeed, delta)
	
	#play falling sound and restart race if car falls off the world
	#Lost Canyons -92, LastResort lowest is -52, MysticPeaks starts at elevation -1 ish
	if (NfsgpSingleton.vehicleElevation < -100) && (restarting_Race == false):
		restart_Race()
		await get_tree().create_timer(9.0).timeout #give the loading screen a chance to render in time... 
		$LoadingTextureRect.set_visible(true)
	#see other code in Vehicle_VehicleBody3D.gd under NfsgpSingleton.vehicleElevation = round(position.y)

func get_rotation_from_direction(look_direction : Vector3) -> Basis:
	look_direction = look_direction.normalized()
	var x_axis = look_direction.cross(Vector3.UP)
	return Basis(x_axis, Vector3.UP, -look_direction)

#particles are very different in GD 4
#new reference video
#https://www.youtube.com/watch?v=QhntE6vOLXY

func update_camera_fov(target_speed: float, delta: float) -> void:
	var t: float = clamp((target_speed - min_speed) / (max_speed - min_speed), 0.0, 1.0)
	var target_fov: float = lerp(min_fov, max_fov, t)
	
	# Interpolate towards the target FOV over time for smoothness
	current_fov = lerp(current_fov, target_fov, delta * 2.0)
	$FixedCamera3D.fov = current_fov #need to use this cam eventually to fix backwards cam issue
	$FixedCamera3D2.fov = current_fov #set for both cameras just in case

func update_wind_noise(target_speed: float, delta: float) -> void:
	var t: float = clamp((target_speed - min_speed) / (max_speed - min_speed), 0.0, 1.0)
	var target_vol: float = lerp(min_vol, max_vol, t)
	
	# Interpolate towards the target sound volume over time for smoothness
	if NfsgpSingleton.track != "Track_NFS2_TR00_ProvingGrounds":
		current_vol = lerp(current_vol, target_vol, delta * 1.0) #set to 1 since wind needs to be instant
		$WindNoise_AudioStreamPlayer2D.volume_db = current_vol
	else:
		$WindNoise_AudioStreamPlayer2D.stop() # wind sounds would play all the time otherwise due to speed of track.

func explode_Car(): #used if car elevation drops below track
	if not $CarExplode_AudioStreamPlayer3D.playing:
		$CarExplode_AudioStreamPlayer3D.play()
		await get_tree().create_timer(1.5).timeout #beep beep beep.... oh NO...
		$CarExplosion.set_visible(true)
		await $CarExplode_AudioStreamPlayer3D.finished
		print( "Restarted Race Due to Vehicle Explosion.  So... good job I guess?   Return Code: " + str( get_tree().reload_current_scene() ) ) #using print to debug return value
		#future idea placeholder for reset car ### set prior XYZ + rotation from 1min ago
		#play windows error sound from UI? ding ding DING (wait 1 sec between each)

func restart_Race(): #used if car elevation drops below track
	if not $Falling_AudioStreamPlayer2D.playing:
		restarting_Race = true #used to address falling vehicle reset twice bug
		$WindNoise_AudioStreamPlayer2D.stop() #to reduce clashing audio
		$Falling_AudioStreamPlayer2D.play()
		await $Falling_AudioStreamPlayer2D.finished
		print( "Restart Race Due to Vehicle Falling. Return Code: " + str( get_tree().reload_current_scene() ) ) #using print to debug return value
