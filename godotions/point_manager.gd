extends Node

var p1_points: int = 0
var p2_points: int = 0

signal points_changed

func add_points_to_player(player: int, amount: int):
	if player == 1:
		p1_points += amount
	elif player == 2:
		p2_points += amount
		
	emit_signal("points_changed")
	
func reset_points():
	p1_points = 0
	p2_points = 0
	emit_signal("points_changed")
