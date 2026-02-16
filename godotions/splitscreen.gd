extends Node

var parent_window : Window
var child_window : Window

func _ready():	
	print("Splitscreen._ready()")
	parent_window = get_window()
	parent_window.title = "Player 1"
	parent_window.position = Vector2.ZERO
	parent_window.size = Vector2(1920, 1080)
	parent_window.unresizable = false
	parent_window.transient = true
	await get_tree().create_timer(1.0).timeout
	split()
	await get_tree().create_timer(3.0).timeout
	combine()

func split() -> Window:
	if child_window:
		return child_window
	print("Splitscreen.split()")
	child_window = Window.new()
	add_child(child_window)
	child_window.show()
	child_window.title = "Player 2"
	child_window.position = parent_window.position
	child_window.size = parent_window.size
	child_window.unresizable = parent_window.unresizable
	child_window.transient = true
	child_window.world_2d = parent_window.world_2d
	child_window.world_3d = parent_window.world_3d
	return child_window

func combine():
	print("Splitscreen.combine()")
	if is_instance_valid(child_window):
		child_window.queue_free()
	child_window = null
