extends Label

func _process(_delta: float) -> void:
	text = "Vehicle Speed in MPH: " + str(NfsgpSingleton.globalSpeed)
