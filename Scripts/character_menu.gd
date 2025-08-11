extends Node2D

@onready var fullname_input = $Characters/fname
@onready var ign_input = $Characters/ign
@onready var gender_option = $Characters/gender
@onready var role_option = $Characters/role
@onready var region_option = $Characters/region  # <- Region OptionButton
@onready var start_button = $Characters/Startgame

func _ready():
	fullname_input.text_changed.connect(_on_input_changed)
	ign_input.text_changed.connect(_on_input_changed)
	gender_option.item_selected.connect(_on_input_changed)
	role_option.item_selected.connect(_on_input_changed)
	region_option.item_selected.connect(_on_input_changed)

	# Add region choices
	region_option.clear()
	region_option.add_item("NA")
	region_option.add_item("EU")
	region_option.add_item("KR")
	region_option.add_item("CN")
	region_option.add_item("SEA")
	region_option.add_item("BR")

	_on_input_changed()

func _on_input_changed(_unused: Variant = null):
	var fullname_filled = fullname_input.text.strip_edges() != ""
	var ign_filled = ign_input.text.strip_edges() != ""
	var gender_selected = gender_option.selected >= 0
	var role_selected = role_option.selected >= 0
	var region_selected = region_option.selected >= 0

	start_button.disabled = not (
		fullname_filled and ign_filled and gender_selected and role_selected and region_selected
	)

func _on_startgame_pressed():
	if start_button.disabled:
		return

	PlayerData.set_player_info(
		fullname_input.text,
		ign_input.text,
		gender_option.get_item_text(gender_option.selected),
		role_option.get_item_text(role_option.selected),
		region_option.get_item_text(region_option.selected)  # <- pass region
	)

	PlayerData.initialize_skills(role_option.get_item_text(role_option.selected))
	PlayerData.year = 1
	PlayerData.week = 1
	PlayerData.energy = 100
	PlayerData.mmr = 300

	AIdatabase.generated = false
	AIdatabase.generate_ai_players()
	AIdatabase.save_ai_players()
	

	SaveManager.save_game()
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
