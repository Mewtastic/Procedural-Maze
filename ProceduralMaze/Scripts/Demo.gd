extends Spatial

# Handle marking mechanic, here instead of in request handler because you need player and energymarker to be child nodes #
onready var mark = $EnergyMarker
onready var player = $Player
# Timer stuff
onready var finMenu = $GameFin
var play_time = 0
##########################################################################################################################

const N = 1
const E = 2
const S = 4
const W = 8

var cell_walls = {Vector3(0,0,-1): N, Vector3(1,0,0): E,
				  Vector3(0,0,1): S, Vector3(-1,0,0): W}

export var width = 12 # width of map in cells
export var depth = 12 # depth of map in cells

const OFFSET = 6 # Width/Depth / 2

onready var map = $GridMap

func _ready():
	$world.environment.fog_enabled = true
	randomize()
	make_maze()

func make_maze():
	var unvisited = []
	var stack = []
	map.clear()
	for x in range(width):
		for z in range(depth):
			unvisited.append(Vector3(x - OFFSET, 0, z - OFFSET))
			map.set_cell_item(x -OFFSET, 0, z -OFFSET, 14) # 14 is just the number that worked...
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
		elif stack:
			current = stack.pop_back() #Backtrack if no neighbors

func check_neighbors(cell, unvisited):
	var list = []
	for n in cell_walls.keys():
		if cell + n in unvisited:
			list.append(cell + n)
	return list

func _process(delta):
	play_time += delta

func _on_Player_green():
	mark.translation = player.translation
	mark.rotation_degrees = player.rotation_degrees
	mark.visible = true

func _on_RequestHandler_maze_complete():
	var total_play_time = play_time
	$world.environment.fog_enabled = false
	$Camera/SpotLight.visible = true
	finMenu.initialize(total_play_time)
