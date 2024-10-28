extends Node3D
#if game is really low 3FPS, make sure test car isn't in this scene, even if turned off!!!

@onready	var audioBkMusic = get_parent().get_node("AudioStreamPlayer2D")

func _ready():
	if (NfsgpSingleton.developerMode == true && audioBkMusic != null): #null check in case track doesn't have bk audio yet
		audioBkMusic.stop() #stop normal background music
	
	#dynamically load vehicle once selection is made (for best loading performance)
	var vehicle_path = ""
	match NfsgpSingleton.vehicle:
		"Vehicle_IROC":
			vehicle_path = "res://Scenes/Vehicle_IROC.tscn"
		"Vehicle_300ZX":
			vehicle_path = "res://Scenes/Vehicle_300ZX.tscn"
		"Vehicle_PorscheTarga":
			vehicle_path = "res://Scenes/Vehicle_PorscheTarga.tscn"
		"Vehicle_McLarenF1":
			vehicle_path = "res://Scenes/Vehicle_McLarenF1.tscn"
		"Vehicle_SgtCross":
			vehicle_path = "res://Scenes/Vehicle_SgtCross.tscn"

	if vehicle_path != "":
		var vehicleScene = load(vehicle_path)
		var vehicle_instance = vehicleScene.instantiate()
		
		add_child(vehicle_instance)
	else:
		print("No vehicle was selected to load.")

	#show 3, 2, 1 countdown camera views of player vehicle
	NfsgpSingleton.startLineCams = true
	$CountdownCamera3.make_current()
	await get_tree().create_timer(1.0).timeout
	$CountdownCamera2.make_current()
	await get_tree().create_timer(1.0).timeout
	$CountdownCamera1.make_current()
	await get_tree().create_timer(1.0).timeout
	NfsgpSingleton.startLineCams = false
	
