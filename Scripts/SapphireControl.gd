extends Control
#https://godotengine.org/qa/84651/how-to-add-sound-to-button-when-it-is-clicked-in-the-menu-godot

#fire tutorial
#https://www.youtube.com/watch?v=R3xMwfrlTI8&pp=ygUMZ29kb3QgNCBmaXJl

@onready	var audioBkMusic = get_parent().get_node("SapphireControl/AudioUI/BkAudioStreamPlayer")
@onready	var audioBtnHover = get_parent().get_node("SapphireControl/AudioUI/AudioBtnHover")
@onready	var audioBtnPressed = get_parent().get_node("SapphireControl/AudioUI/AudioBtnPressed")
@onready	var audioBtnError = get_parent().get_node("SapphireControl/AudioUI/AudioBtnError")
@onready	var audioBtnCoin = get_parent().get_node("SapphireControl/AudioUI/AudioBtnCoin")
@onready	var audioBtnDev = get_parent().get_node("SapphireControl/AudioUI/AudioBtnDev")
@onready	var vehicleOptBtn = get_parent().get_node("SapphireControl/VehicleOptBtn")
@onready	var trackOptBtn = get_parent().get_node("SapphireControl/TrackOptBtn")
@onready	var audioBtnRace = get_parent().get_node("SapphireControl/AudioUI/AudioBtnRace")
@onready	var trackRichTextLbl = get_parent().get_node("SapphireControl/MiscTxt/TrackRichTextLbl")

# Loading Screen Dynamically changes based off track picked
var loading_texture_rect: TextureRect

func _ready():
	loading_texture_rect = $LoadingTextureRect
	
	NfsgpSingleton.developerMode = false #reset to false on boot

func _on_nfs_4_video_stream_player_finished():
	$NFS4VideoStreamPlayer.play() #loop background video

func _on_BkAudioStreamPlayer_finished():
	audioBkMusic.play() #loop background music

func audioPlayMouseOver(): #Sudo-GameDev function to reduce lines repeat lines of code for buttons
	var sound_has_played = false
	if !sound_has_played:
		sound_has_played = true
		audioBtnHover.play()

func _on_track_opt_btn_mouse_entered():
	audioPlayMouseOver()
func _on_track_opt_btn_pressed():
	audioBtnCoin.play()

func _on_vehicle_opt_btn_mouse_entered():
	audioPlayMouseOver()
func _on_vehicle_opt_btn_pressed():
	audioBtnCoin.play()

func _on_dev_btn_mouse_entered():
	audioPlayMouseOver()
func _on_dev_btn_pressed():
	audioBtnDev.play()
	audioBkMusic.stop() #stop normal background music
	$DevelopersVid.play() #tell em who matters steve!
	# Loop through all the items to enable tracks & vehicles for testing
	for i in range(trackOptBtn.get_item_count()):
		trackOptBtn.set_item_disabled(i, false)
	for i in range(vehicleOptBtn.get_item_count()):
		vehicleOptBtn.set_item_disabled(i, false)
	NfsgpSingleton.developerMode = true


func _on_race_btn_mouse_entered():
	audioPlayMouseOver()
func _on_race_btn_pressed():
	if trackOptBtn.get_item_text(trackOptBtn.get_selected_id()) == "Track / Map Selection:" or vehicleOptBtn.get_item_text(vehicleOptBtn.get_selected_id()) == "Vehicle Selection:":
		await get_tree().create_timer(0.3).timeout #put delay to workaround bug that plays this after loading track & car anyway...
		audioBtnError.play()
	else:
		audioBtnRace.play()
		#trackRichTextLbl.set_visible(false)
		$LoadingTextureRect.set_visible(true)
		await audioBtnRace.finished
		get_tree().change_scene_to_file("res://Scenes/NFSGP_GameLoader.tscn")


