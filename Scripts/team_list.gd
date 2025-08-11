extends Control

@onready var team_list_vbox = $Teams/Panel/ScrollContainer/TeamLeaderboardVBox
@onready var view_panel = $ViewTeam
@onready var team_name_label = $ViewTeam/TeamNameLabel
@onready var team_logo = $ViewTeam/TeamLogo
@onready var championships = $ViewTeam/Championships
@onready var win_lose = $ViewTeam/Win_Lose
@onready var ViewHistory = $ViewTeam/ViewHistory # Button
@onready var Apply = $ViewTeam/Apply # Button
@onready var HistoryPanel = $ViewTeam/HistoryPanel
@onready var history_vbox = $ViewTeam/HistoryPanel/ScrollContainer/HistoryVBox

@onready var player_labels = [
	$ViewTeam/Player1Label,
	$ViewTeam/Player2Label,
	$ViewTeam/Player3Label,
	$ViewTeam/Player4Label,
	$ViewTeam/Player5Label,
]

@onready var back_button = $ViewTeam/Back

var selected_team_code = ""  # Store currently selected team code

func _ready():
	populate_team_list()
	update_apply_button_state()

func populate_team_list():
	for child in team_list_vbox.get_children():
		child.queue_free()

	var sorted_teams = TeamDatabase.get_sorted_teams_by_wins()

	for team_code in sorted_teams:
		var team_data = TeamDatabase.teams.get(team_code, {})
		var team_name = team_data.get("name", team_code)
		var players = AIdatabase.get_players_by_team(team_code)

		var total_mmr = 0
		for p in players:
			total_mmr += p.get("mmr", 0)

		var button = Button.new()
		button.text = "%s - %d MMR" % [team_name, total_mmr]
		button.name = team_code
		button.add_theme_font_size_override("font_size", 38)
		button.pressed.connect(_on_team_button_pressed.bind(team_code))
		team_list_vbox.add_child(button)

func _on_team_button_pressed(team_code: String) -> void:
	selected_team_code = team_code

	var team_data = TeamDatabase.teams.get(team_code, {})
	var team_name = team_data.get("name", team_code)
	var logo_path = team_data.get("logo", "")
	var players = AIdatabase.get_players_by_team(team_code)
	var region = team_data.get("region", "??")

	team_name_label.text = "Team: %s (%s)" % [team_name, region]

	if logo_path != "":
		team_logo.texture = load(logo_path)
	else:
		team_logo.texture = null

	for i in range(player_labels.size()):
		if i < players.size():
			var p = players[i]
			player_labels[i].text = "%s (%s) - %d MMR" % [
				p.get("ign", "???"),
				p.get("role", "?"),
				p.get("mmr", 0)
			]
		else:
			player_labels[i].text = "-"

	var titles = 0
	for season_data in team_data.get("history", []):
		titles += season_data.get("championships", 0)

	championships.text = "🏆 Championships: %d" % titles

	var wins = team_data.get("wins", 0)
	var losses = team_data.get("losses", 0)
	win_lose.text = "📊 W-L: %d - %d" % [wins, losses]

	view_panel.visible = true
	update_apply_button_state()

func _on_view_history_pressed() -> void:
	if selected_team_code == "":
		return

	show_team_history(selected_team_code)
	HistoryPanel.visible = true

func show_team_history(team_code: String) -> void:
	for child in history_vbox.get_children():
		child.queue_free()

	var team_data = TeamDatabase.teams.get(team_code, {})
	var history = team_data.get("history", [])

	if history.size() == 0:
		var no_history = Label.new()
		no_history.text = "No historical data available."
		history_vbox.add_child(no_history)
		return

	for season_data in history:
		var label = Label.new()
		label.text = "Season %d - W: %d | L: %d | 🏆: %d" % [
			season_data.get("season", 0),
			season_data.get("wins", 0),
			season_data.get("losses", 0),
			season_data.get("championships", 0)
		]
		label.add_theme_font_size_override("font_size", 20)
		history_vbox.add_child(label)

func _on_back_pressed():
	view_panel.visible = false

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game.tscn")

func _on_back_to_team_pressed() -> void:
	HistoryPanel.visible = false

func _on_apply_pressed():
	if selected_team_code == "":
		return

	# Prevent applying again to the same team
	if PlayerData.pending_team_code != "":
		print("Already applied to a team.")
		return

	PlayerData.pending_team_code = selected_team_code
	PlayerData.applied_week = PlayerData.week
	PlayerData.team_application_cooldowns[selected_team_code] = PlayerData.week

	PlayerData.add_news("Application", "You applied to join %s. Please wait 2 weeks for a response." % TeamDatabase.teams[selected_team_code]["name"])
	print("Application sent to", selected_team_code)
	view_panel.visible = false
	update_apply_button_state()

func update_apply_button_state():
	if not is_instance_valid(Apply):
		return

	if PlayerData.pending_team_code != "":
		Apply.disabled = true
		Apply.text = "Applied"
	elif PlayerData.mmr >= 800:
		Apply.disabled = false
		Apply.text = "Apply"
	else:
		Apply.disabled = true
		Apply.text = "Need 800+ MMR"
