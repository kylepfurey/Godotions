extends Node
# Binds device ID's to players.
 
var bindings := {}
# Each bound device ID.

func bind(device_id, player) -> bool:
	# Binds a new device ID.
	if device_id in bindings:
		return false
	print("DeviceBinder.bind(" + str(device_id) + ")")
	bindings[device_id] = player
	return true

func unbind(device_id):
	# Releases a bound device ID.
	print("DeviceBinder.unbind(" + str(device_id) + ")")
	if device_id != null:
		bindings.erase(device_id)

func lock_mouse():
	# Locks the mouse.
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		return
	print("DeviceBinder.lock_mouse()")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func unlock_mouse():
	# Unlocks the mouse.
	if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		return
	print("DeviceBinder.unlock_mouse()")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