func _on_track_opt_btn_item_selected(_index): #on select Track
	audioBtnDev.play()
	#use text string as track string example:
	#NfsgpSingleton.track = trackOptBtn.get_item_text(trackOptBtn.get_selected_id()) #set global track variable
	trackRichTextLbl.set_visible(true)
	
	#set track description text and set global variable (See GameLoader for track loading code as well)
	var texture_path = ""
	match trackOptBtn.get_item_text(trackOptBtn.get_selected_id()):
		"Proving Grounds (AI Upscaled Textures)":
			NfsgpSingleton.track = "Track_NFS2_TR00_ProvingGrounds"
			texture_path = "res://Assets/Textures/LoadingScreens/Track_NFS2_TR00_ProvingGrounds.png"
		"Last Resort":
			NfsgpSingleton.track = "Track_NFS2_TR04_LastResort"
			texture_path = "res://Assets/Textures/LoadingScreens/Track_NFS2_TR04_LastResort.png"
		"Mystic Peaks (AI Upscaled Textures)":
			NfsgpSingleton.track = "Track_NFS2_TR07_MysticPeaks"
			texture_path = "res://Assets/Textures/LoadingScreens/Track_NFS2_TR07_MysticPeaks.png"
		"Hometown (AI Upscaled Textures)":
			NfsgpSingleton.track = "Track_NFS4_01_Hometown"
			texture_path = "res://Assets/Textures/LoadingScreens/Track_NFS4_01_Hometown.png"
		"Redrock Ridge":
			NfsgpSingleton.track = "Track_NFS4_02_RedrockRidge"
			texture_path = "res://Assets/Textures/LoadingScreens/Track_NFS4_02_RedrockRidge.png"
		"Atlantica":
			NfsgpSingleton.track = "Track_NFS4_03_Atlantica"
			texture_path = "res://Assets/Textures/LoadingScreens/Track_NFS4_03_Atlantica.png"
		"Rocky Pass":
			NfsgpSingleton.track = "Track_NFS4_04_RockyPass"
			texture_path = "res://Assets/Textures/LoadingScreens/Track_NFS4_04_RockyPass.png"
		"Country Woods (AI Upscaled Textures)":
			NfsgpSingleton.track = "Track_NFS4_05_CountryWoods"
			texture_path = "res://Assets/Textures/LoadingScreens/Track_NFS4_05_CountryWoods.png"
		"Lost Canyons (AI Upscaled Textures)":
			NfsgpSingleton.track = "Track_NFS4_06_LostCanyons"
			texture_path = "res://Assets/Textures/LoadingScreens/Track_NFS4_06_LostCanyons.png"
		"Aquatica":
			NfsgpSingleton.track = "Track_NFS4_07_Aquatica"
			texture_path = "res://Assets/Textures/LoadingScreens/Track_NFS4_07_Aquatica.png"
		"The Summit":
			NfsgpSingleton.track = "Track_NFS4_08_TheSummit"
			texture_path = "res://Assets/Textures/LoadingScreens/Track_NFS4_08_TheSummit.png"
		"Empire City":
			NfsgpSingleton.track = "Track_NFS4_09_EmpireCity"
			texture_path = "res://Assets/Textures/LoadingScreens/Track_NFS4_09_EmpireCity.png"
		"Racetrack":
			NfsgpSingleton.track = "Track_Simpsons_Racetrack"
			texture_path = "res://Assets/Textures/LoadingScreens/Track_Simpsons_Racetrack.png"

	
	if texture_path != "":
		# Use 'load' to dynamically load the image at the given path
		var new_texture: Texture = load(texture_path) as Texture
		if new_texture:
			loading_texture_rect.texture = new_texture
		else:
			print("Failed to load texture from path: ", texture_path)
	else:
		print("No texture path is set.")


func _on_vehicle_opt_btn_item_selected(_index): #on select vehicle
	audioBtnDev.play()
	#set global vehicle (see NFSGP_VehicleStart for dynamic loading)
	match vehicleOptBtn.get_item_text(vehicleOptBtn.get_selected_id()):
		"Camaro IROC-Z":
			NfsgpSingleton.vehicle = "Vehicle_IROC"
		"Nissan 300ZX":
			NfsgpSingleton.vehicle = "Vehicle_300ZX"
		"Porsche 911 Targa":
			NfsgpSingleton.vehicle = "Vehicle_PorscheTarga"
		"McLaren F1":
			NfsgpSingleton.vehicle = "Vehicle_McLarenF1"
		"Sergeant Cross":
			NfsgpSingleton.vehicle = "Vehicle_SgtCross"

#example usage:  (migrated to NFSGP_TrackText.gd)
#trackRichTextLbl.text = get_track_info("Track_NFS2_TR00_ProvingGrounds")
#func get_track_info(track_name: String) -> String:
#	var path = "res://Assets/Text/%s.txt" % track_name
#
#	if not FileAccess.file_exists(path):
#		return "Info not available."
#
#	var file = FileAccess.open(path, FileAccess.READ)
#	var text_content = file.get_as_text()
#	file.close()
#
#	return text_content
