extends Label

func _process(_delta: float) -> void:
	# Display memory usage in the label
	text = "Godot Version Build: " + Engine.get_version_info()["string"]
