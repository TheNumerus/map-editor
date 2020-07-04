extends Spatial

onready var camera = $Pivot/Camera as Camera

const camera_speed = 0.03

var pressed = false
var right_pressed = false
var zoom_level = 0

func _unhandled_input(event):
	if event is InputEventMouseButton:
		var button_event = (event as InputEventMouseButton)
		match button_event.button_index:
			BUTTON_LEFT:
				pressed = button_event.pressed
			BUTTON_WHEEL_DOWN:
				if button_event.pressed and zoom_level > -30:
					camera.translate_object_local(Vector3(0, 0, 1))
					zoom_level -= 1
			BUTTON_WHEEL_UP:
				if button_event.pressed and zoom_level < 11:
					camera.translate_object_local(Vector3(0, 0, -1))
					zoom_level += 1
			BUTTON_RIGHT:
				right_pressed = button_event.pressed
	
	elif event is InputEventMouseMotion:
		var motion_event = (event as InputEventMouseMotion)
		if pressed:
			translate((Vector3(-motion_event.relative.x * camera_speed, 0, -motion_event.relative.y * camera_speed)))
		elif right_pressed:
			var rotate_delta = -motion_event.relative.y / 5
			$Pivot.rotation_degrees.x = clamp($Pivot.rotation_degrees.x + rotate_delta, 0, 85)
