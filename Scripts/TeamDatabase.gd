extends Node

var teams = {
	"OS1": { "name": "One Sword Vets", "logo": "res://Assets/Logos/os1.png", "region": "NA", "wins": 0, "losses": 0, "history": [] },
	"OS2": { "name": "Reapers T1", "logo": "res://Assets/Logos/os2.png", "region": "KR", "wins": 0, "losses": 0, "history": [] },
	"OS3": { "name": "Angels Death", "logo": "res://Assets/Logos/os3.png", "region": "EU", "wins": 0, "losses": 0, "history": [] },
	"OS4": { "name": "Monkey Kings", "logo": "res://Assets/Logos/os4.png", "region": "SEA", "wins": 0, "losses": 0, "history": [] },
	"OS5": { "name": "Uncrowned Kings", "logo": "res://Assets/Logos/os5.png", "region": "NA", "wins": 0, "losses": 0, "history": [] },
	"OS6": { "name": "OPPO Fighters", "logo": "res://Assets/Logos/os6.png", "region": "SEA", "wins": 0, "losses": 0, "history": [] },
	"OS7": { "name": "Taipei Assassins", "logo": "res://Assets/Logos/os7.png", "region": "TW", "wins": 0, "losses": 0, "history": [] },
	"OS8": { "name": "King of Kings", "logo": "res://Assets/Logos/os8.png", "region": "EU", "wins": 0, "losses": 0, "history": [] },
	"OS9": { "name": "Team Solo Queue", "logo": "res://Assets/Logos/os9.png", "region": "NA", "wins": 0, "losses": 0, "history": [] },
	"OS10": { "name": "Piratas", "logo": "res://Assets/Logos/os10.png", "region": "LATAM", "wins": 0, "losses": 0, "history": [] },
	"OS11": { "name": "Raging Gods", "logo": "res://Assets/Logos/os11.png", "region": "BR", "wins": 0, "losses": 0, "history": [] },
	"OS12": { "name": "Even God Bleeds", "logo": "res://Assets/Logos/os12.png", "region": "JP", "wins": 0, "losses": 0, "history": [] },
	"OS13": { "name": "Rising Gods", "logo": "res://Assets/Logos/os13.png", "region": "KR", "wins": 0, "losses": 0, "history": [] },
	"OS14": { "name": "Thunder E-sports", "logo": "res://Assets/Logos/os14.png", "region": "PH", "wins": 0, "losses": 0, "history": [] },
	"OS15": { "name": "Kamatayan", "logo": "res://Assets/Logos/os15.png", "region": "PH", "wins": 0, "losses": 0, "history": [] },
	"OS16": { "name": "Hell E-sports", "logo": "res://Assets/Logos/os16.png", "region": "EU", "wins": 0, "losses": 0, "history": [] },
	"OS17": { "name": "Asul E-sports", "logo": "res://Assets/Logos/os17.png", "region": "PH", "wins": 0, "losses": 0, "history": [] },
	"OS18": { "name": "Pula E-sports", "logo": "res://Assets/Logos/os18.png", "region": "PH", "wins": 0, "losses": 0, "history": [] },
	"OS19": { "name": "Dreamkill Pact", "logo": "res://Assets/Logos/os19.png", "region": "LATAM", "wins": 0, "losses": 0, "history": [] },
	"OS20": { "name": "Toxic E-sports", "logo": "res://Assets/Logos/os20.png", "region": "BR", "wins": 0, "losses": 0, "history": [] },
	"OS21": { "name": "Omega Fire", "logo": "res://Assets/Logos/os21.png", "region": "SEA", "wins": 0, "losses": 0, "history": [] },
	"OS22": { "name": "Eagle Fighters E-sports", "logo": "res://Assets/Logos/os22.png", "region": "EU", "wins": 0, "losses": 0, "history": [] },
	"OS23": { "name": "Karmine Corpse E-sports", "logo": "res://Assets/Logos/os23.png", "region": "EU", "wins": 0, "losses": 0, "history": [] },
	"OS24": { "name": "Gen K E-sports", "logo": "res://Assets/Logos/os24.png", "region": "KR", "wins": 0, "losses": 0, "history": [] },
	"OS25": { "name": "Legends Maker", "logo": "res://Assets/Logos/os25.png", "region": "NA", "wins": 0, "losses": 0, "history": [] },
	"OS26": { "name": "About Life", "logo": "res://Assets/Logos/os26.png", "region": "EU", "wins": 0, "losses": 0, "history": []  },
	"OS27": { "name": "Creepers Fire", "logo": "res://Assets/Logos/os27.png", "region": "LATAM", "wins": 0, "losses": 0, "history": []  },
	"OS28": { "name": "Made As Kings", "logo": "res://Assets/Logos/os28.png", "region": "KR", "wins": 0, "losses": 0, "history": []  },
	"OS29": { "name": "Team Sharks", "logo": "res://Assets/Logos/os29.png", "region": "JP", "wins": 0, "losses": 0, "history": [] },
	"OS30": { "name": "Jaguars", "logo": "res://Assets/Logos/os30.png", "region": "NA", "wins": 0, "losses": 0, "history": [] }
}
var tournament_history : Array = []


