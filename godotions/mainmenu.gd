extends Control

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://start stuff/select_screen.tscn")
	#change this to whatever scene is the first one. When i tested the mainhideout.tscn
	#was first so I dont want to break anything just change it here lol.


func _on_options_pressed() -> void: #do we want options menu?
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	get_tree().quit()
