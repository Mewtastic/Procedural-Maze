extends KinematicBody

const VISIBLE = 0
const CAPTURED = 1

signal green

export var light_growth = .5

var speed = 4  # movement speed
var spin = 0.1  # rotation speed
var moveCam = false
var mouse_mode = VISIBLE
var walk = false
var off = false
var overheating = false

var velocity = Vector3()

onready var anim = $AnimationPlayer
var still = true
onready var flashlight = $Flashlight/LightHolder/SpotLight
onready var timer = $Timer

func get_input():
	velocity = Vector3()
	speed = 4
	moveCam = false
	walk = false
	if Input.is_action_pressed("mark") and not overheating:
		flashlight.light_energy += light_growth
		flashlight.light_color = "20ff00"
		if flashlight.light_energy > 30:
			flashlight.light_energy = 30
			emit_signal("green")
			overheating = true
			timer.start(30)
	elif flashlight.light_energy > 1:
		flashlight.light_energy += -light_growth
		flashlight.light_color = "ffffff"
		if flashlight.light_energy < 1:
			flashlight.light_energy = 1
	if Input.is_action_pressed("ui_up"):
		velocity += -transform.basis.z * speed
		walk = true
	if Input.is_action_pressed("ui_down"):
		velocity += transform.basis.z * speed
		walk = true
	if Input.is_action_pressed("ui_right"):
		velocity += transform.basis.x * speed
		walk = true
	if Input.is_action_pressed("ui_left"):
		velocity += -transform.basis.x * speed
		walk = true
	if Input.is_action_just_pressed("on & off"):
		if off:
			flashlight.light_energy = 1
			flashlight.light_color = "ffffff"
			off = false
		else:
			flashlight.light_energy = 0
			off = true
	if Input.is_action_pressed("Movebutton"):
		moveCam = true
		if mouse_mode == VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			mouse_mode = CAPTURED
	elif mouse_mode != VISIBLE:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		mouse_mode = VISIBLE
	if walk and still:
		anim.play("walk")
		still = false
	elif not walk and not still:
		anim.play("idle")
		still = true
	if off:
		flashlight.light_energy = 0

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity, Vector3.UP)
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		if moveCam:
			if event.relative.x > 0:
				rotate_y(-lerp(0, spin, event.relative.x/20))
			elif event.relative.x < 0:
				rotate_y(-lerp(0, spin, event.relative.x/20))

func _on_RequestHandler_maze_complete():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	queue_free()

func _on_Tutorial_maze_complete():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	queue_free()

func _on_Timer_timeout():
	overheating = false
