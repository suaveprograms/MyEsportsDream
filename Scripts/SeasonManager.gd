# Inside SeasonManager.gd or similar
extends Node

@onready var team_db = TeamDatabase
@onready var tournament = TournamentManager

var current_week = 1
const MAX_WEEKS = 30

func _ready():
	team_db.reset_all_records()

func simulate_week():
	var all_teams = team_db.teams.keys()
	all_teams.shuffle()

	for i in range(0, all_teams.size(), 2):
		if i + 1 >= all_teams.size():
			break

		var team_a = all_teams[i]
		var team_b = all_teams[i + 1]

		var winner = team_a if randf() < 0.5 else team_b
		var loser = team_b if winner == team_a else team_a

		team_db.record_match_result(winner, loser)
		print("🏆 Week %d Match: %s beat %s" % [current_week, team_db.get_team_name_by_code(winner), team_db.get_team_name_by_code(loser)])

	# Check if it's time for the tournament
	if current_week == MAX_WEEKS:
		start_tournament()

	current_week += 1

func start_tournament():
	var top16 = team_db.get_sorted_teams_by_wins().slice(0, 16)
	print("⚔️ Starting Tournament with Top 16 Teams: ", top16)
	tournament.create_tournament(top16, current_week, PlayerData.season)
