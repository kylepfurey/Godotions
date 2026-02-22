extends Control

var p1_controller = null
var p2_controller = null

@onready var p1_text := $Player1Bg/Player1JoinText
@onready var p2_text := $Player2Bg/Player2JoinText

@onready var animation_player := $AnimationPlayer
signal players_joined(p1_controller, p2_controller)

func _ready() -> void:
	animation_player.play("pull_up_animation")

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton:
		var device := event.device
		print("COOL")
		if p1_controller == null:
			p1_controller = device
			PointManager.p1_controller = p1_controller
			p1_text.text = "[wave amp=30 freq=7]WELCOME\n PLAYER\n 1[/wave]"
			
		if p2_controller == null and device != p1_controller:
			p2_controller = device
			PointManager.p2_controller = p2_controller
			#p2_text.scale = 2
			p2_text.text = "WELCOME\n PLAYER\n 2"
			emit_signal("players_joined",p1_controller,p2_controller)


	
func show_join_text():
	if p1_controller == null:
		p1_text.text = "[wave amp=60 freq=3]PRESS ANY\n BUTTON TO JOIN[/wave]"
	if p2_controller == null:
		p2_text.text = "[wave amp=60 freq=3]PRESS ANY\n BUTTON TO JOIN[/wave]"
		
func _process(delta: float) -> void:
	show_join_text()
