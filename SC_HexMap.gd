extends MultiMeshInstance

const offset = sqrt(3) / 3 * 1.5

const mesh = preload("res://M_Hex.obj")
const mat = preload("res://MAT_HexBounce.tres")

var t = 0
var pause = false
var hexes = []

func _ready():
	populate(40, 30, null)


func color_from(hextype):
	match hextype.terrain_type:
		"Ocean":
			return Color(0.1, 0.2, 0.5)
		"Ice":
			return Color(0.9, 0.9, 0.92)
		"Water":
			return Color.blue
		"Forest":
			return Color.darkgreen
		"Field":
			return Color.green
		"Mountain":
			return Color.darkgray
		"Desert":
			return Color.orange
		"Jungle":
			return Color.limegreen
		_:
			push_warning("Unknown hextype: " + hextype.terrain_type)
			return Color(1.0, 0.0, 1.0)

func populate(base_x: int, base_y: int, map_data):
	multimesh = MultiMesh.new()
	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh.color_format = MultiMesh.COLOR_FLOAT
	multimesh.custom_data_format = MultiMesh.CUSTOM_DATA_FLOAT
	multimesh.instance_count = base_x * base_y
	multimesh.mesh = mesh
	multimesh.mesh.surface_set_material(0, mat)

	var width = base_x / 2;
	var height = (base_y - 1) * offset /1.5
	for x in range(base_x):
		for y in range(base_y):
			var index = y * base_x + x
			var tr = Transform(Basis(), Vector3(0, 0, 0))
			if y % 2 == 0:
				tr.origin = Vector3(x - width, 0, y * offset - height)
			else:
				tr.origin = Vector3(x + 0.5 - width, 0, y * offset - height)
			multimesh.set_instance_transform(index, tr)
			multimesh.set_instance_custom_data(index, Color(rand_range(0, 2 * PI), 0, 0))
			
			if map_data != null:
				multimesh.set_instance_color(index, color_from(map_data.field[index]))
			else:
				multimesh.set_instance_color(index, Color(0.2, 0.2, 0.6))

	multimesh.mesh.surface_get_material(0).set_shader_param("paused", false)

func _on_Control_pause_toggle(paused):
	pause = paused
	multimesh.mesh.surface_get_material(0).set_shader_param("paused", pause)


func _on_Control_map_recieved(map):
	populate(map.size_x, map.size_y, map)
