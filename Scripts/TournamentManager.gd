extends Node

var tournament_in_progress := false
var current_round := 0
var bracket := []
var tournament_week := 0
var round_matches := {}  # Matches played per round
var tournament_history := []  # Stores completed tournaments with champions
var current_season := 0

func create_tournament(team_codes: Array, week: int, season: int) -> void:
	tournament_in_progress = true
	current_round = 1
	tournament_week = week
	current_season = season
	bracket = team_codes.duplicate()
	bracket.shuffle()
	round_matches.clear()

	# Tournament news
	PlayerData.add_news("Esports", "🏆 Tournament begins with %d teams!" % bracket.size())

	# Update horizontal tournament poster
	update_tournament_poster()

func update_tournament_poster() -> void:
	# Update Label version (optional fallback)
	var label_path = "/root/Game/TournamentPoster/Label"
	if has_node(label_path):
		var label = get_node(label_path)
		var team_names = ""
		for i in range(min(16, bracket.size())):
			var name = TeamDatabase.get_team_name_by_code(bracket[i])
			team_names += name
			if i < 15:
				team_names += "  |  "
		label.text = "🎯 Top 16 Tournament Teams:\n" + team_names

	# Update HBoxContainer version (recommended for clean horizontal layout)
	var hbox_path = "/root/Game/TournamentPoster/ScrollContainer/TopTeamsHBox"
	if has_node(hbox_path):
		var hbox = get_node(hbox_path)
		clear_container_children(hbox)

		for i in range(min(16, bracket.size())):
			var code = bracket[i]
			var name = TeamDatabase.get_team_name_by_code(code)

			var team_label = Label.new()
			team_label.text = name
			team_label.add_theme_color_override("font_color", Color.WHITE)
			team_label.add_theme_font_size_override("font_size", 20)
			hbox.add_child(team_label)
	else:
		print_debug("⚠️ Could not find HBoxContainer at: %s" % hbox_path)
func clear_container_children(container: Node) -> void:
	for child in container.get_children():
		container.remove_child(child)
		child.queue_free()

func handle_weekly_progress(current_week: int) -> void:
	if not tournament_in_progress:
		return
	if current_week <= tournament_week:
		return

	tournament_week = current_week
	var next_round = []
	var matches_this_round = []

	for i in range(0, bracket.size(), 2):
		if i + 1 >= bracket.size():
			var auto_team = bracket[i]
			next_round.append(auto_team)
			matches_this_round.append({
				"team_a": auto_team,
				"team_b": null,
				"winner": auto_team,
				"score": "auto-advance"
			})
			PlayerData.add_news("Esports", "%s auto-advances!" % TeamDatabase.get_team_name_by_code(auto_team))
			continue

		var team1 = bracket[i]
		var team2 = bracket[i + 1]

		var winner = [team1, team2].pick_random()
		var loser = team1 if winner == team2 else team2

		var score_a = randi_range(1, 3)
		var score_b = randi_range(0, score_a - 1)
		if winner == team2:
			var temp = score_a
			score_a = score_b
			score_b = temp

		var match = {
			"team_a": team1,
			"team_b": team2,
			"winner": winner,
			"score": "%d-%d" % [score_a, score_b]
		}
		matches_this_round.append(match)
		next_round.append(winner)

		PlayerData.add_news("Esports", "%s defeats %s (%s)" % [
			TeamDatabase.get_team_name_by_code(winner),
			TeamDatabase.get_team_name_by_code(loser),
			match.score
		])

	bracket = next_round
	round_matches[current_round] = matches_this_round
	current_round += 1

	if bracket.size() <= 1:
		var champion = bracket[0]
		var champion_name = TeamDatabase.get_team_name_by_code(champion)
		PlayerData.add_news("Esports", "🏆 %s are the tournament champions!" % champion_name)

		tournament_history.append({
			"week": tournament_week,
			"season": current_season,
			"champion": champion,
			"name": champion_name,
			"rounds": round_matches.duplicate(true)
		})

		tournament_in_progress = false
		TeamDatabase.save_tournament_history_to_file()

func get_current_round() -> int:
	return current_round

func get_matches_for_round(round: int) -> Array:
	return round_matches.get(round, [])

func get_winner() -> String:
	if not tournament_in_progress and bracket.size() == 1:
		return bracket[0]
	return ""

func get_tournament_history() -> Array:
	return tournament_history
