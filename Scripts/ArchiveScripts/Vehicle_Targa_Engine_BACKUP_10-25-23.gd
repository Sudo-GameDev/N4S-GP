extends AudioStreamPlayer3D

@onready	var engineAudio = get_parent().get_node("Engine_AudioStreamPlayer3D")
var engineSpeed

# Called when the node enters the scene tree for the first time.
func _ready():
	#VehicleBody3D/Engine_AudioStreamPlayer3D
	#engineAudio.play() #disabled to migrate to new engine FX
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#max rpm in testing is 600 ish but conf says 1000
	#pitch lowest value is 0.8, and highest is 4 (based off what sounds good)
	engineSpeed = NfsgpSingleton.globalRPM / 250
	if engineSpeed > 4:
		engineSpeed = 4
	if engineSpeed < 0.8:
		engineSpeed = 0.8
	#print(str(engineSpeed))
	engineAudio.set_pitch_scale(engineSpeed)
