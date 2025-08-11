extends Control

var countdown := 10
var team1 = [0, 1, 2]
var team2 = [3, 4, 5]

@onready var commentary_log := $Panel/Commentary/ScrollContainer/CommentaryVBox
@onready var match_timer_label := $Panel/MatchTimer
@onready var team1score_label := $Panel/Team1Score
@onready var team2score_label := $Panel/Team2Score

@onready var player_ign_labels = [
	$Panel/Player1, $Panel/Player2, $Panel/Player3,
	$Panel/Player4, $Panel/Player5, $Panel/Player6
]
@onready var player_kda_labels = [
	$Panel/player1kda, $Panel/player2kda, $Panel/player3kda,
	$Panel/player4kda, $Panel/player5kda, $Panel/player6kda
]

var match_players = []

const ROLE_ADVANTAGES = {
	"DPS": "Support",
	"Support": "Tank",
	"Tank": "DPS"
}

func _ready():
	AIdatabase.generate_ai_players()

	var player_data = {
		"ign": PlayerData.in_game_name,
		"role": PlayerData.role,
		"mmr": PlayerData.mmr,
		"kda": {"kills": 0, "deaths": 0, "assists": 0},
		"killstreak": 0,
		"is_player": true,
		"playstyle": PlayerData.playstyle
	}
	match_players.append(player_data)

	var mmr_range = 300
	var eligible = AIdatabase.ai_players.filter(func(ai):
		return abs(ai["mmr"] - PlayerData.mmr) <= mmr_range
	)
	eligible.shuffle()

	for i in range(5):
		var ai = eligible[i].duplicate()
		ai["kda"] = {"kills": 0, "deaths": 0, "assists": 0}
		ai["killstreak"] = 0
		ai["is_player"] = false
		match_players.append(ai)

	for i in range(6):
		player_ign_labels[i].text = match_players[i]["ign"]
		update_kda_label(i)

	update_team_scores()

func _on_play_pressed():
	PlayerData.energy = max(0, PlayerData.energy - 20)
	$Panel/Play.disabled = true
	$Panel/Back.disabled = true
	countdown = 10
	match_timer_label.text = "Time: %d" % countdown
	$Panel/Timer.start()
	add_commentary("%s locked in as %s." % [PlayerData.in_game_name, PlayerData.role])

func _on_timer_timeout():
	if countdown <= 0:
		$Panel/Timer.stop()
		$Panel/Back.disabled = false
		match_timer_label.text = "Match Over"
		determine_result_and_adjust_mmr()
		show_match_summary()
		return

	# Time-based commentary events
	match countdown:
		9: add_commentary("⚙️ Teams are setting up lanes and scouting.")
		6: add_commentary("🐉 Dragon secured by %s!" % match_players.pick_random()["ign"])
		4: add_commentary("💣 %s stole the objective at the last second!" % match_players.pick_random()["ign"])
		3: add_commentary("🧿 Baron taken by %s!" % match_players.pick_random()["ign"])
		1: add_commentary("📣 Final push happening across the map!")

	# Select attacking and victim teams
	var attacker_team = team1 if randi() % 2 == 0 else team2
	var victim_team = team2 if attacker_team == team1 else team1

	var attacker_index = attacker_team[randi_range(0, attacker_team.size() - 1)]
	var victim_index = victim_team[randi_range(0, victim_team.size() - 1)]
	while victim_index == attacker_index:
		victim_index = victim_team[randi_range(0, victim_team.size() - 1)]

	var attacker = match_players[attacker_index]
	var victim = match_players[victim_index]

	# Assister must be from same team as attacker and not attacker or victim
	var potential_assisters = []
	for i in attacker_team:
		if i != attacker_index and i != victim_index:
			potential_assisters.append(i)

	var assister_index = potential_assisters.pick_random() if potential_assisters.size() > 0 else attacker_index
	var assister = match_players[assister_index]

	# Combat resolution
	var atk_score = calculate_combat_score(attacker)
	var def_score = calculate_combat_score(victim)

	if ROLE_ADVANTAGES.get(attacker["role"]) == victim["role"]:
		atk_score += 30
	elif ROLE_ADVANTAGES.get(victim["role"]) == attacker["role"]:
		def_score += 30

	var success = randf() < (atk_score / float(atk_score + def_score + 1))

	if success:
		attacker["kda"]["kills"] += 1
		attacker["killstreak"] += 1
		victim["kda"]["deaths"] += 1
		victim["killstreak"] = 0
		assister["kda"]["assists"] += 1

		add_commentary("💥 %s eliminated %s with support from %s." % [attacker["ign"], victim["ign"], assister["ign"]])
		handle_killstreak(attacker)

		if attacker["killstreak"] == 5:
			add_commentary("🦸 %s is hard carrying their team!" % attacker["ign"])
		elif attacker["killstreak"] == 8:
			add_commentary("🌟 LEGENDARY performance by %s!" % attacker["ign"])

		if victim["killstreak"] >= 3:
			add_commentary("⛔ %s's streak was shut down by %s!" % [victim["ign"], attacker["ign"]])

		if randf() < 0.15:
			add_commentary("🎯 %s landed a perfect skillshot on %s!" % [attacker["ign"], victim["ign"]])

		if atk_score > def_score + 50 and randf() < 0.1:
			add_commentary("🧠 %s outsmarted %s with a brilliant play!" % [attacker["ign"], victim["ign"]])

		if randf() < 0.05:
			add_commentary("🧼 Clean teamfight win by %s's squad!" % attacker["ign"])
	else:
		add_commentary("⚔️ %s tried to outplay %s but failed." % [attacker["ign"], victim["ign"]])
		if randf() < 0.2:
			add_commentary("🆘 %s barely escaped with 1 HP!" % victim["ign"])

	# 1v1 Duel Event (5% chance)
	if randf() < 0.05:
		var duel_a = match_players[randi_range(0, 5)]
		var duel_b = match_players[randi_range(0, 5)]
		while duel_b == duel_a:
			duel_b = match_players[randi_range(0, 5)]

		add_commentary("🤜 1v1 CLASH! %s and %s are dueling it out!" % [duel_a["ign"], duel_b["ign"]])
		var duel_winner = duel_a if randf() < 0.5 else duel_b
		add_commentary("💥 %s wins the clutch duel!" % duel_winner["ign"])

	# Funny misplay event (2% chance)
	if randf() < 0.02:
		var thrower = match_players[randi_range(0, 5)]
		add_commentary("🤦 %s made a horrible misplay!" % thrower["ign"])

	# Update KDA labels
	for i in range(6):
		update_kda_label(i)

	update_team_scores()
	countdown -= 1
	match_timer_label.text = "Time: %d" % countdown


