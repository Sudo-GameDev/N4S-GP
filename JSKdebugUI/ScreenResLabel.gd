extends Label

# Source:
# https://godotengine.org/asset-library/asset/677

#run only once since the thread count doesn't change
func _ready() -> void:
	var sRes := DisplayServer.screen_get_size()
	var sWin: Vector2 = get_viewport().size # godot 4.x needs variable explicitly defined
	text = "Native Device Size X, Y: " + str(sRes) + "; App Display Size X, Y: " + str(sWin)
