extends Node
# Binds device ID's to players.
 
var bindings := {}
# Each bound device ID.

func bind(device_id, player) -> bool:
	# Binds a new device ID.
	if device_id in bindings:
		return false
	bindings[device_id] = player
	return true

func unbind(device_id):
	# Releases a bound device ID.
	if device_id != null:
		bindings.erase(device_id)

func lock_mouse():
	# Locks the mouse.
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func unlock_mouse():
	# Unlocks the mouse.
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
