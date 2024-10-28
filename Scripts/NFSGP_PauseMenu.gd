extends Node2D
@onready	var audioBtnHover = get_node("SapphireControl/AudioUI/AudioBtnHover")
@onready	var audioBtnPressed = get_node("SapphireControl/AudioUI/AudioBtnPressed")
#@onready	var audioBtnError = get_node("SapphireControl/AudioUI/AudioBtnError")
@onready	var audioBtnCoin = get_node("SapphireControl/AudioUI/AudioBtnCoin")
@onready	var audioBtnRace = get_node("SapphireControl/AudioUI/AudioBtnRace")
@onready	var loadingMainMenu = get_node("SapphireControl/LoadingTextureRect")
@onready	var pauseMenuNode = get_parent().get_node("NFSGP_PauseMenu")

func audioPlayMouseOver(): #Sudo-GameDev function to reduce lines repeat lines of code for buttons
	var sound_has_played = false
	if !sound_has_played:
		sound_has_played = true
		audioBtnHover.play()

func _on_resume_btn_pressed():
		audioBtnCoin.play()
		pauseMenuNode.set_visible(false)
func _on_resume_btn_mouse_entered():
	audioPlayMouseOver()

func _on_main_menu_btn_pressed():
		audioBtnPressed.play()
		loadingMainMenu.set_visible(true)
		await audioBtnPressed.finished
		get_tree().change_scene_to_file("res://Scenes/NFSGP_MainMenu_GD4.tscn")
func _on_main_menu_btn_mouse_entered():
	audioPlayMouseOver()

func _on_restart_btn_pressed():
	audioBtnRace.play() #only plays part of it before scene resets...
	loadingMainMenu.set_visible(true)
	await audioBtnRace.finished
	print( "Restart Application Button pressed with return code " + str( get_tree().reload_current_scene() ) ) #using print to debug return value
func _on_restart_btn_mouse_entered():
	audioPlayMouseOver()

func _on_quit_btn_pressed():	
	print("QUIT TO SYSTEM button pressed")
	audioBtnPressed.play()
	loadingMainMenu.set_visible(true)
	await audioBtnPressed.finished
	get_tree().quit()
func _on_quit_btn_mouse_entered():
	audioPlayMouseOver()
