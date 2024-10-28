extends Node3D

@onready	var rpmHUDvalue = get_node("SapphireControl/RPMbigLbl") 
@onready	var rpmHUDbigTxt = get_node("SapphireControl/RPMtxtLbl")
@onready	var rpmHUDsmallTxt = get_node("SapphireControl/RPMsmallLbl")
@onready	var speedHUDvalue = get_node("SapphireControl/SpeedLbl")
@onready	var lapTimeHUD = get_node("SapphireControl/LapTimeLbl")
@onready	var lapRecordHUD = get_node("SapphireControl/LapRecordLbl")
@onready	var jskDebugUiNode2D = get_node("SapphireControl/JSKdebugUiNode2D")
@onready	var lapStartTime = Time.get_time_dict_from_system() #replace with 3, 2, 1, GO! in future, then start timer
@onready	var timerHundredth = 0.00
@onready	var timerLastSecond
@onready	var timerHundredthAccumulated = 0.0
@onready	var lastLapRecord = NfsgpSingleton.currentLapRecord #get inital hard coded records
@onready	var lapCounterHUD = get_node("SapphireControl/LapNumLbl")

func _ready():
	if NfsgpSingleton.developerMode:
		jskDebugUiNode2D.set_visible(true)
	NfsgpSingleton.NewLapRecordAward = false #reset on new level load
	NfsgpSingleton.currentLap = 1 #reset on new level load

func _process(delta):
	#check if lap record has changed by player
	if lastLapRecord != NfsgpSingleton.currentLapRecord or NfsgpSingleton.currentLapReset ==true:
		lapStartTime = Time.get_time_dict_from_system() #reset main lap timer
		lastLapRecord = NfsgpSingleton.currentLapRecord #set current to keep loop happy
		NfsgpSingleton.currentLapReset = false
		
	if NfsgpSingleton.NewLapRecordAward == true: #can't move above since it puts inital record as yellow...
		lapRecordHUD.set("theme_override_colors/font_color", Color(1, 1, 0))  # Yellow
	
	# Update Lap Counter Display
	lapCounterHUD.text = "%d / %d Laps" % [NfsgpSingleton.currentLap, NfsgpSingleton.totalLaps]
	
	#setup HUD gears & RPM with value 0.1 x1000 format, example 6.5 = 6500RPM
	rpmHUDvalue.text = str(NfsgpSingleton.HeadsUpDisplayRPM) #update text value
	#var rpm_value = float(NfsgpSingleton.HeadsUpDisplayRPM) #change text color as RPM rises
	var rpm_value = NfsgpSingleton.HeadsUpDisplayRPM as float #change text color as RPM rises
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
	lapRecordHUD.text = NfsgpSingleton.currentLapRecord #set by track and/or player in NFSGP_LapRecord
	lapTimeHUD.text = format_elapsed_time(lapStartTime, lapEndTime)
	NfsgpSingleton.currentLapTime = format_elapsed_time(lapStartTime, lapEndTime) #used for lap record tracking
	if timerLastSecond != lapEndTime["second"]:
		timerHundredthAccumulated = 0.0 # Reset the accumulator each second that passes
		timerLastSecond = lapEndTime["second"]


#set current gear in HUD a different color to stand out more
func update_HUD_transmission_gear_colors():
	var gearLabels = [
		get_node("SapphireControl/TransmissionGear/GearNeutralLbl"),  # 0
		get_node("SapphireControl/TransmissionGear/Gear1Lbl"),		# 1
		get_node("SapphireControl/TransmissionGear/Gear2Lbl"),		# 2
		get_node("SapphireControl/TransmissionGear/Gear3Lbl"),		# 3
		get_node("SapphireControl/TransmissionGear/Gear4Lbl"),		# 4
		get_node("SapphireControl/TransmissionGear/Gear5Lbl"),		# 5
		get_node("SapphireControl/TransmissionGear/Gear6Lbl"),		# 6
		get_node("SapphireControl/TransmissionGear/GearReverseLbl")   # -1
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
	var guiRedLine = NfsgpSingleton.globalRedLine * 0.001
	if rpm_value >= (guiRedLine - (guiRedLine * 0.09)): # 5000 through 5400 RPM red setup as a ratio to work for others
		node.set("theme_override_colors/font_color", Color(1, 0, 0))  # Red
	elif rpm_value >= (guiRedLine * 0.81): #4500 yellow through 5000 redline setup as a ratio to work for others
		node.set("theme_override_colors/font_color", Color(1, 1, 0))  # Yellow
	else:
		node.set("theme_override_colors/font_color", null)  # Default

func format_elapsed_time(start, finish) -> String:
	var elapsed_seconds = (finish["hour"] - start["hour"]) * 3600 + (finish["minute"] - start["minute"]) * 60 + finish["second"] - start["second"]
	var minutes = elapsed_seconds / 60
	var seconds = elapsed_seconds % 60
	return "%d:%02d.%02d" % [minutes, seconds, timerHundredth]

# Converts a time string formatted as "MM:SS.MM" to seconds (as a float).
func time_string_to_seconds(time_string):
	var parts = time_string.split(":")
	if parts.size() != 2:
		return null
	var minutes_part = parts[0]
	var seconds_part = parts[1]
	if !minutes_part.is_valid_float() or !seconds_part.is_valid_float():
		return null

	var minutes = float(minutes_part)
	var seconds = float(seconds_part)
	var total_seconds = minutes * 60.0 + seconds
	return total_seconds
