extends Node3D

#water shader used for beach on LastResort
#https://www.youtube.com/watch?v=1_YxFAKPVL0

#shared audio files from NFSGP_GameLoader scene
@onready	var bestLapSound = get_parent().get_parent().get_node("LapSounds/BestLap_AudioStreamPlayer2D")
@onready	var finalLapSound = get_parent().get_parent().get_node("LapSounds/FinalLap_AudioStreamPlayer2D")
@onready	var raceWinSound = get_parent().get_parent().get_node("LapSounds/RaceWin_AudioStreamPlayer2D")
@onready	var raceBkMusic = get_parent().get_node("AudioStreamPlayer2D")
var checkpoint_passed = false

func _ready():
	#define each tracks baseline track records
	match NfsgpSingleton.track:
		"Track_NFS2_TR00_ProvingGrounds":
			NfsgpSingleton.currentLapRecord = "01:18.23"
		"Track_NFS2_TR04_LastResort":
			NfsgpSingleton.currentLapRecord = "10:23.69"
		"Track_NFS2_TR07_MysticPeaks":
			NfsgpSingleton.currentLapRecord = "10:23.69"
		"Track_NFS4_01_Hometown":
			NfsgpSingleton.currentLapRecord = "02:20.18"
		"Track_NFS4_02_RedrockRidge":
			NfsgpSingleton.currentLapRecord = "03:34.94"
		"Track_NFS4_03_Atlantica":
			NfsgpSingleton.currentLapRecord = "03:21.17"
		"Track_NFS4_04_RockyPass":
			NfsgpSingleton.currentLapRecord = "04:41.10"
		"Track_NFS4_05_CountryWoods":
			NfsgpSingleton.currentLapRecord = "03:49.40"
		"Track_NFS4_06_LostCanyons":
			NfsgpSingleton.currentLapRecord = "04:34.15"
		"Track_NFS4_07_Aquatica":
			NfsgpSingleton.currentLapRecord = "04:34.25"
		"Track_NFS4_08_TheSummit":
			NfsgpSingleton.currentLapRecord = "05:05.69"
		"Track_NFS4_09_EmpireCity":
			NfsgpSingleton.currentLapRecord = "03:42.23"
		"Track_Simpsons_Racetrack":
			#NfsgpSingleton.currentLapRecord = "00:30.08"
			NfsgpSingleton.currentLapRecord = "05:01.23" #high number in place for easy testing, real lap tiome is 00:30:08
	
func _on_start_finish_line_area_3d_body_entered(body):
	if body.name == "VehicleBody3D":
		if checkpoint_passed == true:
			# If the current time is better, update the lap record.
			var current_time_seconds = time_string_to_seconds(NfsgpSingleton.currentLapTime)
			var lap_record = time_string_to_seconds(NfsgpSingleton.currentLapRecord)
			if current_time_seconds < lap_record:
				lap_record = current_time_seconds
				NfsgpSingleton.currentLapRecord = seconds_to_time_string(lap_record) #update HUD
				bestLapSound.play()
				NfsgpSingleton.NewLapRecordAward = true #sets lap txt to yellow
				# If it's the final lap, queue the sound to play after the final lap sound
				if NfsgpSingleton.currentLap == NfsgpSingleton.totalLaps:
					finalLapSound.connect("finished", _on_finalLapSound_finished)
				else:
					bestLapSound.play()
			# Reset the checkpoint for the next lap
			checkpoint_passed = false
			NfsgpSingleton.currentLapReset = true #see HUD for reset lap time code
			# Increment lap count
			NfsgpSingleton.currentLap += 1
			if NfsgpSingleton.currentLap == NfsgpSingleton.totalLaps: # If starting the final lap
				raceBkMusic.stop()
				finalLapSound.play()
				raceBkMusic.set_pitch_scale(1.2) #super mario kart style rush to finish!
				raceBkMusic.play()
		#outside of checkpoint if statement, this needs to be triggered right as lap 3 starts without checkpoints
		if NfsgpSingleton.currentLap > NfsgpSingleton.totalLaps:
			# Race finished, handle race completion logic here
			raceWinSound.play()
			await raceWinSound.finished
			get_tree().change_scene_to_file("res://Scenes/NFSGP_MainMenu_GD4.tscn")
			NfsgpSingleton.currentLap = NfsgpSingleton.totalLaps  # Prevent going over the total laps

func _on_finalLapSound_finished():
	bestLapSound.play()
	finalLapSound.disconnect("finished", _on_finalLapSound_finished) # Disconnect the signal

func _on_bestLapSound_finished():
	raceWinSound.play()
	bestLapSound.disconnect("finished", _on_bestLapSound_finished) # Disconnect the signal

func _on_check_point_1_area_3d_body_entered(body):
	if body.name == "VehicleBody3D":
		checkpoint_passed = true

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
	
# Converts seconds (as a float) to a time string formatted as "MM:SS.MS".
func seconds_to_time_string(total_seconds: float) -> String:
	var minutes: int = int(total_seconds / 60)
	var seconds: float = fmod(total_seconds, 60.0)
	# Format the string to ensure that it always has at least two digits for minutes and seconds,
	# and that it shows two decimal places for the fractional part of the seconds.
	return "%02d:%05.2f" % [minutes, seconds]
