extends Node2D
@onready var poster = $TournamentPoster
@onready var JoinedTeamPanel = $JoinedTeam
@onready var JoinedLogo = $JoinedTeam/JoinedLogo
@onready var JoinedLabel = $JoinedTeam/JoinedLabel


var recent_matches = []


func _ready():
	update_ui()

func simulate_team_matches():
	recent_matches.clear()
	var team_codes = TeamDatabase.teams.keys()
	var shuffled = team_codes.duplicate()
	shuffled.shuffle()

	for i in range(0, shuffled.size(), 2):
		if i + 1 < shuffled.size():
			var team1 = shuffled[i]
			var team2 = shuffled[i + 1]

			var team1_strength = get_team_average_mmr(team1)
			var team2_strength = get_team_average_mmr(team2)

			if team1_strength + team2_strength == 0:
				continue

			var prob_team1 = float(team1_strength) / float(team1_strength + team2_strength)
			var upset_chance = 0.2
			var rand_val = randf()
			var winner = ""
			var is_upset = false

			if rand_val < upset_chance:
				winner = team1 if team1_strength < team2_strength else team2
				is_upset = true
			else:
				winner = team1 if randf() < prob_team1 else team2

			var loser = team2 if winner == team1 else team1

			TeamDatabase.record_match_result(winner, loser)

			# Save match info for news generation
			recent_matches.append({
				"winner": winner,
				"loser": loser,
				"winner_strength": team1_strength if winner == team1 else team2_strength,
				"loser_strength": team1_strength if loser == team1 else team2_strength,
				"is_upset": is_upset
			})

func generate_match_news():
	for match in recent_matches:
		var winner_name = TeamDatabase.get_team_name_by_code(match["winner"])
		var loser_name = TeamDatabase.get_team_name_by_code(match["loser"])
		var emoji = "🔥"
		var headline = "%s defeated %s" % [winner_name, loser_name]

		if match["is_upset"]:
			headline = "⚡ Upset! %s shocked %s" % [winner_name, loser_name]

		# Optional: Find MVP player with highest MMR on winning team
		var players = AIdatabase.get_players_by_team(match["winner"])
		var mvp = null
		var top_mmr = -1
		for p in players:
			if p["mmr"] > top_mmr:
				mvp = p
				top_mmr = p["mmr"]

		if mvp != null:
			headline += " thanks to MVP %s (%d MMR)" % [mvp["ign"], top_mmr]

		PlayerData.add_news("Match", "%s %s" % [emoji, headline])
		
		
func get_team_average_mmr(team_code: String) -> float:
	var players = AIdatabase.get_players_by_team(team_code)
	if players.size() == 0:
		return 0
	var total_mmr = 0
	for p in players:
		total_mmr += p["mmr"]
	return float(total_mmr) / players.size()
	
	
func update_ui():
	print("Running update_ui()")

	$Panel/Energy.text = str(PlayerData.energy)
	$Panel/Year.text = str(PlayerData.year)
	$Panel/Week.text = str(PlayerData.week)
	$Panel/Play.disabled = PlayerData.energy <= 0

	var news_container = $Panel/Panel/ScrollContainer/News
	print("News container:", news_container)

	for child in news_container.get_children():
		child.queue_free()

	print("News log:", PlayerData.news_log)

	for entry in PlayerData.news_log:
		var label = Label.new()
		label.text = "S%dW%02d [%s] %s" % [entry.get("season", 1), entry.get("week", 1), entry["tag"], entry["text"]]
		news_container.add_child(label)

func _on_profile_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/profile.tscn")

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/playlobby.tscn")

func _on_teams_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/team_list.tscn")

func _on_leaderboards_pressed() -> void:
	AIdatabase.save_ai_players()  # Keep this
	await get_tree().process_frame  # Add this to delay transition by 1 frame
	get_tree().change_scene_to_file("res://Scenes/leaderboards.tscn")

