extends Node
class_name Point


var x: int
var y: int
var parent: Point = null

func _init(_x,_y):
	x = _x 
	y = _y 

func add(b:Point): 
	return Point.new(x+b.x,y+b.y)
func eq(b:Point): 
	return x == b.x and y ==b.y
func _to_string(): 
	return "("+str(x)+","+str(y)+")"
func to_vec(): 
	return Vector2(x,y)
