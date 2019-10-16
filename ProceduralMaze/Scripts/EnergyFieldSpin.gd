extends MeshInstance

export var energyspin = .3

export var spin = .5 #The main value of spin, 
					 #without getting it from the parent to optimize code
					 #Changed at the same rate by the animation node

func _process(delta):
	rotate_y(lerp(0, energyspin + spin, .1))
	rotate_x(lerp(0, energyspin + spin, .1))
	rotate_z(lerp(0, energyspin + spin, .1))