func _on_next_week_pressed() -> void:
	PlayerData.week += 1
	simulate_team_matches()
	generate_match_news()
	check_player_application()
	

	if PlayerData.week == 30:
		poster.visible = true
		var top_teams = TeamDatabase.get_top_teams(16)
		TournamentManager.create_tournament(top_teams, PlayerData.week, PlayerData.season)
		PlayerData.add_news("Esports", "🔥 Top 16 Tournament begins!")

	TournamentManager.handle_weekly_progress(PlayerData.week)

	if PlayerData.week % 2 == 0:
		generate_news()

	if PlayerData.week > 52:
		_start_new_season()

	# ❌ Remove this - it's called inside update_ai_mmr_weekly()
	# AIdatabase.refill_teams_if_needed()

	# ✅ Weekly AI MMR update with transfer news
	var transfer_news = AIdatabase.update_ai_mmr_weekly()
	for headline in transfer_news:
		PlayerData.add_news("Transfer", "🔄 " + headline)

	AIdatabase.save_ai_players()
	SaveManager.save_game()
	TeamDatabase.save_tournament_history_to_file()
	TeamDatabase.save_to_file()
	

	# Restore player energy
	PlayerData.energy = 100
	update_ui()

func _start_new_season():
	# Archive all teams' season data first (including championships)
	TeamDatabase.archive_current_season(PlayerData.season)

	# Reset all teams' W/L records for the new season
	TeamDatabase.reset_win_loss_records()

	# Update player data for new season
	PlayerData.week = 1
	PlayerData.year += 1
	PlayerData.season += 1
	PlayerData.age += 1
	PlayerData.mmr = 300  # Or whatever reset you want

	# Other season start logic here...
	AIdatabase.reset_all_ai_mmr(PlayerData.season)
	AIdatabase.save_ai_players()
	TeamDatabase.save_to_file()
	

	# Optionally, start a new tournament for the new season
	#var top_teams = TeamDatabase.get_sorted_teams_by_wins().slice(0, 16)
	#TournamentManager.create_tournament(top_teams, PlayerData.week, PlayerData.season)
	#PlayerData.add_news("Esports", "🎮 Season-opening tournament with top 16 teams!")

	update_ui()

func generate_news():
	var options = []
	var tag_emojis = {
		"Retirement": "🏆",
		"Climb": "🚀",
		"Upset": "⚡",
		"Transfer": "🔄",
		"Trivia": "💡",
		"Community": "🎉",
		"Meta": "📈",
		"Esports": "🎮",
		"Buzz": "🐝"
	}

	# ✅ Retirements
	for ai in AIdatabase.ai_players:
		if ai.has("retired_this_week") and ai["retired_this_week"]:
			options.append({
				"tag": "Retirement",
				"text": ai["ign"] + " retires at age " + str(ai["age"]),
				"emoji": tag_emojis.get("Retirement", "")
			})
			ai["retired_this_week"] = false

	# ✅ Climb from MMR history
	for ai in AIdatabase.ai_players:
		if ai.has("mmr_history") and ai["mmr_history"].size() >= 4:
			var past = ai["mmr_history"][-4]
			if ai["mmr"] - past["mmr"] > 400:
				options.append({
					"tag": "Climb",
					"text": ai["ign"] + " climbed " + str(ai["mmr"] - past["mmr"]) + " MMR in just 3 weeks!",
					"emoji": tag_emojis.get("Climb", "")
				})

	# ✅ Upset or Transfer
	if randi() % 2 == 0:
		options.append({
			"tag": "Upset",
			"text": "Team " + TeamDatabase.get_random_team_name() + " upsets the top seed!",
			"emoji": tag_emojis.get("Upset", "")
		})

	if randi() % 3 == 0:
		var transfer_ai = AIdatabase.get_random_ai()
		if transfer_ai:
			options.append({
				"tag": "Transfer",
				"text": "Transfer: " + transfer_ai["ign"] + " joins a rival team!",
				"emoji": tag_emojis.get("Transfer", "")
			})

	# ✅ Always include 1 random filler
	var filler = [
		{ "tag": "Trivia", "text": "Did you know? The average pro clicks 400 times per minute.", "emoji": "💡" },
		{ "tag": "Community", "text": "A fan-made highlight reel is going viral this week!", "emoji": "🎉" },
		{ "tag": "Meta", "text": "Analysts say macro comps are back in meta.", "emoji": "📈" },
		{ "tag": "Esports", "text": TeamDatabase.get_random_team_name() + " unveils new training facility.", "emoji": "🎮" },
		{ "tag": "Buzz", "text": "Rumors swirl after a top player deletes their socials.", "emoji": "🐝" }
	]
	filler.shuffle()
	options.append(filler[0])

	# ✅ Shuffle and show 3 max
	options.shuffle()
	for i in range(min(options.size(), 3)):
		var entry = options[i]
		PlayerData.add_news(entry["tag"], "%s %s" % [entry["emoji"], entry["text"]])

