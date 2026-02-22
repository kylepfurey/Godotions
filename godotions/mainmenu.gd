extends Control

func _on_options_pressed() -> void: #do we want options menu?
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_start_pressed() -> void:
	var loading_scene = preload("res://start stuff/select_screen.tscn")
	var loading = loading_scene.instantiate()
	add_child(loading)
	#change this to whatever scene is the first one. When i tested the mainhideout.tscn
	#was first so I dont want to break anything just change it here lol.
