extends MultiMeshInstance

const offset := sqrt(3) / 3 * 1.5

const MESH := preload("res://M_Hex.obj")
const MAT := preload("res://MAT_HexBounce.tres")

var t := 0
var pause := false
var hexes := []

func _init():
	multimesh = MultiMesh.new()
	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh.color_format = MultiMesh.COLOR_FLOAT
	multimesh.custom_data_format = MultiMesh.CUSTOM_DATA_FLOAT
	multimesh.mesh = MESH
	multimesh.mesh.surface_set_material(0, MAT)

func _ready():
	populate(40, 30, null)


func color_from(hextype):
	match hextype.terrain_type:
		"Ocean":
			return Color(0.1, 0.25, 0.5)
		"Water":
			return Color(0.2, 0.45, 0.8)
		"Ice":
			return Color(0.9, 0.9, 0.92)
		"Forest":
			return Color(0.2, 0.5, 0.2)
		"Field":
			return Color(0.6, 0.7, 0.2)
		"Mountain":
			return Color(0.1, 0.1, 0.1)
		"Desert":
			return Color(0.8, 0.6, 0.2)
		"Jungle":
			return Color(0.4, 0.7, 0.2)
		"Tundra":
			return Color(0.12, 0.15, 0.15)
		"Grassland":
			return Color(0.5, 0.6, 0.2)
		_:
			push_warning("Unknown hextype: " + hextype.terrain_type)
			return Color(1.0, 0.0, 1.0)

func populate(base_x: int, base_y: int, map_data):
	multimesh.instance_count = base_x * base_y

	var width := base_x / 2.0;
	var height := (base_y - 1) * offset /1.5
	for x in range(base_x):
		for y in range(base_y):
			var index := y * base_x + x
			var tr := Transform(Basis(), Vector3(0, 0, 0))
			if y % 2 == 0:
				tr.origin = Vector3(x - width, 0, y * offset - height)
			else:
				tr.origin = Vector3(x + 0.5 - width, 0, y * offset - height)
			multimesh.set_instance_transform(index, tr)
			multimesh.set_instance_custom_data(index, Color(rand_range(0, 2 * PI), 0, 0))
			
			if map_data != null:
				multimesh.set_instance_color(index, color_from(map_data.field[index]))
			else:
				multimesh.set_instance_color(index, Color(0.2, 0.2, 0.2))

	multimesh.mesh.surface_get_material(0).set_shader_param("paused", pause)

func _on_Control_pause_toggle(paused: bool):
	pause = paused
	multimesh.mesh.surface_get_material(0).set_shader_param("paused", pause)


func _on_Control_map_recieved(map):
	populate(map.size_x, map.size_y, map)
