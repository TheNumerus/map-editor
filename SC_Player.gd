extends Spatial

onready var camera = $Pivot/Camera as Camera

const camera_speed = 0.03

var pressed = false
var right_pressed = false
var zoom_level = 0

var rot = 0

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
			var pan_vector = Vector2(-motion_event.relative.x * camera_speed, -motion_event.relative.y * camera_speed)
			var t = Transform2D((rot / 180.0 * PI), Vector2(0, 0))
			pan_vector = t.basis_xform_inv(pan_vector)
			translate((Vector3(pan_vector.x, 0, pan_vector.y)))
		elif right_pressed:
			var rotate_delta_y = -motion_event.relative.y / 5
			$Pivot.rotation_degrees.x = clamp($Pivot.rotation_degrees.x + rotate_delta_y, 0, 85)
			var rotate_delta_x = -motion_event.relative.x / 5
			rot = $Pivot.rotation_degrees.y + rotate_delta_x
			$Pivot.rotation_degrees.y = rot
