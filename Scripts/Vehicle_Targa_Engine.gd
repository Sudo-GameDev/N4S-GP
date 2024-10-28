extends Node3D
#https://www.youtube.com/watch?v=8S1yUrv6CBU
#1976 Porsche 911 Targa: idle 820RPM redline 6500RPM 165HP

@export var minEnginePitch = 0.58
@export var maxEnginePitch = 1.0
@export var minEngineDB: float = -10  # Minimum volume in decibels
@export var maxEngineDB: float = 1    # Maximum volume in decibels
#@export var maxEngineRedLine = 6500.0

var current_RPM = 0.0 #intally set to 0 but gets values from global in realtime

func _physics_process(_delta):
#func _process(_delta): #can't use this since it causes errors in the HUD... using physics instead
	current_RPM = NfsgpSingleton.globalRPM # get latest RPM from engine in realtime
	
	#setup HUD RPM with value 0.1 x1000 format, example 6.5 = 6500RPM
	var current_RPM_formatted = round(current_RPM / 1000 * 10) / 10.0
	if (current_RPM_formatted <= 0.8):
		current_RPM_formatted = 0.8
	NfsgpSingleton.HeadsUpDisplayRPM = "%.1f" % current_RPM_formatted
	
	update_audio_doubleSamplePitchVolInvert() #has idle and redline trade places in pitch and volume

func update_audio_doubleSamplePitchVolInvert():
	if not $RPM_0820.is_playing():
		$RPM_0820.play()
	if not $RPM_LongRedLine.is_playing():
		$RPM_LongRedLine.play()

	var engineRatio = current_RPM / NfsgpSingleton.globalRedLine #6500.0 #engineRedLine
	engineRatio = clamp(engineRatio, 0, 1)  # Ensure it's between 0 and 1

	# For RPM_0820, we move from upper pitch to lower pitch as the engine RPM increases.
	var engineSpeedIdle = lerp(maxEnginePitch, minEnginePitch, engineRatio)
	$RPM_0820.set_pitch_scale(engineSpeedIdle)

	# Adjust volume for RPM_0820, higher volume when the pitch is higher.
	var volumeIdle = lerp(maxEngineDB, minEngineDB, engineRatio)
	$RPM_0820.volume_db = volumeIdle

#	print("Set idle speed pitch to ", str(engineSpeedIdle))
#	print("Set idle volume to ", str(volumeIdle) + " dB")

	# For RPM_LongRedLine, we move from lower pitch to upper pitch as the engine RPM increases.
	var engineSpeedRedline = lerp(minEnginePitch, maxEnginePitch, engineRatio)
	$RPM_LongRedLine.set_pitch_scale(engineSpeedRedline)

	# Adjust volume for RPM_LongRedLine, lower volume when the pitch is lower.
	var volumeRedline = lerp(minEngineDB, maxEngineDB, engineRatio)
	$RPM_LongRedLine.volume_db = volumeRedline

#	print("Set redline speed pitch to ", str(engineSpeedRedline))
#	print("Set redline volume to ", str(volumeRedline) + " dB")
