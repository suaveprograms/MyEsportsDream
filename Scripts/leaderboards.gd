extends Control

@onready var playstyle_label = $AIDetailPanel/Playstylelabel
@onready var leaderboards_vbox = $Panel/LBoards/ScrollContainer/LeaderboardsVBox
@onready var detail_panel = $AIDetailPanel
@onready var ign_label = $AIDetailPanel/IgnLabel
@onready var current_mmr_label = $AIDetailPanel/CurrentMmrLabel
@onready var highest_mmr_label = $AIDetailPanel/HighestMmrLabel
@onready var age_label = $AIDetailPanel/AgeLabel
@onready var team_label = $AIDetailPanel/TeamLabel
@onready var championshiplabel = $AIDetailPanel/ChampionshipLabel

func _ready():
	AIdatabase.load_ai_players()
	populate_leaderboards()
	$Panel/Season.text = str(PlayerData.season)

func populate_leaderboards():
	for child in leaderboards_vbox.get_children():
		child.queue_free()

	var filtered_players = AIdatabase.ai_players.filter(func(p): return p["mmr"] >= 800)

	# ✅ Add player if qualified
	if PlayerData.mmr >= 800:
		filtered_players.append({
			"ign": PlayerData.in_game_name,
			"role": PlayerData.role,
			"mmr": PlayerData.mmr,
			"age": PlayerData.age,
			"highest_mmr": PlayerData.highest_mmr,
			"playstyle": PlayerData.playstyle,
			"team": PlayerData.team_code,
			"is_player": true
		})

	# ✅ Sort by MMR descending
	filtered_players.sort_custom(Callable(self, "_compare_mmr_desc"))

	var count = min(filtered_players.size(), 100)
	for i in range(count):
		var ai = filtered_players[i]

		var badge = ""
		match i:
			0: badge = "👑 "
			1: badge = "🥈 "
			2: badge = "🥉 "

		var is_player = ai.get("is_player", false)
		var btn = Button.new()
		btn.text = "%s%d. %s | Role: %s | MMR: %d" % [
			badge,
			i + 1,
			ai["ign"],
			ai["role"],
			int(ai["mmr"])  # ✅ Ensure integer
		]

		if is_player:
			btn.add_theme_color_override("font_color", Color.YELLOW)
			btn.text += " (You)"

		btn.add_theme_font_size_override("font_size", 25)
		btn.connect("pressed", Callable(self, "_on_ai_clicked").bind(ai))
		leaderboards_vbox.add_child(btn)

func _on_ai_clicked(ai_data: Dictionary) -> void:
	age_label.text = str(ai_data.get("age", "??"))
	ign_label.text = ai_data["ign"]
	current_mmr_label.text = str(int(ai_data["mmr"]))  # ✅ Integer only
	highest_mmr_label.text = str(int(ai_data.get("highest_mmr", ai_data["mmr"])))  # ✅ Integer only
	playstyle_label.text = ai_data.get("playstyle", "Unknown")
	$AIDetailPanel/RankLabel.text = AIdatabase.get_rank_name(ai_data["mmr"])
	$AIDetailPanel/Region.text = ai_data.get("region", "Unknown")

	var team_code = ai_data.get("team", "")
	if team_code != "":
		var team_data = TeamDatabase.teams.get(team_code, {})
		var team_name = team_data.get("name", team_code)
		team_label.text = "Team: " + team_name
	else:
		team_label.text = "No Team"

	detail_panel.visible = true

func _compare_mmr_desc(a, b):
	return a["mmr"] > b["mmr"]

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game.tscn")

func _on_exit_pressed() -> void:
	detail_panel.visible = false
