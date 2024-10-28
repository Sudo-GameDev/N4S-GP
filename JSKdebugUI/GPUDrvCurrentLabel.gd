extends Label

# Source:
# https://godotengine.org/asset-library/asset/677

#run only once since the thread count doesn't change
func _ready() -> void:
	#var currentVidDrv := OS.get_video_driver_name(OS.get_current_video_driver()) #doesn't work in godot 4.x
	var currentVidDrv := OS.get_video_adapter_driver_info()
	text = "Current Video Driver: " + str(currentVidDrv)
