extends Area2D
signal hit

@export var speed = 400 	# Pixels per second
var screen_size 			# Game window

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Detect player movement input
	var velocity = Vector2.ZERO # The player's movement vector
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	# Move the player
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
		handle_player_animation_transform(velocity)
	else:
		$AnimatedSprite2D.stop()
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

	pass
	
## Game start
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	
## Sets the proper animation and transform for player animation
func handle_player_animation_transform(velocity):
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0
	pass

## When the player hits an enemy
func _on_body_entered(body):
	hide()
	hit.emit()
	
	# Physics properties can't be altered inside a physics callback. Here we are deferring the 
	# disabled attribute to prevent multiple hits from proccing off one collision.
	$CollisionShape2D.set_deferred("disabled", true)
	pass # Replace with function body.
