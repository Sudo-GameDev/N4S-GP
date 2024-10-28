extends Label

# Source:
# https://docs.godotengine.org/en/stable/classes/class_os.html

#run only once since the thread count doesn't change
func _ready() -> void:
	var vSync := (DisplayServer.window_get_vsync_mode() != DisplayServer.VSYNC_DISABLED)
	text = "vSync Enabled: " + str(vSync)
