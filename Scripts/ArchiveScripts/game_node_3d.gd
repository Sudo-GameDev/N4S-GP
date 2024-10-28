extends Node3D

@onready	var pauseMenuNode = get_node("NFSGP_PauseMenu")
#@onready	var vehicleIROCNode = get_node("Vehicle_IROC")
@onready	var audioBtnCoin = get_node("NFSGP_PauseMenu/SapphireControl/AudioUI/AudioBtnCoin")
@onready	var rpmHUDvalue = get_node("HUD_Node2D/SapphireControl/RPMbigLbl") 
@onready	var rpmHUDbigTxt = get_node("HUD_Node2D/SapphireControl/RPMtxtLbl")
@onready	var rpmHUDsmallTxt = get_node("HUD_Node2D/SapphireControl/RPMsmallLbl")
@onready	var speedHUDvalue = get_node("HUD_Node2D/SapphireControl/SpeedLbl")
@onready	var lapTimeHUD = get_node("HUD_Node2D/SapphireControl/LapTimeLbl")
@onready	var jskDebugUiNode2D = get_node("HUD_Node2D/SapphireControl/JSKdebugUiNode2D")
@onready	var lapStartTime = Time.get_time_dict_from_system() #replace with 3, 2, 1, GO! in future, then start timer
@onready	var timerHundredth = 0.00
@onready	var timerLastSecond
@onready	var timerHundredthAccumulated = 0.0

func _ready():
	if NfsgpSingleton.developerMode:
		jskDebugUiNode2D.set_visible(true)

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		if pauseMenuNode.is_visible_in_tree():
			audioBtnCoin.play()
			pauseMenuNode.set_visible(false)
			#get_tree().paused = false #used to pause entire scene, but also pauses menu??
			#vehicleIROCNode.get_tree().paused = false # also didn't work
		else:
			audioBtnCoin.play()
			#get_tree().paused = true
			pauseMenuNode.set_visible(true)
	
	#setup HUD gears & RPM with value 0.1 x1000 format, example 6.5 = 6500RPM
	rpmHUDvalue.text = str(NfsgpSingleton.HeadsUpDisplayRPM) #update text value
	var rpm_value = float(NfsgpSingleton.HeadsUpDisplayRPM) #change text color as RPM rises
	update_label_color(rpmHUDvalue, rpm_value)
	update_label_color(rpmHUDbigTxt, rpm_value)
	update_label_color(rpmHUDsmallTxt, rpm_value)
	update_HUD_transmission_gear_colors()
	
	#update HUD speed in MPH instead of godot meters
	speedHUDvalue.text = str(NfsgpSingleton.globalSpeed) #update text value
	
	#run/update Lap Time timer
	timerHundredthAccumulated += delta
	timerHundredth = int(timerHundredthAccumulated * 100) % 100  # Convert to hundredths format
	var lapEndTime = Time.get_time_dict_from_system()
	lapTimeHUD.text = format_elapsed_time(lapStartTime, lapEndTime)
	if timerLastSecond != lapEndTime["second"]:
		timerHundredthAccumulated = 0.0 # Reset the accumulator each second that passes
		timerLastSecond = lapEndTime["second"]


#set current gear in HUD a different color to stand out more
func update_HUD_transmission_gear_colors():
	var gearLabels = [
		get_node("HUD_Node2D/SapphireControl/TransmissionGear/GearNeutralLbl"),  # 0
		get_node("HUD_Node2D/SapphireControl/TransmissionGear/Gear1Lbl"),		# 1
		get_node("HUD_Node2D/SapphireControl/TransmissionGear/Gear2Lbl"),		# 2
		get_node("HUD_Node2D/SapphireControl/TransmissionGear/Gear3Lbl"),		# 3
		get_node("HUD_Node2D/SapphireControl/TransmissionGear/Gear4Lbl"),		# 4
		get_node("HUD_Node2D/SapphireControl/TransmissionGear/Gear5Lbl"),		# 5
		get_node("HUD_Node2D/SapphireControl/TransmissionGear/Gear6Lbl"),		# 6
		get_node("HUD_Node2D/SapphireControl/TransmissionGear/GearReverseLbl")   # -1
	]
	for label in gearLabels:
		if label.text == "N" and NfsgpSingleton.globalGear == 0:
			label.set("theme_override_colors/font_color", Color(1, 0, 0))  # Red
		elif label.text == "R" and NfsgpSingleton.globalGear == -1:
			label.set("theme_override_colors/font_color", Color(1, 1, 0))  # Yellow
		elif label.text == str(NfsgpSingleton.globalGear):
			label.set("theme_override_colors/font_color", Color8(176, 176, 176))  # Using the Color8 method
			# using theme default grey here since non active gears have GUI override
		else:
			label.set("theme_override_colors/font_color", Color8(100, 100, 100)) 
			# Using the Color8 method with dark grey for the active gear
			


#Sudo-GameDev function to set text color on multiple RPM text nodes at once dynamically
func update_label_color(node: Label, rpm_value: float) -> void:
	if rpm_value >= 5.0:
		node.set("theme_override_colors/font_color", Color(1, 0, 0))  # Red
	elif rpm_value >= 4.5:
		node.set("theme_override_colors/font_color", Color(1, 1, 0))  # Yellow
	else:
		node.set("theme_override_colors/font_color", null)  # Default

func format_elapsed_time(start, finish) -> String:
	var elapsed_seconds = (finish["hour"] - start["hour"]) * 3600 + (finish["minute"] - start["minute"]) * 60 + finish["second"] - start["second"]
	var minutes = elapsed_seconds / 60
	var seconds = elapsed_seconds % 60
	return "%d:%02d.%02d" % [minutes, seconds, timerHundredth]
