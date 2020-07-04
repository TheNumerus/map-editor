extends MarginContainer

onready var label_x = $VBoxContainer/HBoxContainer3/HBoxContainer2/GridContainer/SizeXLabel
onready var label_y = $VBoxContainer/HBoxContainer3/HBoxContainer2/GridContainer/SizeYLabel

signal pause_toggle(paused)
signal map_recieved(map)

var size_x = 40
var size_y = 30

func _ready():
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")

func _on_Button_toggled(button_pressed):
	emit_signal("pause_toggle", button_pressed)


func _on_ButtonGenerate_pressed():
	var error = $HTTPRequest.request("http://localhost:8000/circle?x=%.0f&y=%.0f" % [size_x, size_y])
	if error:
		push_error("Map generator timeout")
	
func _on_request_completed(result, response_code, headers, body):
	if result != $HTTPRequest.RESULT_SUCCESS:
		push_error("map gen error")
		return
	var json = JSON.parse(body.get_string_from_utf8())
	emit_signal("map_recieved", json.result)


func _on_size_x_value_changed(value):
	label_x.text = "Size X: %.0f" % [value]
	size_x = value as int


func _on_size_y_value_changed(value):
	label_y.text = "Size Y: %.0f" % [value]
	size_y = value as int
