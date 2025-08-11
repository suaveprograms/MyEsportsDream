extends Control

@onready var round_16_col = $Panel/GamePanel/ScrollContainer/RoundsContainer/Round16Column
@onready var qf_col = $Panel/GamePanel/ScrollContainer/RoundsContainer/QuarterfinalColumn
@onready var sf_col = $Panel/GamePanel/ScrollContainer/RoundsContainer/SemifinalColumn
@onready var final_col = $Panel/GamePanel/ScrollContainer/RoundsContainer/FinalColumn

func _ready():
	if TournamentManager == null:
		push_error("TournamentManager is null! Check autoload setup.")
		return

	_show_all_rounds()

func _show_all_rounds():
	for round in range(1, TournamentManager.get_current_round() + 1):
		var matches = TournamentManager.get_matches_for_round(round)

		match round:
			1:
				_clear_column(round_16_col)
				_add_heading("Round of 16", round_16_col)
			2:
				_clear_column(qf_col)
				_add_heading("Quarterfinals", qf_col)
			3:
				_clear_column(sf_col)
				_add_heading("Semifinals", sf_col)
			4:
				_clear_column(final_col)
				_add_heading("Final", final_col)

		for match in matches:
			var name_a = TeamDatabase.get_team_name_by_code(match.team_a)
			var name_b = TeamDatabase.get_team_name_by_code(match.team_b) if match.team_b != null else ""
			var score = match.score if match.has("score") else "vs"
			var emoji = "🎮"
			if score == "auto-advance":
				emoji = "⚠️"

			var label = Label.new()
			label.text = "%s %s %s %s" % [emoji, name_a, score, name_b]
			label.custom_minimum_size = Vector2(320, 32)
			label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			label.add_theme_color_override("font_color", Color.WHITE)
			label.add_theme_font_size_override("font_size", 18)
			if score == "auto-advance":
				label.add_theme_color_override("font_color", Color.ORANGE)

			match round:
				1: round_16_col.add_child(label)
				2: qf_col.add_child(label)
				3: sf_col.add_child(label)
				4: final_col.add_child(label)

	if TournamentManager.get_winner() != "":
		var winner_label = Label.new()
		var winner_name = TeamDatabase.get_team_name_by_code(TournamentManager.get_winner())
		winner_label.text = "🏆 Champion: %s 🥇" % winner_name
		winner_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		winner_label.custom_minimum_size = Vector2(320, 30)
		winner_label.add_theme_color_override("font_color", Color.YELLOW)
		winner_label.add_theme_font_size_override("font_size", 20)
		final_col.add_child(winner_label)

func _clear_column(column: VBoxContainer):
	for child in column.get_children():
		column.remove_child(child)
		child.queue_free()

func _add_heading(text: String, column: VBoxContainer):
	var heading = Label.new()
	heading.text = text
	heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	heading.custom_minimum_size = Vector2(320, 30)
	heading.add_theme_color_override("font_color", Color.YELLOW)
	heading.add_theme_font_size_override("font_size", 18)
	column.add_child(heading)

func _show_current_round():
	var round = TournamentManager.get_current_round()
	var matches = TournamentManager.get_matches_for_round(round)

	print("Displaying Round %d" % round)

	match round:
		1:
			_clear_column(round_16_col)
			_add_heading("Round of 16", round_16_col)
		2:
			_clear_column(qf_col)
			_add_heading("Quarterfinals", qf_col)
		3:
			_clear_column(sf_col)
			_add_heading("Semifinals", sf_col)
		4:
			_clear_column(final_col)
			_add_heading("Final", final_col)

	for match in matches:
		var name_a = TeamDatabase.get_team_name_by_code(match.team_a)
		var name_b = TeamDatabase.get_team_name_by_code(match.team_b) if match.team_b != null else ""
		var score = match.score if match.has("score") else "vs"
		var emoji = "🎮"
		if score == "auto-advance":
			emoji = "⚠️"

		print("Creating label: %s %s %s" % [name_a, score, name_b])

		var label = Label.new()
		label.text = "%s %s %s %s" % [emoji, name_a, score, name_b]
		label.autowrap_mode = TextServer.AUTOWRAP_OFF
		label.custom_minimum_size = Vector2(320, 32)
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.add_theme_color_override("font_color", Color.WHITE)
		label.add_theme_font_size_override("font_size", 18)
		if score == "auto-advance":
			label.add_theme_color_override("font_color", Color.ORANGE)

		match round:
			1:
				round_16_col.add_child(label)
				print("→ Added to Round16Column")
			2:
				qf_col.add_child(label)
				print("→ Added to QuarterfinalColumn")
			3:
				sf_col.add_child(label)
				print("→ Added to SemifinalColumn")
			4:
				final_col.add_child(label)
				print("→ Added to FinalColumn")

	if round == 4 and TournamentManager.get_winner() != "":
		var winner_label = Label.new()
		var winner_name = TeamDatabase.get_team_name_by_code(TournamentManager.get_winner())
		winner_label.text = "🏆 Champion: %s 🥇" % winner_name
		winner_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		winner_label.custom_minimum_size = Vector2(320, 30)
		winner_label.add_theme_color_override("font_color", Color.YELLOW)
		winner_label.add_theme_font_size_override("font_size", 20)
		final_col.add_child(winner_label)

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
