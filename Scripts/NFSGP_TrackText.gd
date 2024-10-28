extends RichTextLabel

@onready	var trackRichTextLbl = get_parent().get_node("TrackRichTextLbl")

#added custom formatting so string can be its own line for easy copy / paste from .txt files which were replaced with this script.
func _process(_delta):
	match NfsgpSingleton.track:
		"Track_NFS2_TR00_ProvingGrounds":
			trackRichTextLbl.text = """
Located far from prying eyes, these remote testing grounds put some of the world's fastest cars through their paces. Although originally built for endurance testing, this track also makes for some adrenaline pumping, metal-on-metal competition. The high speed tri-oval will allow you to keep the pedal matted as you strive to maintain perpetual top speed. But keep your eyes on the road, because at 200+ miles an hour, the slightest twitch could turn your exotic car into exotic scrap metal.
""".strip_edges()

		"Track_NFS2_TR04_LastResort":
			trackRichTextLbl.text = """
This tropical getaway has it all: ancient lost temples, lush jungle vegetation, and even a rickety old bridge. Once you leave the comfort and safety of your hotel, get ready for a non-stop, white-knuckle adventure through deadly twists, turns, and hills. As you enter the mouth of the ancient caverns, the monkey god Ekmel Onnah challenges you with an unforgettable wild ride, down past an ancient shrine buried in the depths of the earth. Here in the jungle, it's survival of the fittest, and this perilous high-speed course will push your survival skills to the limit.
""".strip_edges()

		"Track_NFS2_TR07_MysticPeaks":
			trackRichTextLbl.text = """
For thousands of years, this remote region in the Himalayas has remained shrouded in mystery. Only the most fearless come here to test their skills on this treacherous roadway. Drivers experienced or lucky enough to survive the wind-swept cliffs, crystal caves, and perilous corners of this track will enjoy an elevated consciousness as they race upwards to the great temple. While pondering the meaning of life and gazing at the ancient ruins, don't forget to keep an eye on the road, or you may find your karma at the bottom of a 1500-foot chasm.
""".strip_edges()

		"Track_NFS4_01_Hometown":
			trackRichTextLbl.text = """
It may be a rural setting, but this first track is anything but laid back. Speed's the name of the game, so keep your eyes peeled for landmarks blurring by that could help with your timing on corners and jumps. Featuring an iconic set of twin covered bridges, this route is set in autumn across a North American rural environment with trees and farms filling the background alongside fallen leaves cover parts of the road.
""".strip_edges()

		"Track_NFS4_02_RedrockRidge":
			trackRichTextLbl.text = """
This canyon course requires a focused driving strategy. Speed zones littered with dust and obstacles will push the handling envelope of your chosen supercar. The course is set within the North American desert with varied elevation changes and twisting roads. Notable landmarks such as a motel, a gas station and an observatory can be spotted nearby the beginning of the track.
""".strip_edges()

		"Track_NFS4_03_Atlantica":
			trackRichTextLbl.text = """
Reminiscent of the Monaco Grand Prix, this course is a real driver's utopia. Emphasis on racing technique will insure record times on this futuristic track. The track takes place in a clean and futuristic city with numerous gardens along the coastline on a boulevard called Atlantica Drive. It is comprised of straight and twisting roads. 
""".strip_edges()

		"Track_NFS4_04_RockyPass":
			trackRichTextLbl.text = """
Simplicity can be deceptive. This track, while not appearing overly intimidating, presents a challenge to even the most seasoned racers. The course is set on a mountain pass with an alpine forest setting, with varying elevation changes, jumps, a few tunnels, a bridge and many tight turns, including a set of switchbacks. A small village can be found near the bottom of the track. 
""".strip_edges()

		"Track_NFS4_05_CountryWoods":
			trackRichTextLbl.text = """
Buckle up! This remains a high-speed course, moving away from rolling farmlands to more challenging country roads and backwoods driving. The course is set in a Winter variant of Hometown, detaching from the covered bridges to a route that consists of narrow turns, twists and varied elevation changes. Notable landmarks such as the doughnut shop, the gas station and the school building can be spotted at the beginning of the route. 
""".strip_edges()

		"Track_NFS4_06_LostCanyons":
			trackRichTextLbl.text = """
Prepare to drop out sight as this course takes you from ground level into the depths of the canyon floor in seconds. Now is the time to balance your speed with steering technique. The course is set at a dusk variation of Redrock Ridge, detaching from the rocks after the divided highway to a canyon route consisting of wide and winding turns, a native temple and a divided roadway with elevation changes on each side of the road. 
""".strip_edges()

		"Track_NFS4_07_Aquatica":
			trackRichTextLbl.text = """
Urban utopia now gives way to an exciting coastline driving experience. You have to possess superior driving skills to make good times on this formidable course. The course is set at a dusk variation of Atlantica, with a few split canyon routes, an underwater tunnel, the Neptune Tunnel, and a coastal garden, the Rapa Nui Park.
""".strip_edges()

		"Track_NFS4_08_TheSummit":
			trackRichTextLbl.text = """
The name "summit" is fitting. Not only for this course's environment but also for its towering challenge. You'll need complete mastering of your racing repertoire to finish unscathed and victorious. The course is set as a snowy variation of Rocky Pass, with routes through narrow cliffside turns, winded corners and a small passage through the village. 
""".strip_edges()

		"Track_NFS4_09_EmpireCity":
			trackRichTextLbl.text = """
Metropolis gone bad. Dank city streets can be hell on traction. But this course also contains hazards and tense driving moments. It is a street racing course that takes place in a decaying industrial and downtown area, presented in a futuristic cyberpunk style. Notable landmarks are the Empire Hotel, and a park located opposite several gothic style buildings. 
""".strip_edges()

		"Track_Simpsons_Racetrack":
			trackRichTextLbl.text = """
Here's how this works: Milhouse, Nelson and Ralph run a series of races around town. Complete all the races and you unlock a new vehicle. Well, what are you waiting for? In an early build of the original xbox game, Patty would have congratulated the player after completing all three races and tell the characters to call the Phone Booths to have their new car delivered.
""".strip_edges()
