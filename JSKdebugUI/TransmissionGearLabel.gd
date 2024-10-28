extends Label

func _process(_delta: float) -> void:
	text = "Transmission Gear: " + str(NfsgpSingleton.globalGear)
