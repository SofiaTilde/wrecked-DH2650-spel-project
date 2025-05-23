@tool # visible in editor
extends Node3D

@export var tile_scene: PackedScene
@export var tile_size: float = 32.0 # must match WaterTile
@export var tiles_per_axis: int = 8

@export var water_material: ShaderMaterial

func _process(_delta: float) -> void:
	water_material.set_shader_parameter(
		"time",
		Time.get_ticks_msec() / 1000.0 # same clock as TIME, and same as in platforms
		)

func _ready():
	_spawn_grid()

func _spawn_grid():
	var max_tiles = tiles_per_axis
	for x in range(-max_tiles, max_tiles + 1):
		for z in range(-max_tiles - int(256.0 / tile_size), max_tiles + 1):
			var pos3 = Vector3(x * tile_size, 0.0, z * tile_size)
			var d_tiles = tiles_per_axis - max(abs(x), abs(z))

			var wanted_subdivs = clamp(pow(2, d_tiles), 4, 32)
			
			# if x == 0:
			# 	wanted_subdivs = min(wanted_subdivs, 16)
				
			# 	if z == -9: # Island tile
			#		wanted_subdivs = 32
			
			# print("Tile at: (%s, %s) has sub-divs: %d" % [x, z, wanted_subdivs])

			var tile = tile_scene.instantiate()
			tile.position = pos3 * 0.90 # 10% overlap to make sure there are no gaps
			
			var mesh_i := tile.get_node("MeshInstance3D") as MeshInstance3D
			mesh_i.subdivs = wanted_subdivs
			
			add_child(tile)
