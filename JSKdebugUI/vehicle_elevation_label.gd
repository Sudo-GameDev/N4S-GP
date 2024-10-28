extends Label

func _process(_delta: float) -> void:
	text = "Vehicle Elevation: " + str(NfsgpSingleton.vehicleElevation)
