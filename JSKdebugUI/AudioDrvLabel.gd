extends Label

# Source:
# https://godotengine.org/asset-library/asset/677

#run only once since the thread count doesn't change
func _ready() -> void:
	var audio_drivers = PackedStringArray()
#	for i in OS.get_audio_driver_count():
#		audio_drivers.push_back(OS.get_audio_driver_name(i))
	text = "Available Audio Drivers: " + ", ".join(audio_drivers)
