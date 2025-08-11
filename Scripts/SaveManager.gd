extends Node

var save_path := "user://savegame.dat"

func save_game():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		var save_data = {
			"player": {
				"fullname": PlayerData.fullname,
				"in_game_name": PlayerData.in_game_name,
				"gender": PlayerData.gender,
				"role": PlayerData.role,
				"mmr": PlayerData.mmr,
				"year": PlayerData.year,
				"week": PlayerData.week,
				"energy": PlayerData.energy,
				"skills": PlayerData.skills,
				"season": PlayerData.season,
				"age": PlayerData.age,
				"region": PlayerData.region,
				"team_code": PlayerData.team_code,
				"team_name": PlayerData.team_name,
				"pending_team_code": PlayerData.pending_team_code,
				"applied_week": PlayerData.applied_week,
				"team_application_cooldowns": PlayerData.team_application_cooldowns,
				"news_log": PlayerData.news_log,
				"wins": PlayerData.wins,         # ✅ Added
				"losses": PlayerData.losses      # ✅ Added
			},
			"ai_players": AIdatabase.ai_players
		}
		file.store_var(save_data)
		file.close()
		print("✅ Game saved.")

func load_game():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		if file:
			var save_data = file.get_var()
			var p = save_data["player"]

			PlayerData.fullname = p.get("fullname", "")
			PlayerData.in_game_name = p.get("in_game_name", "")
			PlayerData.gender = p.get("gender", "")
			PlayerData.role = p.get("role", "")
			PlayerData.mmr = p.get("mmr", 300)
			PlayerData.year = p.get("year", 1)
			PlayerData.week = p.get("week", 1)
			PlayerData.energy = p.get("energy", 100)
			PlayerData.skills = p.get("skills", {})
			PlayerData.season = p.get("season", 1)
			PlayerData.age = p.get("age", 16)
			PlayerData.region = p.get("region", "NA")
			PlayerData.team_code = p.get("team_code", "")
			PlayerData.team_name = p.get("team_name", "")
			PlayerData.pending_team_code = p.get("pending_team_code", "")
			PlayerData.applied_week = p.get("applied_week", -1)
			PlayerData.team_application_cooldowns = p.get("team_application_cooldowns", {})
			PlayerData.news_log = p.get("news_log", [])
			PlayerData.wins = p.get("wins", 0)         # ✅ Added
			PlayerData.losses = p.get("losses", 0)     # ✅ Added

			AIdatabase.ai_players = save_data.get("ai_players", [])
			AIdatabase.generated = true

			file.close()
			print("✅ Game loaded.")

func _exit_tree():
	save_game()
	TeamDatabase.save_tournament_history_to_file()
