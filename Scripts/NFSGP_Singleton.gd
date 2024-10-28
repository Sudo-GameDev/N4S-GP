extends Node
#https://www.youtube.com/watch?v=Qc8I68w5FOE
#Create script > Project Setings > Autoloab tab > add path to script > Enable Singleton
#example usage in other scripts:
#NfsgpSingleton.vehicle = vehicleOptBtn.get_item_text(vehicleOptBtn.get_selected_id()) #set global vehicle variable
var track
var vehicle
var globalRPM
var HeadsUpDisplayRPM
var globalSpeed
var globalGear
var globalRedLine
var developerMode
var snowFX
var vehicleElevation
var currentLapTime
var currentLapRecord
var NewLapRecordAward
var currentLapReset
var currentLap = 1
var totalLaps = 2  # You can set this based on the race settings
var carExploding
var startLineCams
var player_position #used to track players vehicle so pursuit vehicles can chase and collidate with it
var player_rotation

# Called when the node enters the scene tree for the first time.
func _ready():
	#print("singleton ready function ran...")
	pass