func _on_tournament_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/tournamentgame.tscn")


func _on_close_button_pressed() -> void:
	poster.visible = false


func check_player_application():
	if PlayerData.pending_team_code == "":
		return

	var weeks_passed = PlayerData.week - PlayerData.applied_week

	if weeks_passed >= 2:
		var team_code = PlayerData.pending_team_code
		var players = AIdatabase.get_players_by_team(team_code)

		var weakest_ai = null
		var lowest_mmr = INF

		# Find the overall weakest AI (regardless of role)
		for ai in players:
			if ai["mmr"] < lowest_mmr:
				weakest_ai = ai
				lowest_mmr = ai["mmr"]

		# Calculate dynamic chance based on player's MMR
		var min_mmr = 800
		var max_mmr = 1500
		var clamped_mmr = clamp(PlayerData.mmr, min_mmr, max_mmr)
		var join_chance = lerp(0.8, 0.95, float(clamped_mmr - min_mmr) / (max_mmr - min_mmr))

		if weakest_ai != null and randf() <= join_chance:
			# Replace weakest AI
			weakest_ai["team"] = ""
			weakest_ai["pending_transfer_to"] = ""

			# Assign player to team
			PlayerData.team_code = team_code
			PlayerData.team_name = TeamDatabase.teams[team_code]["name"]
			PlayerData.pending_team_code = ""
			PlayerData.applied_week = -1
			PlayerData.highest_mmr = max(PlayerData.highest_mmr, PlayerData.mmr)

			PlayerData.add_news("Transfer", "✅ You have officially joined %s!" % PlayerData.team_name)

			var joined_panel = get_node_or_null("/root/Game/JoinedTeam")
			if joined_panel:
				var logo = joined_panel.get_node("JoinedLogo")
				var label = joined_panel.get_node("JoinedLabel")
				var logo_path = TeamDatabase.teams[team_code].get("logo", "")
				if logo_path != "":
					logo.texture = load(logo_path)
				label.text = "You joined %s!" % PlayerData.team_name
				joined_panel.visible = true

			print("Joined team:", team_code)
			return

		# Rejection Messages (Expanded)
		var rejection_msgs = [
			"❌ %s declined your application. Try again next season.",
			"❌ %s passed on your request. Gain more experience.",
			"❌ %s is currently full. Improve your stats and try later.",
			"❌ %s's coach said you're not ready yet.",
			"❌ %s reviewed your tape but opted for another player.",
			"❌ %s has locked its roster for the season.",
			"❌ %s rejected your application after internal review.",
			"❌ %s is looking for a different role or playstyle.",
			"❌ %s wants a higher-ranked player to fill the spot.",
			"❌ %s has concerns about your consistency.",
			"❌ %s appreciated your interest, but declined.",
			"❌ %s skipped your application without comment.",
			"❌ %s prefers local talent this split.",
			"❌ %s prioritized a veteran over you.",
			"❌ %s staff wasn't impressed by your stats this season."
		]

		# Add role-aware flavor
		match PlayerData.role:
			"Dps":
				if randf() < 0.3:
					rejection_msgs.append("❌ %s already has a stacked DPS lineup.")
			"Tank":
				if randf() < 0.3:
					rejection_msgs.append("❌ %s is looking for a more aggressive frontliner.")
			"Support":
				if randf() < 0.3:
					rejection_msgs.append("❌ %s wants a more experienced shotcaller.")

		# Add region-aware flavor
		var team_region = TeamDatabase.teams[team_code].get("region", "")
		if PlayerData.region != team_region and randf() < 0.3:
			rejection_msgs.append("❌ %s favored local talent this time.")

		PlayerData.add_news("Transfer", rejection_msgs.pick_random() % TeamDatabase.teams[team_code]["name"])
		PlayerData.pending_team_code = ""
		PlayerData.applied_week = -1


func _on_close_team_pressed() -> void:
	$JoinedTeam.visible = false
