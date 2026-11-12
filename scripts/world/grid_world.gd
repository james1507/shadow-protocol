class_name GridWorld
extends Node2D

var grid_size := Vector2i(40, 24)
var solid_cells: Dictionary = {}
var door_cells: Dictionary = {}
var path_grid := AStarGrid2D.new()
var walls: TileMapLayer
var definition: Dictionary

func center(cell: Vector2i) -> Vector2:
	return Vector2(cell * 32) + Vector2(16, 16)

func build(data: Dictionary) -> void:
	definition = data
	grid_size = Vector2i(int(data.size[0]), int(data.size[1]))
	var image := Image.create(64, 32, false, Image.FORMAT_RGBA8)
	for x in range(64):
		for y in range(32):
			var color := Color("162635") if x < 32 else Color("243444")
			if y == 0 or x % 32 == 0:
				color = Color("1c3040") if x < 32 else Color("3c5365")
			if x >= 32 and y >= 27:
				color = Color("101d29")
			image.set_pixel(x, y, color)
	for index in range(2):
		var texture := AssetLibrary.texture("floor_tile" if index == 0 else "wall_tile")
		if texture != null:
			var pixels := texture.get_image()
			pixels.resize(32, 32, Image.INTERPOLATE_NEAREST)
			image.blit_rect(pixels, Rect2i(0,0,32,32), Vector2i(index * 32, 0))
	var atlas := TileSetAtlasSource.new()
	atlas.texture = ImageTexture.create_from_image(image)
	atlas.texture_region_size = Vector2i(32, 32)
	atlas.create_tile(Vector2i(0, 0))
	atlas.create_tile(Vector2i(1, 0))
	var tiles := TileSet.new()
	tiles.tile_size = Vector2i(32, 32)
	tiles.add_physics_layer()
	tiles.set_physics_layer_collision_layer(0, 1)
	tiles.set_physics_layer_collision_mask(0, 0)
	tiles.add_source(atlas, 0)
	var wall_data := atlas.get_tile_data(Vector2i(1, 0), 0)
	wall_data.set_collision_polygons_count(0, 1)
	wall_data.set_collision_polygon_points(0, 0, PackedVector2Array([Vector2(-16,-16), Vector2(16,-16), Vector2(16,16), Vector2(-16,16)]))
	var ground := TileMapLayer.new()
	ground.name = "Ground"
	ground.tile_set = tiles
	add_child(ground)
	walls = TileMapLayer.new()
	walls.name = "Walls"
	walls.tile_set = tiles
	add_child(walls)
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			var cell := Vector2i(x, y)
			ground.set_cell(cell, 0, Vector2i(0, 0))
			if x == 0 or y == 0 or x == grid_size.x - 1 or y == grid_size.y - 1:
				solid_cells[cell] = true
	for segment in data.walls:
		for x in range(segment[0], segment[2] + 1):
			for y in range(segment[1], segment[3] + 1):
				solid_cells[Vector2i(x, y)] = true
	for cell_data in data.cover:
		solid_cells[Vector2i(cell_data[0], cell_data[1])] = true
	for cell in solid_cells:
		walls.set_cell(cell, 0, Vector2i(1, 0))
	path_grid.region = Rect2i(Vector2i.ZERO, grid_size)
	path_grid.cell_size = Vector2(32, 32)
	path_grid.offset = Vector2(16, 16)
	path_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	path_grid.update()
	for cell in solid_cells:
		path_grid.set_point_solid(cell)
	queue_redraw()

func set_door(at: Vector2, closed: bool) -> void:
	var cell := Vector2i(at / 32)
	door_cells[cell] = closed
	path_grid.set_point_solid(cell, closed)
	# The authored doorway is two cells high, matching the actual 32x64 collider.
	door_cells[cell + Vector2i.DOWN] = closed
	path_grid.set_point_solid(cell + Vector2i.DOWN, closed)

func path(from: Vector2, to: Vector2) -> PackedVector2Array:
	var start := Vector2i(from / 32)
	var end := Vector2i(to / 32)
	if not path_grid.is_in_boundsv(start) or not path_grid.is_in_boundsv(end):
		return PackedVector2Array()
	if path_grid.is_point_solid(start) or path_grid.is_point_solid(end):
		return PackedVector2Array()
	return path_grid.get_point_path(start, end)

func _draw() -> void:
	for zone in definition.zones:
		var at := center(Vector2i(zone[1], zone[2]))
		draw_string(ThemeDB.fallback_font, at, zone[0], HORIZONTAL_ALIGNMENT_LEFT, -1, 13, Color("527080"))
		draw_line(at + Vector2(0, 8), at + Vector2(105, 8), Color("284756"), 2)
	for c in definition.cover:
		var at := center(Vector2i(c[0], c[1]))
		draw_rect(Rect2(at - Vector2(12, 12), Vector2(24, 24)), Color("3b4b50"))
		draw_rect(Rect2(at - Vector2(9, 9), Vector2(18, 18)), Color("75806c"), false, 1)
		draw_line(at - Vector2(9, 9), at + Vector2(9, 9), Color("75806c"))
