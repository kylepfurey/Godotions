extends Node3D
# Controls player looking and shooting input.

@onready var camera = $Camera3D
# Camera reference.
@export var mouse_sens_x = 0.001
# Mouse X sensitivity.
@export var mouse_sens_y = 0.001
# Mouse Y sensitivity.
@export var stick_sens_x = 1.0
# Stick X sensitivity.
@export var stick_sens_y = 1.0
# Stick Y sensitivity.
@export var deadzone = 0.05
# Input deadzone.
@export var reload_time = 1.0
# Time to reload in seconds.
@export var shoot_distance = 100.0

signal on_shoot(current_ammo)
# Called when shoot() is called with the current number of ammo.
signal on_hit(hit_collider, shooting_player)
# Called when shoot() is called and hits something with the hit collider and player.
signal start_reload(current_ammo)
# Called when reload() is called with the current number of ammo.
signal stop_reload()
# Called when reload() is completed.

var device_id = null
# This player's device ID.
var pitch := 0.0
# This player's pitch rotation.
var max_ammo = 6
# This player's maximum ammo.
var ammo = max_ammo
# This player's current ammo.
var reloading = false
# Is the player reloading.

func is_me(device_id) -> bool:
	# Returns whether this device is ours.
	return device_id == -1 || self.device_id == device_id

func look(x, y):
	# Causes the camera to look in a direction.
	print(str(device_id) + ".look(" + str(x) + ", " + str(y) + ")")
	self.rotation.y -= x
	pitch -= y
	pitch = clamp(pitch, deg_to_rad(-80), deg_to_rad(80))
	camera.rotation.x = pitch

func shoot():
	# Fires the six shooter.
	print(str(device_id) + ".shoot(" + str(ammo) + ")")
	on_shoot.emit(ammo)
	if ammo > 0:
		ammo -= 1
		var from = camera.global_transform.origin
		var to = from + camera.global_transform.basis.z * -shoot_distance
		var physics = get_world_3d().direct_space_state
		var result = physics.intersect_ray(PhysicsRayQueryParameters3D.create(from, to, 4294967295, [self]))
		print(str(from) + " -> " + str(to))
		if result:
			var collider = result.collider
			if collider:
				print(str(device_id) + ".on_hit(" + collider.name + ")")
				on_hit.emit(collider, self)
				if collider.has_method("on_hit"):
					collider.on_hit(self)
	else:
		# NO AMMO
		pass

func reload():
	# Reloads the six shooter.
	print(str(device_id) + ".reload()")
	if reloading:
		return
	if ammo < max_ammo:
		print(str(device_id) + ".start_reload()")
		start_reload.emit(ammo)
		reloading = true
		await get_tree().create_timer(reload_time).timeout
		print(str(device_id) + ".stop_reload()")
		ammo = max_ammo
		stop_reload.emit()
		reloading = false

func _input(event):
	# Handles mouse, shooting, and reloading input events.
	if DeviceBinder.bind(event.device, self):
		device_id = event.device
	if not is_me(event.device):
		return
	if event is InputEventMouseMotion:
		var mouse_x = event.relative.x * mouse_sens_x
		var mouse_y = event.relative.y * mouse_sens_y
		look(mouse_x, mouse_y)
	if event.is_action_pressed("shoot"):
		shoot()
	if event.is_action_pressed("reload"):
		reload()
	if event.is_action_pressed("lock_mouse"):
		DeviceBinder.lock_mouse()
	if event.is_action_pressed("unlock_mouse"):
		DeviceBinder.unlock_mouse()
	if event.is_action_pressed("quit"):
		await get_tree().create_timer(1.0).timeout
		if Input.is_action_pressed("quit"):
			get_tree().quit()

func _process(delta):
	# Handles right stick input events.
	if device_id == null:
		return
	var stick_x = Input.get_action_strength("look_right", device_id) - Input.get_action_strength("look_left", device_id)
	var stick_y = Input.get_action_strength("look_down", device_id) - Input.get_action_strength("look_up", device_id)
	if abs(stick_x) < deadzone:
		stick_x = 0.0

	if abs(stick_y) < deadzone:
		stick_y = 0.0
	if stick_x != 0 or stick_y != 0:
		look(
			stick_x * stick_sens_x * delta,
			stick_y * stick_sens_y * delta
		)

func _exit_tree():
	# Unbinds player input.
	if device_id != null:
		DeviceBinder.unbind(device_id)
