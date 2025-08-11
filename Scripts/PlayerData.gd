extends Node

var highest_mmr: int = 300
var week = 1
var year = 1
var energy = 100
var mmr = 300
var season = 1

var pending_team_code: String = ""
var applied_week: int = -1
var team_application_cooldowns := {}  # Dictionary to track cooldowns per team
var news_log: Array = []

var team_code: String = ""  # Or null if not yet assigned
var fullname: String = ""
var in_game_name: String = ""
var gender: String = ""
var role: String = ""
var age: int = 16  # Player starts at age 16
var playstyle: String = ""  # Player-selected playstyle
var region: String = "NA"  # default, gets overwritten when player selects
var skills: Dictionary = {}
var team_name := ""  # Or null if you prefer
var wins: int = 0
var losses: int = 0

var playstyles = [
	"Aggressive",
	"Defensive",
	"Macro-Focused",
	"Balanced"  # ✅ NEW!
]

func _ready():
	randomize()

func set_player_info(player_name: String, ign: String, g: String, r: String, reg: String) -> void:
	fullname = player_name
	in_game_name = ign
	gender = g
	role = r
	region = reg
	age = 16
	initialize_skills(role)

func set_playstyle(style: String) -> void:
	playstyle = style

func initialize_skills(selected_role: String) -> void:
	role = selected_role

	match role:
		"Dps":
			skills = {
				"Mechanics": 55,
				"Burst Timing": 50,
				"Carry Pressure": 45
			}
		"Tank":
			skills = {
				"Engage Timing": 55,
				"Positioning": 50,
				"Peel & Protection": 45
			}
		"Support":
			skills = {
				"Map Awareness": 55,
				"Utility Usage": 50,
				"Shotcalling": 45
			}

	# ✅ Balance the skills if playstyle is "Balanced"
	if playstyle == "Balanced":
		for key in skills:
			skills[key] = 50 + randi() % 6  # slightly varied but balanced (50–55)

func apply_skill_progression(kills: int, deaths: int, assists: int) -> void:
	var total_contrib = kills + assists - deaths
	var growth_factor = clamp(total_contrib * 0.3, -1.0, 2.5)  # 🔼 more growth if you hard-carry

	var boost = randf_range(0.3, 0.8)  # 🔼 base boost raised a bit

	match role:
		"Dps":
			skills["Mechanics"] += boost + kills * 0.09  # 🔼 kills give more
			skills["Burst Timing"] += boost + assists * 0.06
			skills["Carry Pressure"] += growth_factor * 0.5  # 🔼 team impact matters more

		"Tank":
			skills["Engage Timing"] += boost + assists * 0.06
			skills["Positioning"] += clamp(0.3 - deaths * 0.06, 0.0, 0.6)
			skills["Peel & Protection"] += growth_factor * 0.4

		"Support":
			skills["Map Awareness"] += boost + assists * 0.06
			skills["Utility Usage"] += (0.4 if kills == 0 else 0.2)
			skills["Shotcalling"] += growth_factor * 0.4  # 🔼 team contribution impacts shotcalling

	# Clamp all skills between 0 and 100
	for key in skills:
		skills[key] = clamp(skills[key], 0, 100)

func get_rank_name() -> String:
	if mmr >= 1000:
		return "Champion"
	elif mmr >= 900:
		return "Vanguard"
	elif mmr >= 800:
		return "Legend"
	elif mmr >= 700:
		return "Prodigy"
	elif mmr >= 600:
		return "Elite"
	elif mmr >= 500:
		return "Challenger"
	elif mmr >= 400:
		return "Contender"
	else:
		return "Rookie"

func add_news(tag: String, text: String):
	news_log.append({
		"tag": tag,
		"text": text,
		"week": week,
		"season": season
	})
	if news_log.size() > 20:
		news_log.pop_front()  # keep recent 20 only
