extends Node3D
#see NFSGP_VehicleStart for dynamic vehicle loading code, used so each track can have its own coords

func _ready():
	#dynamically load track once selection is made
	var track_path = ""
	match NfsgpSingleton.track:
		"Track_NFS2_TR00_ProvingGrounds":
			track_path = "res://Scenes/Track_NFS2_TR00_ProvingGrounds.tscn"
		"Track_NFS2_TR04_LastResort":
			track_path = "res://Scenes/Track_NFS2_TR04_LastResort.tscn"
		"Track_NFS2_TR07_MysticPeaks":
			track_path = "res://Scenes/Track_NFS2_TR07_MysticPeaks.tscn"
		"Track_NFS4_01_Hometown":
			track_path = "res://Scenes/Track_NFS4_01_Hometown.tscn"
		"Track_NFS4_02_RedrockRidge":
			track_path = "res://Scenes/Track_NFS4_02_RedrockRidge.tscn"
		"Track_NFS4_03_Atlantica":
			track_path = "res://Scenes/Track_NFS4_03_Atlantica.tscn"
		"Track_NFS4_04_RockyPass":
			track_path = "res://Scenes/Track_NFS4_04_RockyPass.tscn"
		"Track_NFS4_05_CountryWoods":
			track_path = "res://Scenes/Track_NFS4_05_CountryWoods.tscn"
		"Track_NFS4_06_LostCanyons":
			track_path = "res://Scenes/Track_NFS4_06_LostCanyons.tscn"
		"Track_NFS4_07_Aquatica":
			track_path = "res://Scenes/Track_NFS4_07_Aquatica.tscn"
		"Track_NFS4_08_TheSummit":
			track_path = "res://Scenes/Track_NFS4_08_TheSummit.tscn"
		"Track_NFS4_09_EmpireCity":
			track_path = "res://Scenes/Track_NFS4_09_EmpireCity.tscn"
		"Track_Simpsons_Racetrack":
			track_path = "res://Scenes/Track_Simpsons_Racetrack.tscn"
	if track_path != "":
		var trackScene = load(track_path) # only loading track when needed for 10seconds vs 50seconds load time
		var track_instance = trackScene.instantiate()
		
		# Set position and rotation here (not needed if adding to startingNode since it has its own)
		track_instance.transform.origin = Vector3(0, 0, 0)
		track_instance.rotation_degrees = Vector3(0, 0, 0)
		
		add_child(track_instance)
	else:
		print("No track was selected to load.")


func _process(_delta):
	## Calculate the camera's new position based on the player's position and the offset
	#var camera_offset = Vector3(0, 1, -2)  # Adjust these values based on your desired offset (camera offset in GUI editor is ignored?)
	#var player_position = NfsgpSingleton.player_position  # Access the player position from the singleton
#
	## Set the camera's position by adding the offset to the player position
	#$SubViewportContainer/SubViewport/Mirror_FixedCamera3D.transform.origin = player_position + camera_offset
	
	# Calculate the camera's new position based on the player's position and the offset
	var camera_offset = Vector3(0, 1, -2)  # Adjust these values based on your desired offset
	var player_position = NfsgpSingleton.player_position  # Access the player position from the singleton
	var player_rotation = NfsgpSingleton.player_rotation  # Access the player rotation from the singleton

	# Set the camera's position by adding the offset to the player position
	var camera_position = player_position + camera_offset

	# Create a Basis from the player's rotation in radians
	var camera_basis = Basis()
	camera_basis = camera_basis.rotated(Vector3(0, 1, 0), player_rotation.y)  # Yaw rotation
	camera_basis = camera_basis.rotated(Vector3(1, 0, 0), player_rotation.x)  # Pitch rotation
	camera_basis = camera_basis.rotated(Vector3(0, 0, 1), player_rotation.z)  # Roll rotation

	# Create a new Transform3D for the camera
	var camera_transform = Transform3D(camera_basis, camera_position)

	# Assign the new transform to the camera
	$SubViewportContainer/SubViewport/Mirror_FixedCamera3D.transform = camera_transform


	
	
	#load and unload pause menu using the ESC key on top of everything
	if Input.is_action_just_pressed("pause"):
		if $NFSGP_PauseMenu.is_visible_in_tree():
			$AudioBtnCoin.play()
			$NFSGP_PauseMenu.set_visible(false)
			#get_tree().paused = false #used to pause entire scene, but also pauses menu??
			#vehicleIROCNode.get_tree().paused = false # also didn't work
		else:
			$AudioBtnCoin.play()
			$NFSGP_PauseMenu.set_visible(true)
