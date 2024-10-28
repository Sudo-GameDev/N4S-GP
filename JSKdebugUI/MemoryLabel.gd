extends Label

# Source:
# https://www.youtube.com/watch?v=R5xNcB5Zbzs



# Realtime memory usage
var memUsage
var memPeak


func _process(_delta: float) -> void:
	memUsage = str(OS.get_static_memory_usage() / 1000000.0)
	memPeak = str(OS.get_static_memory_peak_usage() / 1000000.0)

	#round values to improve readability
	memUsage = snapped (int(memUsage), 0.001) #should return 3 decimals but its bugged.  leaving alone since i don't need that anyway.
	memPeak = snapped (int(memPeak), 0.001)

	# Display memory usage in the label
	text = "Deditated Whams Used: " + str(memUsage) + "MB - Peak Usage: " + str(memPeak) + "MB"
