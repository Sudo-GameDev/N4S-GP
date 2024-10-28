extends Label

# Source:
# https://godotengine.org/asset-library/asset/677

#run only once since the thread count doesn't change
func _ready() -> void:
	var video_drivers = PackedStringArray()
#	for i in OS.get_video_driver_count():
#		video_drivers.push_back(OS.get_video_driver_name(i))
	text = "Available Video Drivers: " + ", ".join(video_drivers)
