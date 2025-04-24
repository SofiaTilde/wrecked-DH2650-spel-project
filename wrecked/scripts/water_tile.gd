@tool
extends MeshInstance3D

@export var tile_size: float = 32.0:              # ← colon
	set(value):
		tile_size = value        # safe; inside the setter this bypasses itself
		_update_mesh()

@export_range(1, 512, 1)
var subdivs: int = 64:                           # ← colon
	set(value):
		subdivs = value
		_update_mesh()

func _ready():
	_update_mesh()

func _update_mesh():
	var p := PlaneMesh.new()
	p.size            = Vector2(tile_size, tile_size)
	p.subdivide_width = subdivs
	p.subdivide_depth = subdivs
	mesh = p
