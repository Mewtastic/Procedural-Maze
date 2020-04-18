extends Spatial

const N = 1
const E = 2
const S = 4
const W = 8

var cell_walls = {Vector3(0,0,-1): N, Vector3(1,0,0): E,
				  Vector3(0,0,1): S, Vector3(-1,0,0): W}

export var width = 24 # width of map in cells
export var depth = 24 # depth of map in cells
# Total tiles is 576 (The more you know)

const OFFSET = 12 # Width/Depth / 2

onready var map = $GridMap

func _ready():
	randomize()
	make_maze()

func make_maze():
	var unvisited = []
	var stack = []
	map.clear()
	for x in range(width):
		for z in range(depth):
			unvisited.append(Vector3(x - OFFSET, 0, z - OFFSET))
			map.set_cell_item(x - OFFSET, 0, z - OFFSET, 14)
	var current = Vector3(-OFFSET, 0, -OFFSET)
	unvisited.erase(current)
	while unvisited: # No more need for OFFSET, it's already adjusted for
		var neighbors = check_neighbors(Vector3(current.x, 0, current.z), unvisited)
		if neighbors.size() > 0:
			var next = neighbors[randi() % neighbors.size()]
			# Get current tile before moving to next tile so you can backtrack
			stack.append(current)
			var dir = next - current
			var current_walls = map.get_cell_item(current.x, 0, current.z) - cell_walls[dir]
			var next_walls = map.get_cell_item(next.x, 0, next.z) - cell_walls[-dir]
			map.set_cell_item(current.x, 0, current.z, current_walls)
			map.set_cell_item(next.x, 0, next.z, next_walls)
			current = next
			unvisited.erase(current)
		else:
			current = stack.pop_back() # Backtrack if no neighbors
			
		# Slow algorithm down for Debug and a really cool demonstration of the algorithm
		yield(get_tree(), 'idle_frame')
	$TitleScreen/CenterContainer/VBoxContainer/Maze_Status.text = "Finished Maze"

func check_neighbors(cell, unvisited):
	var list = []
	for n in cell_walls.keys():
		if cell + n in unvisited:
			list.append(cell + n)
	return list