func show_match_summary():
	add_commentary("📊 Match Summary:")
	for i in range(6):
		var p = match_players[i]
		var kda = p["kda"]
		var deaths = max(kda["deaths"], 1)
		var kda_ratio = (kda["kills"] + kda["assists"]) / float(deaths)
		add_commentary("- %s: %d/%d/%d (%d🔥) | KDA: %.2f" % [
			p["ign"], kda["kills"], kda["deaths"], kda["assists"], p.get("killstreak", 0), kda_ratio
		])

func calculate_combat_score(player) -> float:
	var base = player["mmr"]
	var bonus := 0
	match player.get("playstyle", ""):
		"Aggressive":
			bonus = 80 if randf() < 0.8 else -10   # More often high bonus
		"Defensive":
			bonus = 70 if randf() < 0.75 else 10   # Defensive now more rewarded
		"Macro-focused":
			bonus = 60 if randf() < 0.7 else 0     # Safer, more stable
		"Balanced":
			bonus = 65 if randf() < 0.85 else 20   # Usually high bonus
	return base + bonus + randi_range(-5, 15)     # Slightly less RNG penalty

func handle_killstreak(player):
	match player["killstreak"]:
		3: add_commentary("🔥 %s is on a rampage!" % player["ign"])
		5: add_commentary("💀 %s is unstoppable!" % player["ign"])
		8: add_commentary("👑 %s is dominating the game!" % player["ign"])

func update_kda_label(index):
	var kda = match_players[index]["kda"]
	var streak = match_players[index]["killstreak"]
	player_kda_labels[index].text = "%d/%d/%d (%d🔥)" % [kda["kills"], kda["deaths"], kda["assists"], streak]

func update_team_scores():
	var team1_kills = 0
	var team2_kills = 0
	for i in range(3): team1_kills += match_players[i]["kda"]["kills"]
	for i in range(3, 6): team2_kills += match_players[i]["kda"]["kills"]
	team1score_label.text = str(team1_kills)
	team2score_label.text = str(team2_kills)

func determine_result_and_adjust_mmr():
	var team1_kills = 0
	var team2_kills = 0
	for i in range(3): team1_kills += match_players[i]["kda"]["kills"]
	for i in range(3, 6): team2_kills += match_players[i]["kda"]["kills"]

	if team1_kills == team2_kills:
		var coin = randi() % 2
		if coin == 0:
			team1_kills += 1
		else:
			team2_kills += 1
		add_commentary("🟡 Tie-breaker! Coinflip gave final kill to %s!" % (["Team 1", "Team 2"][coin]))

	update_team_scores()
	add_commentary("🎯 Final Score: %d - %d" % [team1_kills, team2_kills])

	var team1_win = team1_kills > team2_kills
	var player_index = 0
	var player_win = (player_index < 3 and team1_win) or (player_index >= 3 and not team1_win)
	add_commentary("🏆 Victory!" if player_win else "❌ Defeat!")

	for i in range(6):
		var p = match_players[i]
		var is_win = (i < 3 and team1_win) or (i >= 3 and not team1_win)
		var change = randi_range(40, 90) if is_win else -randi_range(10, 15)
		p["mmr"] = max(300, p["mmr"] + change)

		if p.get("is_player", false):
			PlayerData.mmr = p["mmr"]
			PlayerData.highest_mmr = max(PlayerData.highest_mmr, PlayerData.mmr)
			var kda = p["kda"]
			PlayerData.apply_skill_progression(kda["kills"], kda["deaths"], kda["assists"])

			# ✅ Save win/loss count here
			if player_win:
				PlayerData.wins += 1
			else:
				PlayerData.losses += 1
		else:
			for j in range(AIdatabase.ai_players.size()):
				if AIdatabase.ai_players[j]["ign"] == p["ign"]:
					AIdatabase.ai_players[j]["mmr"] = p["mmr"]
					break

	var mvp = match_players[0]
	for p in match_players:
		var score = p["kda"]["kills"] * 3 + p["kda"]["assists"] * 1.5 - p["kda"]["deaths"] * 2
		var best = mvp["kda"]["kills"] * 3 + mvp["kda"]["assists"] * 1.5 - mvp["kda"]["deaths"] * 2
		if score > best:
			mvp = p

	add_commentary("🏅 MVP: %s with %d/%d/%d!" % [
		mvp["ign"], mvp["kda"]["kills"], mvp["kda"]["deaths"], mvp["kda"]["assists"]
	])

	AIdatabase.save_ai_players()

func add_commentary(text: String):
	var label = Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 28)
	commentary_log.add_child(label)

func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/playlobby.tscn")
