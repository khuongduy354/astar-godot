extends Node2D

var width = 20
var height = 15
var cell_size = 32

var starter = Vector2(1,1) 
var finisher = Vector2(8,8)

var is_running = false

func reset(): 
	is_running = false
	update_gui() 

func _ready(): 
	for i in range(width): 
		for j in range(height): 
			var cell = preload("res://Board/Cell.tscn").instantiate()
			$cells.add_child(cell)
			cell.idx = Vector2(i,j) 
			cell.global_position = Vector2(i,j) * cell_size + position
			cell.gui_input.connect(on_cell_input.bind(cell))
	update_gui()
	
func update_gui(): 
	for cell in $cells.get_children(): 
		cell.modulate = Color.WHITE
		if cell.idx == starter: 
			cell.modulate = Color.BLUE
		if cell.idx == finisher: 
			cell.modulate = Color.RED

func on_cell_input(event, cell): 
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if is_running: 
					return 
				match $NodeSelector.selected: 
					0: 
						starter = cell.idx 
					1: 
						finisher = cell.idx
				update_gui() 
			else:
				pass


func _on_find_path_pressed():
	if is_running: 
		return 
		
	var astar = initAStar()
	astar.find_path(Point.new(starter.x,starter.y), Point.new(finisher.x,finisher.y))
	if astar.paths: 
		var paths = astar.paths
		paths.pop_back()
		paths.pop_front()
		for path in paths: 
			var coor = path.to_vec()
			find_cell_with_coor(coor).modulate = Color.GREEN
			$pathtimer.start()
			await $pathtimer.timeout
	
func find_cell_with_coor(v: Vector2): 
	for cell in $cells.get_children(): 
		if cell.idx == v: 
			return cell
	return null

func print2d(b): 
	for i in range(b.size()): 
		print(b[i])

func create_2d_array_with_border(h,w):
	var array = []
	# Create an empty 2D array filled with ' '
	for i in range(h):
		var row = []
		for j in range(w):
			row.append(' ')
		array.append(row)
	
	# Fill the border with '0's
	for i in range(h):
		for j in range(w):
			if i == 0 or i == h - 1 or j == 0 or j == w - 1:
				array[i][j] = '0'
				
	return array


func _on_find_path_2_pressed():
	reset()

func initAStar(): 
	var b = create_2d_array_with_border(width, height)
	b[starter.x][starter.y] = "A"
	b[finisher.x][finisher.y] = "A"
	
	# path finding 
	var astar = AStar.new(b)
	return astar 

func _on_scan_pressed():
	if is_running: 
		return 
	var astar = initAStar()
	astar.find_path(Point.new(starter.x,starter.y), Point.new(finisher.x,finisher.y))
	var scans = astar.scans
	scans.pop_back() 
	for p in scans: 
		var cell = find_cell_with_coor(p.to_vec())
		if cell: 
			cell.modulate = Color.PURPLE
			$pathtimer.start()
			await $pathtimer.timeout
	
