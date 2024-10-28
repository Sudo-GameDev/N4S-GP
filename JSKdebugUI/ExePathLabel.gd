extends Label

# Source:
# https://godotengine.org/asset-library/asset/677

#run only once since the thread count doesn't change
func _ready() -> void:
	var ePath := OS.get_executable_path()
	text = "Executable Path3D: " + str(ePath)
