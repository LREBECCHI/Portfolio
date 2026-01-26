class_name Player extends  CharacterBody2D

@export var speed : float = 600.0
@export var jump_velocity: float = -700.0
@export var double_jump_velocity : float = -500
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D




# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var has_double_jumped : bool = false
var animation_locked : bool = false
var direction : Vector2 =  Vector2.ZERO
var was_in_air: bool = false



func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		was_in_air = true
	else :
		has_double_jumped =  false 
		if was_in_air == true and not Input.is_anything_pressed():
		#and direction.x == 0:
			#animation_locked = false
			land()
			was_in_air = false
		#if was_in_air == true and direction.x != 0:
			#animation_locked = true
			
		

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			# Normal jump from floor
			jump()
		
		elif not has_double_jumped: 
			#Doucle jump in air
			double_jump()


	direction = Input.get_vector("left", "right", "up", "down")
	
	if direction.x != 0 and animated_sprite.animation != "Jump End":
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	move_and_slide()
	update_animation()
	update_facing_direction()
	

func update_animation():
	if not animation_locked:
		if not is_on_floor():
			animated_sprite.play("Fall")
		
		else:
			if direction.x != 0:
				animated_sprite.play("Run")
			
			else:
				animated_sprite.play("Idle")
	
			
			
func update_facing_direction():
	if direction.x > 0:
		animated_sprite.flip_h = false
		$CollisionShape2D2.position = Vector2(-5.9, -64)
		
	elif direction.x < 0:
		animated_sprite.flip_h = true
		$CollisionShape2D2.position = Vector2(20.25, -64)
		
		

func jump():
	velocity.y = jump_velocity
	animated_sprite.play("Jump Start")
	animation_locked = true

func double_jump():
	velocity.y = double_jump_velocity
	animated_sprite.play("Jump Double")
	animation_locked = true
	has_double_jumped =  true

func land():
	animated_sprite.play("Jump End")
	animation_locked = true


func _on_animated_sprite_2d_animation_finished():
	if (["Jump End", "Jump Start", "Jump Double"].has(animated_sprite.animation)):
		animation_locked = false



func save_game():
	print (self.global_position)
