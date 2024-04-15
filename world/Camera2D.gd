extends Camera2D



@export var _amplitude = 10
@export var _duration = 0.1
var _shake = 0
var _timer = Timer.new()
var _direction: Vector2 = Vector2.ZERO
var _velocity: Vector2 = Vector2.ZERO

var myrect = Rect2(0, 0, 0, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	_timer.connect("timeout", _on_Timer_timeout)
	_timer.one_shot = true
	add_child(_timer)
	call_deferred("update_camera_zoom_pos", 0.5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	shake_camera()
	
func iso_to_screen(iso):
	var screen_x = (iso.x - iso.y) * GameData.TILE_WIDTH / 2
	var screen_y = (iso.x + iso.y) * GameData.TILE_HEIGHT / 2
	return Vector2(screen_x, screen_y)
	
func update_camera_zoom_pos(pad=0.5):
	var cell_size = Vector2(GameData.TILE_WIDTH, GameData.TILE_HEIGHT)
	var tilemap_box = get_bounding_box(get_parent().tilemap)
	print(tilemap_box)
	var screen_size = get_viewport_rect().size
	
	var zoom_x = screen_size.x / tilemap_box.size.x
	var zoom_y = screen_size.y / tilemap_box.size.y
	var zoom_min = min(zoom_x, zoom_y)
	var new_zoom = Vector2(zoom_min, zoom_min) * pad  # 0.95 for slight padding

	var tween = get_tree().create_tween()
	tween.parallel().tween_property(self, "zoom", new_zoom, 0.3).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property(self, "position", tilemap_box.position+tilemap_box.size/2, 0.4).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	
func get_bounding_box(tilemap):
	var used_cells = tilemap.get_used_cells(0)

	var min_x = INF
	var max_x = -INF
	var min_y = INF
	var max_y = -INF

	for cell in used_cells:
		var world_pos = tilemap.map_to_local(cell)
		min_x = min(min_x, world_pos.x)
		max_x = max(max_x, world_pos.x)
		min_y = min(min_y, world_pos.y)
		max_y = max(max_y, world_pos.y)

	var width = max_x - min_x + GameData.TILE_WIDTH
	var height = max_y - min_y + GameData.TILE_HEIGHT
	return Rect2(min_x-GameData.TILE_WIDTH/2, min_y-GameData.TILE_HEIGHT/2, width, height)


func shake_camera():
	offset = _shake * Vector2(randf_range(-1, 1), randf_range(-1, 1))
		
		
func camera_shake():
	_shake = _amplitude
	if !_timer.is_stopped():
		_timer.wait_time += _duration
	else:
		_timer.wait_time = _duration
		_timer.start()
		
func _on_Timer_timeout():
	_shake = 0
