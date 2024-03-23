extends RefCounted 
class_name AStar 


#// Board representation: 2D array of char
#// '\0' is obstacle
#// ' ' is empty
#// 'A' is letter

var cost_tracker = {}
var evaluated = []
var board = null

var scans = []
var paths = []

func _init(b):
	board = b


func cal_cost(curr: Point, start: Point, end: Point)->float:
	# manhattan distance
	var g = sqrt(pow(curr.x - start.x,2) + pow(curr.y - start.y,2))
	var h = sqrt(pow(curr.x - end.x,2) + pow(curr.y - end.y,2))
  
	var f = h
	
	# turning costs
	if (curr.parent == null or curr.parent.parent == null):
		return f

	var furthest = curr.parent.parent
	var middle = curr.parent

	var on_same_x_axis = furthest.x == middle.x and middle.x == curr.x
	var on_same_y_axis = furthest.y == middle.y and middle.y == curr.y
	if (on_same_x_axis or on_same_y_axis):
		return f
	else:
		return f + 1000
	return f 

func trace_path(target: Point):
	if (target == null):
		return null
	
	paths = []
	var curr = target
	paths.push_front(curr)  

	while (curr.parent != null):
		curr = curr.parent
		paths.push_front(curr)

func find_path(start: Point, end: Point):
	cost_tracker = {}
	evaluated = []
	var target = start

	while (target!=null and !target.eq(end)):
		var dirs = [Point.new(0,1), Point.new(0,-1), Point.new(1,0), Point.new(-1,0)]     
		for dir in dirs: 
			var neighbor = target.add(dir)
			var n_char = board[neighbor.x][neighbor.y];
			if (n_char == "0" or (n_char != ' ' and !neighbor.eq(end))):
				continue

			neighbor.parent = target;

			var cost = cal_cost(neighbor, start, end)
			if !is_visited(neighbor):
				cost_tracker[neighbor] = cost
				evaluated.push_back(neighbor)

		target = get_lowest_cost_point()
		if target: 
			scans.push_back(target)
#		if(target):
#			print(target.x, " ", target.y)
			
	if (!target.eq(end)):
		return null
		
	trace_path(target)
	

func is_visited(p: Point):
	for val in evaluated: 
		if val.x == p.x and val.y == p.y:
			return true 
	return false
func get_lowest_cost_point(): 
	if cost_tracker.keys().size() == 0: 
		return null
	var min_point = cost_tracker.keys()[0]
	var min_cost = cost_tracker[min_point]

	for key in cost_tracker.keys(): 
		if cost_tracker[key] < min_cost: 
			min_cost = cost_tracker[key]
			min_point = key
	cost_tracker.erase(min_point)
	return min_point 
		


