extends Node3D
#testing GPT template for engine audio Interpolation with x4 samples
#https://www.youtube.com/watch?v=8S1yUrv6CBU
#idle 820RPM
#redline 5400RPM

var current_RPM = 0
var rpm_samples
#var current_sample = null

func _ready():
	rpm_samples = {
		820: $RPM_0820,
		1000: $RPM_1000,
		1100: $RPM_1100,
		1200: $RPM_1200,
		1300: $RPM_1300,
		1400: $RPM_1400,
		1500: $RPM_1500,
		1600: $RPM_1600,
		1700: $RPM_1700,
		1800: $RPM_1800,
		1900: $RPM_1900,
		2000: $RPM_2000,
		2100: $RPM_2100,
		2200: $RPM_2200,
		2300: $RPM_2300,
		2400: $RPM_2400,
		2500: $RPM_2500,
		2600: $RPM_2600,
		2700: $RPM_2700,
		2800: $RPM_2800,
		2900: $RPM_2900,
		3000: $RPM_3000,
		3100: $RPM_3100,
		3200: $RPM_3200,
		3300: $RPM_3300,
		3400: $RPM_3400,
		3500: $RPM_3500,
		3600: $RPM_3600,
		3700: $RPM_3700,
		3800: $RPM_3800,
		3900: $RPM_3900,
		4000: $RPM_4000,
		4100: $RPM_4100,
		4200: $RPM_4200,
		4300: $RPM_4300,
		4400: $RPM_4400,
		4500: $RPM_4500,
		4600: $RPM_4600,
		4700: $RPM_4700,
		4800: $RPM_4800,
		4900: $RPM_4900,
		5000: $RPM_5000,
		5100: $RPM_5100,
		5200: $RPM_5200,
		5300: $RPM_5300,
		5400: $RPM_5400,
		5500: $RPM_5500,
		5600: $RPM_5600,
		5700: $RPM_5700,
		5800: $RPM_5800,
		5900: $RPM_5900,
		6000: $RPM_6000,
		6100: $RPM_6100,
		6200: $RPM_6200,
		6300: $RPM_6300,
		6400: $RPM_6400,
		6500: $RPM_6500,
		6600: $RPM_6600,
		6700: $RPM_6700,
		6800: $RPM_6800,
		6900: $RPM_6900,
		7000: $RPM_7000,
		7100: $RPM_7100,
		7200: $RPM_7200,
		7300: $RPM_7300,
		7400: $RPM_7400,
		7500: $RPM_7500,
		# Add more here
	}

func _physics_process(_delta):
	#current_RPM = NfsgpSingleton.globalRPM * 7 # 5400 / 700 = 7.714285714285714  # <<<< old code with original simple RPM
	current_RPM = NfsgpSingleton.globalRPM
	
	#setup HUD RPM with value 0.1 x1000 format, example 6.5 = 6500RPM
	var current_RPM_formatted = round(current_RPM / 1000 * 10) / 10.0
	if (current_RPM_formatted <= 0.8):
		current_RPM_formatted = 0.8
	NfsgpSingleton.HeadsUpDisplayRPM = "%.1f" % current_RPM_formatted

	update_audio_sample() #engine RPM audio FX

# List to store the currently playing samples
var current_samples = []

func update_audio_sample(): # x2 over lapping audio tracks
	#print("Current RPM: " + str(current_RPM))  # Debug: Print current RPM
	
	var closest_rpms = []
	var sorted_keys = []
	
	for rpm in rpm_samples.keys():
		sorted_keys.append(rpm)
	sorted_keys.sort()
	
	# Find closest lower or equal RPM
	var closest_lower = -1
	for rpm in sorted_keys:
		if rpm <= current_RPM:
			closest_lower = rpm
	
	if closest_lower != -1:
		closest_rpms.append(closest_lower)
	
	# Find closest higher RPM
	var closest_higher = INF
	for rpm in sorted_keys:
		if rpm > current_RPM and rpm < closest_higher:
			closest_higher = rpm
	
	if closest_higher != INF:
		closest_rpms.append(closest_higher)
	
	#print("Selected for overlap: " + str(closest_rpms))  # Debug: Print RPMs selected for overlap
	
	# Stop the currently playing samples, if any
	for sample in current_samples:
		if sample not in closest_rpms:
			#print("Stopping: " + str(sample))  # Debug: Print stopping sample
			rpm_samples[sample].stop()

	# Update the list of current samples
	current_samples = closest_rpms

	# Play the selected samples
	for rpm in closest_rpms:
		if not rpm_samples[rpm].is_playing():
			#print("Playing: " + str(rpm))  # Debug: Print playing sample
			rpm_samples[rpm].play()
