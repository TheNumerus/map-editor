extends MarginContainer

onready var label_x = $VBoxContainer/GridContainer/SizeXLabel
onready var label_y = $VBoxContainer/GridContainer/SizeYLabel

signal pause_toggle(paused)
signal map_recieved(map)

var size_x: int = 40
var size_y: int = 30

func _ready():
	if $HTTPRequest.connect("request_completed", self, "_on_request_completed"):
		push_error("cannot connect to http request node")

func _on_Button_toggled(button_pressed):
	emit_signal("pause_toggle", button_pressed)

func _on_request_completed(result, _response_code, _headers, body):
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

func send_request(path):
	var error = $HTTPRequest.request("http://localhost:8000/" + path)
	if error:
		push_error("Map generator timeout")
	
func _on_ButtonGenerate_pressed():
	send_request("circle?x=%.0f&y=%.0f" % [size_x, size_y])

func _on_ButtonGenerateIsland_pressed():
	send_request("islands?x=%.0f&y=%.0f" % [size_x, size_y])

func _on_ButtonGenerateInland_pressed():
	send_request("inland?x=%.0f&y=%.0f" % [size_x, size_y])
