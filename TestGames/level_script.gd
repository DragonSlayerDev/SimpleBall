extends Node3D

#setting number of holes for the level to be checked against holes filled later
@export var num_holes := 0

#used to choose next level from inspector
@export_file("*.tscn") var file_path

#importing level_objects to be used in movement and time for ending level
@onready var level_objects: Node3D = $LevelObjects
@onready var level_end_time: Timer = $LevelEndTime
#importing animations for closing their corresponding holes
@onready var closing_floor_1_anim: AnimationPlayer = %ClosingFloor1Anim
@onready var closing_floor_2_anim: AnimationPlayer = %ClosingFloor2Anim

#going to be used for UI
var is_transitioning: bool = false
#setting number of holes currently filled to zero
var num_holes_filled := 0

#Handles movement process, I use rotatIon_degrees because the rotate function
#allows for weird angles but if the player directly affects the rotation_degrees
#it remains in a stricter rotation
func _process(delta: float) -> void:
	if Input.is_action_pressed("rotate_up"):
		level_objects.rotation_degrees.x -=  (25.0 * delta)
	if Input.is_action_pressed("rotate_down"):
		level_objects.rotation_degrees.x += (25.0 * delta)
	if Input.is_action_pressed("rotate_left"):
		level_objects.rotation_degrees.z += (25.0 * delta)
	if Input.is_action_pressed("rotate_right"):
		level_objects.rotation_degrees.z -= (25.0 * delta)
	#The clamp functions are to keep it from rotating too much
	level_objects.rotation_degrees.x = clampf( level_objects.rotation_degrees.x, -25.0, 25.0)
	level_objects.rotation_degrees.z = clampf( level_objects.rotation_degrees.z, -25.0, 25.0)

#ends level after timer timeout to allow for animation to play plus a little extra
func _on_level_end_time_timeout() -> void:
	get_tree().change_scene_to_file(file_path)

#handles if hole 1 is entered
func _on_hole_1_area_body_entered(body: Node3D) -> void:
	num_holes_filled += 1
	closing_floor_1_anim.play("closing_floor")
	#deletes ball that enters the hole so it doesn't fall indefinitely
	body.queue_free()
	if num_holes_filled == num_holes:
		level_end_time.start()

#handles if hole 2 is entered
func _on_hole_2_area_body_entered(body: Node3D) -> void:
	num_holes_filled += 1
	closing_floor_2_anim.play("closing_floor")
	#deletes ball that enters the hole so it doesn't fall indefinitely
	body.queue_free()
	if num_holes_filled == num_holes:
		level_end_time.start()
