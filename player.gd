extends StairsCharacter

var speed = 105 #* 0.2
const ACCEL_DEFAULT = 7
const ACCEL_AIR = 1
onready var accel = ACCEL_DEFAULT
var gravity = 9.8 * 5.0
var jump = 5 * 3.0

var cam_accel = 40
var mouse_sense = 0.4

var direction = Vector3()
var gravity_vec = Vector3()
var movement = Vector3()

onready var head = $"%Head"
onready var neck = $"%Neck"
onready var camera = $"%Camera"

func _ready():
	#hides the cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	#get mouse input for camera rotation
	if event is InputEventMouseMotion:
		neck.rotate_object_local(Vector3.UP,deg2rad(-event.relative.x * mouse_sense))
		head.rotate_object_local(Vector3.RIGHT,deg2rad(-event.relative.y * mouse_sense))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))

func _process(delta):
	#camera physics interpolation to reduce physics jitter on high refresh-rate monitors
#	if Engine.get_frames_per_second() > Engine.iterations_per_second:
		camera.set_as_toplevel(true)
		camera.global_transform.origin = camera.global_transform.origin.linear_interpolate(head.global_transform.origin, cam_accel * delta)
		camera.rotation.y = neck.rotation.y
		camera.rotation.x = head.rotation.x
#	else:
#		camera.set_as_toplevel(false)
#		camera.global_transform = head.global_transform
		
func _physics_process(delta):
	#get keyboard input
	direction = Vector3.ZERO
	var h_rot = neck.global_transform.basis.get_euler().y
	var f_input = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	var h_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction = Vector3(h_input, 0, f_input).rotated(Vector3.UP, h_rot).normalized()
	
	#jumping and gravity
	if is_on_floor():
		snap = -get_floor_normal()
		accel = ACCEL_DEFAULT
		gravity_vec = Vector3.ZERO
	else:
		snap = Vector3.DOWN
#		accel = ACCEL_AIR
		gravity_vec += Vector3.DOWN * gravity * delta
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		snap = Vector3.ZERO
		gravity_vec = Vector3.UP * jump
	
	#make it move
	desired_velocity = desired_velocity.linear_interpolate(direction * speed, accel * delta)
	desired_velocity.y += gravity_vec.y
#	move_and_slide(desired_velocity,Vector3.UP)
	move_and_stair_step()
