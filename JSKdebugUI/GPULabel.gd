extends Label

# Source:
# https://godotengine.org/asset-library/asset/677

#run only once since the thread count doesn't change
func _ready() -> void:
	var GPUinfo := RenderingServer.get_video_adapter_name()
	text = "JEE POO Info: " + str(GPUinfo)
