extends Label

# Source:
# https://godotengine.org/asset-library/asset/677

#run only once since the thread count doesn't change
func _ready() -> void:
	var sDPI := DisplayServer.screen_get_dpi()
	text = "Screen DPI: " + str(sDPI)
