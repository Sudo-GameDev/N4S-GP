extends Label

# Source:
# https://docs.godotengine.org/en/stable/classes/class_os.html

#run only once since the thread count doesn't change
func _ready() -> void:
	var cpuThreads := OS.get_processor_count()
	text = "SEE POO Threads: " + str(cpuThreads)
