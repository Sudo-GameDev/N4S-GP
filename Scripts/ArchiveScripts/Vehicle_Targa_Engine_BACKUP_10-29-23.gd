extends Node3D
#testing GPT template for engine audio Interpolation with x4 samples
#https://www.youtube.com/watch?v=8S1yUrv6CBU
#idle 820RPM
#redline 5400RPM

#const HIGH_VOLUME_DB = 0  # 0 dB is the original volume without any reduction.
#const LOW_VOLUME_DB = -80  # -40 dB is quite reduced but not silent. Adjust this value based on your needs.
@export var upperEngineAudioFade = 0.25
@export var lowerEngineAudioFade = 0.25
@export var upperEngineAudioVol = -25
@export var lowerEngineAudioVol = -25

@export var upperEngineAudioDB = 1.0
@export var lowerEngineAudioDB = 0.58
@export var engineRedLine = 6500.0

@export var maxVolumeDB: float = 1    # Maximum volume in decibels
@export var minVolumeDB: float = -10  # Minimum volume in decibels


var current_RPM = 0
var rpm_samples
#var current_sample = null

func _ready():
	rpm_samples = {
		#820: $RPM_0820,
		1000: $RPM_1000,
		1050: $RPM_1050,
		1100: $RPM_1100,
		1150: $RPM_1150,
		1200: $RPM_1200,
		1250: $RPM_1250,
		1300: $RPM_1300,
		1350: $RPM_1350,
		1400: $RPM_1400,
		1450: $RPM_1450,
		1500: $RPM_1500,
		1550: $RPM_1550,
		1600: $RPM_1600,
		1650: $RPM_1650,
		1700: $RPM_1700,
		1750: $RPM_1750,
		1800: $RPM_1800,
		1850: $RPM_1850,
		1900: $RPM_1900,
		1950: $RPM_1950,
		2000: $RPM_2000,
#		2050: $RPM_2050,
#		2100: $RPM_2100,
#		2150: $RPM_2150,
#		2200: $RPM_2200,
#		2250: $RPM_2250,
#		2300: $RPM_2300,
#		2350: $RPM_2350,
#		2400: $RPM_2400,
#		2450: $RPM_2450,
#		2500: $RPM_2500,
#		2550: $RPM_2550,
#		2600: $RPM_2600,
#		2650: $RPM_2650,
#		2700: $RPM_2700,
#		2750: $RPM_2750,
#		2800: $RPM_2800,
#		2850: $RPM_2850,
#		2900: $RPM_2900,
#		2950: $RPM_2950,
#		3000: $RPM_3000,
#		3050: $RPM_3050,
#		3100: $RPM_3100,
#		3150: $RPM_3150,
#		3200: $RPM_3200,
#		3250: $RPM_3250,
#		3300: $RPM_3300,
#		3350: $RPM_3350,
#		3400: $RPM_3400,
#		3450: $RPM_3450,
#		3500: $RPM_3500,
#		3550: $RPM_3550,
#		3600: $RPM_3600,
#		3650: $RPM_3650,
#		3700: $RPM_3700,
#		3750: $RPM_3750,
#		3800: $RPM_3800,
#		3850: $RPM_3850,
#		3900: $RPM_3900,
#		3950: $RPM_3950,
#		4000: $RPM_4000,
#		4050: $RPM_4050,
#		4100: $RPM_4100,
#		4150: $RPM_4150,
#		4200: $RPM_4200,
#		4250: $RPM_4250,
#		4300: $RPM_4300,
#		4350: $RPM_4350,
#		4400: $RPM_4400,
#		4450: $RPM_4450,
#		4500: $RPM_4500,
#		4550: $RPM_4550,
#		4600: $RPM_4600,
#		4650: $RPM_4650,
#		4700: $RPM_4700,
#		4750: $RPM_4750,
#		4800: $RPM_4800,
#		4850: $RPM_4850,
#		4900: $RPM_4900,
#		4950: $RPM_4950,
#		5000: $RPM_5000,
#		5050: $RPM_5050,
#		5100: $RPM_5100,
#		5150: $RPM_5150,
#		5200: $RPM_5200,
#		5250: $RPM_5250,
#		5300: $RPM_5300,
#		5350: $RPM_5350,
#		5400: $RPM_5400,
#		5450: $RPM_5450,
#		5500: $RPM_5500,
#		5550: $RPM_5550,
#		5600: $RPM_5600,
#		5650: $RPM_5650,
#		5700: $RPM_5700,
#		5750: $RPM_5750,
#		5800: $RPM_5800,
#		5850: $RPM_5850,
#		5900: $RPM_5900,
#		5950: $RPM_5950,
#		6000: $RPM_6000,
#		6050: $RPM_6050,
#		6100: $RPM_6100,
#		6150: $RPM_6150,
#		6200: $RPM_6200,
#		6250: $RPM_6250,
#		6300: $RPM_6300,
#		6350: $RPM_6350,
#		6400: $RPM_6400,
#		6450: $RPM_6450,
#		6500: $RPM_6500,
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

	#update_audio_sample() #engine RPM audio FX
	#update_audio_sampleX2() #engine RPM audio FX with x2 overlapping tracks (full volume)
	#update_audio_sampleX3() #engine RPM audio FX with x3 overlapping tracks by dynamic volume
	#update_audio_sampleX1() #do the thing above with full volume only 1 track (delay reduces since all are playing in memory?)
	#update_audio_sampleX3volume() # volume dynamic
	#update_audio_sampleX2volume() # volume dynamic
	#update_audio_singleSamplePitch() #uses redline as sample
	#update_audio_doubleSamplePitch() # uses idle and redline blend
	update_audio_doubleSamplePitchVolInvert() #has idle and redline trade places in pitch and volume

# List to store the currently playing samples
var current_samples = []

func update_audio_sample(): #single audio track
	#print("Current RPM: " + str(current_RPM))  # Debug: Print current RPM

	var closest_rpm_key = -1
	var min_difference = INF

	# Find the sample closest to the current RPM
	for rpm_key in rpm_samples.keys():
		var difference = abs(current_RPM - rpm_key)
		if difference < min_difference:
			min_difference = difference
			closest_rpm_key = rpm_key

	#print("Closest RPM: " + str(closest_rpm_key))  # Debug: Print closest RPM

	# If the closest sample is already playing, just return
	if rpm_samples[closest_rpm_key].is_playing():
		return

	# Stop the currently playing samples
	for sample_rpm in current_samples:
		rpm_samples[sample_rpm].stop()
		print("Stopping: " + str(rpm_samples[sample_rpm]))  # Debug: Print stopping sample

	# Clear the list of current samples
	current_samples.clear()

	# Play the closest sample
	rpm_samples[closest_rpm_key].play()
	print("Playing: " + str(rpm_samples[closest_rpm_key]))  # Debug: Print playing sample
	current_samples.append(closest_rpm_key)

#doesn't sound good on targa unlike the IROC..
func update_audio_sampleX2(): # x2 over lapping audio tracks
	print("Current RPM: " + str(current_RPM))  # Debug: Print current RPM
	
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
	
	print("Selected for overlap: " + str(closest_rpms))  # Debug: Print RPMs selected for overlap
	
	# Stop the currently playing samples, if any
	for sample in current_samples:
		if sample not in closest_rpms:
			print("Stopping: " + str(sample))  # Debug: Print stopping sample
			rpm_samples[sample].stop()

	# Update the list of current samples
	current_samples = closest_rpms

	# Play the selected samples
	for rpm in closest_rpms:
		if not rpm_samples[rpm].is_playing():
			print("Playing: " + str(rpm))  # Debug: Print playing sample
			rpm_samples[rpm].play()

func update_audio_sampleX1(): #x3 custom mods, cause GPT doesn't understand my complicated demands
	#print("Current RPM: " + str(current_RPM))  # Debug: Print current RPM
	
	var sorted_keys = rpm_samples.keys()
	sorted_keys.sort()

	# Find the three closest RPM samples to current_RPM
	var lower_sample_rpm = -1
	var mid_sample_rpm = -1
	var upper_sample_rpm = INF
	
	for rpm in sorted_keys:
		if rpm <= current_RPM:
			lower_sample_rpm = mid_sample_rpm
			mid_sample_rpm = rpm
		elif rpm > current_RPM and upper_sample_rpm == INF:
			upper_sample_rpm = rpm

	# Linearly interpolate volume between the mid and upper samples
	if mid_sample_rpm != -1 and upper_sample_rpm != INF:
		rpm_samples[mid_sample_rpm].volume_db = 0
		rpm_samples[mid_sample_rpm].bus = "Master"
		rpm_samples[upper_sample_rpm].volume_db = upperEngineAudioVol
		rpm_samples[upper_sample_rpm].bus = "upperBus"
		if lower_sample_rpm != -1:  # Set volume for the third, lower sample
			rpm_samples[lower_sample_rpm].volume_db = lowerEngineAudioVol
			rpm_samples[lower_sample_rpm].bus = "lowerBus"

	# Ensure all samples are playing
	for rpm in sorted_keys:
		if not rpm_samples[rpm].is_playing():
			rpm_samples[rpm].play()

		# Mute any other samples that are not among the three closest
		if rpm != lower_sample_rpm and rpm != mid_sample_rpm and rpm != upper_sample_rpm:
			rpm_samples[rpm].volume_db = -80  # Very low volume (almost muted)
			#rpm_samples[rpm].bus = "Master" #not needed since it gets reset and won't hear it anyway

		#print("RPM:", rpm, "Volume (dB):", rpm_samples[rpm].volume_db)

func update_audio_sampleX3():
	#print("Current RPM: " + str(current_RPM))  # Debug: Print current RPM
	
	var sorted_keys = rpm_samples.keys()
	sorted_keys.sort()

	# Find the three closest RPM samples to current_RPM
	var lower_sample_rpm = -1
	var mid_sample_rpm = -1
	var upper_sample_rpm = INF
	
	for rpm in sorted_keys:
		if rpm <= current_RPM:
			lower_sample_rpm = mid_sample_rpm
			mid_sample_rpm = rpm
		elif rpm > current_RPM and upper_sample_rpm == INF:
			upper_sample_rpm = rpm

	# Linearly interpolate volume between the mid and upper samples
	if mid_sample_rpm != -1 and upper_sample_rpm != INF:
		var lerp_factor = (current_RPM - mid_sample_rpm) / (upper_sample_rpm - mid_sample_rpm)
		#rpm_samples[mid_sample_rpm].volume_db = linear_to_db((1.0 - lerp_factor) * 0.25) 
		#rpm_samples[upper_sample_rpm].volume_db = linear_to_db(lerp_factor * 0.25)
		rpm_samples[mid_sample_rpm].volume_db = linear_to_db(lerp_factor)
		#rpm_samples[upper_sample_rpm].volume_db = linear_to_db((1.0 - lerp_factor) * upperEngineAudioFade)
		rpm_samples[upper_sample_rpm].volume_db = linear_to_db(lerp_factor) * upperEngineAudioFade
	if lower_sample_rpm != -1:  # Set volume for the third, lower sample
		#rpm_samples[lower_sample_rpm].volume_db = linear_to_db(0.25)
		var lerp_factor = (current_RPM - mid_sample_rpm) / (upper_sample_rpm - mid_sample_rpm)  #move this to global to reduce duplicates above??
		#rpm_samples[lower_sample_rpm].volume_db = linear_to_db((1.0 - lerp_factor) * lowerEngineAudioFade)
		rpm_samples[lower_sample_rpm].volume_db = linear_to_db(lerp_factor) * lowerEngineAudioFade

	# Ensure all samples are playing
	for rpm in sorted_keys:
		if not rpm_samples[rpm].is_playing():
			rpm_samples[rpm].play()

		# Mute any other samples that are not among the three closest
		if rpm != lower_sample_rpm and rpm != mid_sample_rpm and rpm != upper_sample_rpm:
			rpm_samples[rpm].volume_db = -80  # Very low volume (almost muted)

		print("RPM:", rpm, "Volume (dB):", rpm_samples[rpm].volume_db)

func update_audio_sampleX3volume():
	#print("Current RPM: " + str(current_RPM))  # Debug: Print current RPM
	
	var sorted_keys = rpm_samples.keys()
	sorted_keys.sort()

	# Find the three closest RPM samples to current_RPM
	var lower_sample_rpm = -1
	var mid_sample_rpm = -1
	var upper_sample_rpm = INF
	
	for rpm in sorted_keys:
		if rpm <= current_RPM:
			lower_sample_rpm = mid_sample_rpm
			mid_sample_rpm = rpm
		elif rpm > current_RPM and upper_sample_rpm == INF:
			upper_sample_rpm = rpm

	var vol_upperFactor = (current_RPM - mid_sample_rpm) / (upper_sample_rpm - mid_sample_rpm)
	# Linearly adjust volume between the mid and upper samples
	if mid_sample_rpm != -1 and upper_sample_rpm != INF:
		rpm_samples[mid_sample_rpm].volume_db = vol_upperFactor
		rpm_samples[upper_sample_rpm].volume_db = vol_upperFactor * upperEngineAudioFade
	if lower_sample_rpm != -1:  # Set volume for the third, lower sample
		var vol_lowerFactor = (current_RPM - mid_sample_rpm) / (lower_sample_rpm - mid_sample_rpm)
		rpm_samples[lower_sample_rpm].volume_db = vol_lowerFactor * lowerEngineAudioFade

	# Ensure all samples are playing
	for rpm in sorted_keys:
		if not rpm_samples[rpm].is_playing():
			rpm_samples[rpm].play()

		# Mute any other samples that are not among the three closest
		if rpm != lower_sample_rpm and rpm != mid_sample_rpm and rpm != upper_sample_rpm:
			rpm_samples[rpm].volume_db = -80  # Very low volume (almost muted)

		print("RPM:", rpm, "Volume (dB):", rpm_samples[rpm].volume_db)


func update_audio_sampleX2volume():
	#print("Current RPM: " + str(current_RPM))  # Debug: Print current RPM

	var closest_rpms = []
	var sorted_keys = rpm_samples.keys()
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

	# Ensure all samples are playing
	for rpm in sorted_keys:
		if not rpm_samples[rpm].is_playing():
			rpm_samples[rpm].play()

	# Set lowest volume for the samples that are outside current upper/lower
	for sample in current_samples:
		if sample not in closest_rpms:
			rpm_samples[sample].volume_db = -80  # Very low volume (almost muted)
			print("Volume for", str(sample), ":", rpm_samples[sample].volume_db)

	# Update the list of current samples
	current_samples = closest_rpms

	# Calculate the difference in RPMs for volume adjustment
	if closest_lower != -1 and closest_higher != INF:
		var difference = current_RPM - closest_lower

		rpm_samples[closest_lower].volume_db = -difference
		rpm_samples[closest_higher].volume_db = -(50 - difference)

		print("Volume for", closest_lower, ":", rpm_samples[closest_lower].volume_db)
		print("Volume for", closest_higher, ":", rpm_samples[closest_higher].volume_db)

func update_audio_singleSamplePitch():
	if not $RPM_LongRedLine.is_playing():
		$RPM_LongRedLine.play()

	var engineRatio = current_RPM / 6500.0 #engineRedLine
	engineRatio = clamp(engineRatio, 0, 1)  # Ensure it's between 0 and 1

	var engineSpeed = lerp(lowerEngineAudioDB, upperEngineAudioDB, engineRatio)
	$RPM_LongRedLine.set_pitch_scale(engineSpeed)

	print("Set engine speed pitch to ", str(engineSpeed))

func update_audio_doubleSamplePitch(): #sounds really good
	if not $RPM_0820.is_playing():
		$RPM_0820.play()
	if not $RPM_LongRedLine.is_playing():
		$RPM_LongRedLine.play()

	var engineRatio = current_RPM / 6500.0 #engineRedLine
	engineRatio = clamp(engineRatio, 0, 1)  # Ensure it's between 0 and 1

	# For RPM_0820, we move from upper pitch to lower pitch as the engine RPM increases.
	var engineSpeedIdle = lerp(upperEngineAudioDB, lowerEngineAudioDB, engineRatio)
	$RPM_0820.set_pitch_scale(engineSpeedIdle)
	print("Set idle speed pitch to ", str(engineSpeedIdle))
	
	# For RPM_LongRedLine, we move from lower pitch to upper pitch as the engine RPM increases.
	var engineSpeedRedline = lerp(lowerEngineAudioDB, upperEngineAudioDB, engineRatio)
	$RPM_LongRedLine.set_pitch_scale(engineSpeedRedline)
	print("Set redline speed pitch to ", str(engineSpeedRedline))

func update_audio_doubleSamplePitchVolInvert():
	if not $RPM_0820.is_playing():
		$RPM_0820.play()
	if not $RPM_LongRedLine.is_playing():
		$RPM_LongRedLine.play()

	var engineRatio = current_RPM / 6500.0 #engineRedLine
	engineRatio = clamp(engineRatio, 0, 1)  # Ensure it's between 0 and 1

	# For RPM_0820, we move from upper pitch to lower pitch as the engine RPM increases.
	var engineSpeedIdle = lerp(upperEngineAudioDB, lowerEngineAudioDB, engineRatio)
	$RPM_0820.set_pitch_scale(engineSpeedIdle)
	
	# Adjust volume for RPM_0820, higher volume when the pitch is higher.
	var volumeIdle = lerp(maxVolumeDB, minVolumeDB, engineRatio)
	$RPM_0820.volume_db = volumeIdle

	print("Set idle speed pitch to ", str(engineSpeedIdle))
	print("Set idle volume to ", str(volumeIdle) + " dB")
	
	# For RPM_LongRedLine, we move from lower pitch to upper pitch as the engine RPM increases.
	var engineSpeedRedline = lerp(lowerEngineAudioDB, upperEngineAudioDB, engineRatio)
	$RPM_LongRedLine.set_pitch_scale(engineSpeedRedline)
	
	# Adjust volume for RPM_LongRedLine, lower volume when the pitch is lower.
	var volumeRedline = lerp(minVolumeDB, maxVolumeDB, engineRatio)
	$RPM_LongRedLine.volume_db = volumeRedline

	print("Set redline speed pitch to ", str(engineSpeedRedline))
	print("Set redline volume to ", str(volumeRedline) + " dB")

