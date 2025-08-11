extends Control

@onready var skills_label = $Panel/Skills
@onready var age_label = $Panel/AgeLabel
@onready var team = $Panel/Team
@onready var winlose = $Panel/WinLose
@onready var championship = $Panel/ChampionshipLabel

func _ready():
	$Panel/fname.text = PlayerData.fullname
	$Panel/ign.text = '" ' + PlayerData.in_game_name + ' "'
	$Panel/Role.text = PlayerData.role
	$Panel/AgeLabel.text = str(PlayerData.age)
	$Panel/RegionLabel.text = PlayerData.region
	$Panel/Team.text = PlayerData.team_name

	var skills_text := ""
	for key in PlayerData.skills:
		skills_text += key + ": " + str(PlayerData.skills[key]) + "\n"
	skills_label.text = skills_text

	$Panel/mmr.text = str(PlayerData.mmr)
	winlose.text = "📊 W-L: %d - %d" % [PlayerData.wins, PlayerData.losses]
	


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