func get_team_name_by_code(code: String) -> String:
	if teams.has(code):
		return teams[code]["name"]
	return "Unknown"

func get_team_data(code: String) -> Dictionary:
	return teams.get(code, {})

func get_sorted_teams_by_wins() -> Array:
	var win_data = []
	for code in teams:
		var t = teams[code]
		win_data.append({
			"code": code,
			"wins": t.get("wins", 0),
			"losses": t.get("losses", 0)
		})
	win_data.sort_custom(func(a, b): return a["wins"] > b["wins"])
	var sorted_codes = []
	for entry in win_data:
		sorted_codes.append(entry["code"])
	return sorted_codes

func record_match_result(winner_code: String, loser_code: String) -> void:
	if teams.has(winner_code):
		teams[winner_code]["wins"] += 1
	if teams.has(loser_code):
		teams[loser_code]["losses"] += 1

func save_current_season_to_history(season_number: int) -> void:
	for code in teams:
		var team = teams[code]
		team["history"].append({
			"season": season_number,
			"wins": team["wins"],
			"losses": team["losses"]
		})

func reset_win_loss_records():
	for team_code in teams:
		teams[team_code]["wins"] = 0
		teams[team_code]["losses"] = 0

func reset_all_records():
	reset_win_loss_records()

func get_team_history(team_code: String) -> Array:
	if teams.has(team_code):
		return teams[team_code].get("history", [])
	return []

func get_random_teams(count: int = 8) -> Array:
	var team_codes = teams.keys()
	team_codes.shuffle()
	return team_codes.slice(0, count)

func get_top_teams(count: int = 16) -> Array:
	var sorted = get_sorted_teams_by_wins()
	return sorted.slice(0, count)

func get_random_team_name() -> String:
	var code = get_random_team_code()
	return get_team_name_by_code(code)

func get_random_team_code() -> String:
	return teams.keys().pick_random()

# Optional Save/Load - If you want to persist across game sessions
func save_to_file():
	var save_data = {}
	for code in teams:
		save_data[code] = {
			"wins": teams[code]["wins"],
			"losses": teams[code]["losses"],
			"history": teams[code]["history"]
		}
	var file = FileAccess.open("user://teamsave.json", FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data))
		file.close()

func load_from_file():
	if not FileAccess.file_exists("user://teamsave.json"):
		return
	var file = FileAccess.open("user://teamsave.json", FileAccess.READ)
	if file:
		var data = file.get_as_text()
		var loaded = JSON.parse_string(data)
		if typeof(loaded) == TYPE_DICTIONARY:
			for team_code in teams:
				if loaded.has(team_code):
					teams[team_code]["wins"] = loaded[team_code].get("wins", 0)
					teams[team_code]["losses"] = loaded[team_code].get("losses", 0)
					teams[team_code]["history"] = loaded[team_code].get("history", [])
		file.close()
# === Helper to archive season history, to call in your season reset ===
func archive_current_season(season_number: int) -> void:
	for team_code in teams.keys():
		var team = teams[team_code]
		
		# Get existing history or create new
		var history = team.get("history", [])
		
		# Current wins/losses for this season
		var wins = team.get("wins", 0)
		var losses = team.get("losses", 0)
		
		# Count championships for this team in this season
		var championships = 0
		for record in TournamentManager.get_tournament_history():
			if record.get("season", 0) == season_number and record.get("champion", "") == team_code:
				championships += 1
		
		# Append season summary to history
		history.append({
			"season": season_number,
			"wins": wins,
			"losses": losses,
			"championships": championships
		})
		
		team["history"] = history
func save_tournament_history_to_file():
	var file = FileAccess.open("user://tournament_history.json", FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(tournament_history))
		file.close()

func load_tournament_history_from_file():
	if not FileAccess.file_exists("user://tournament_history.json"):
		return
	var file = FileAccess.open("user://tournament_history.json", FileAccess.READ)
	if file:
		var data = file.get_as_text()
		var loaded = JSON.parse_string(data)  # returns parsed JSON directly (Array/Dictionary)
		# just check type of loaded, no error property
		if typeof(loaded) == TYPE_ARRAY:
			tournament_history = loaded
		file.close()
		
