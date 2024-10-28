extends Label

func _process(_delta: float) -> void:
	text = "Transmission RPM: " + str(NfsgpSingleton.globalRPM)
