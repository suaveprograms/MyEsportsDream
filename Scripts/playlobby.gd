extends Control

@onready var ign = PlayerData.in_game_name
@onready var mmr = PlayerData.mmr
@onready var role = PlayerData.role

@onready var match_status_label: Label = $Panel/MatchStatusLabel
@onready var play_ranked_button: Button = $Panel/Playranked
@onready var backbutton: Button = $Panel/back
@onready var playstyle_option: OptionButton = $Panel/PlaystyleOptionButton
@onready var rank: Label = $Panel/RankLabel
func _ready():
	$Panel/ign.text = ign
	$Panel/mmr.text = str(mmr)
	$Panel/role.text = role
	$Panel/RankLabel.text = PlayerData.get_rank_name()

	# Populate the playstyle list (with "Balanced" always included)
	playstyle_option.clear()
	playstyle_option.add_item("Balanced")
	for style in PlayerData.playstyles:
		if style != "Balanced":  # Avoid duplicates
			playstyle_option.add_item(style)

	# Set default selection to "Balanced" if PlayerData.playstyle is empty
	if PlayerData.playstyle == "":
		PlayerData.playstyle = "Balanced"

	# Select the current playstyle in dropdown
	for i in range(playstyle_option.item_count):
		if playstyle_option.get_item_text(i) == PlayerData.playstyle:
			playstyle_option.select(i)
			break

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game.tscn")

func simulate_finding_match(seconds: int) -> void:
	for i in range(seconds):
		await get_tree().create_timer(1.0).timeout
		match_status_label.text = "Finding match" + ".".repeat((i % 3) + 1)

func _on_playranked_pressed() -> void:
	play_ranked_button.disabled = true
	backbutton.disabled = true
	playstyle_option.disabled = true
	# Set playstyle BEFORE starting match
	var selected_index = playstyle_option.get_selected()
	var selected_playstyle = playstyle_option.get_item_text(selected_index) if selected_index >= 0 else "Balanced"
	PlayerData.set_playstyle(selected_playstyle)

	match_status_label.text = "Finding match..."

	var match_time = randi_range(5, 10)
	await simulate_finding_match(match_time)

	match_status_label.text = "✅ Match found!"
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://Scenes/ranked_game.tscn")
