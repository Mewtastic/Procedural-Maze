extends Area
# StarCube animations code.
export var rise = .03
export var spin = -.5
var collected = false

export var particles_position = Vector3(0, 7, 0)

func _ready():
	$AnimationPlayer/Particles.translation = particles_position

func _process(delta):
	rotate_y(lerp(0, spin, .1))
	rotate_x(lerp(0, spin, .1))
	rotate_z(lerp(0, spin, .1))

func _physics_process(delta):
		if collected:
			global_translate(Vector3(0, rise, 0))

func _on_Collect_body_entered(body):
	collected = true
	$PickupSnd.playing = true
	$AnimationPlayer.play("Collect")
	$CollisionShape.disabled = true

func _on_AnimationPlayer_animation_finished(anim_name):
	collected = false
	$MeshInstance.visible = false
	$AnimationPlayer/Particles.emitting = true
	$Timer.start()

func _on_Timer_timeout():
	queue_free()
