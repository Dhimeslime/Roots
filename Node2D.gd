extends KinematicBody2D

var sword_ready = false
const UP = Vector2(0, -1)
const MAX_SPEED = 200
const ACCELERATION = 15
var motion = Vector2()

func _physics_process(delta):
	var friction = false
	if Input.is_key_pressed(OP_SHIFT_LEFT):
		sword_ready=true
	else:
		sword_ready=false
	if Input.is_action_pressed("ui_right"):
		motion.x = min(motion.x+ACCELERATION, MAX_SPEED)
		$Sprite.flip_h = false
		if is_on_floor():
			$Sprite.play("Run")
	elif Input.is_action_pressed("ui_left"):
		motion.x = max(motion.x-ACCELERATION, -MAX_SPEED)
		$Sprite.flip_h = true
		if is_on_floor():
			$Sprite.play("Run")
	else:
		friction=true
		if is_on_floor():
			if Input.is_action_pressed("ui_down"):
				$Sprite.play("Crouch")
			else:
				if sword_ready==true:
					$Sprite.play("Attack_Idle")
				else:
					$Sprite.play("Idle")
	
	if is_on_floor():
		if friction==true:
			motion.x = lerp(motion.x, 0, 0.2)
		if Input.is_action_just_pressed("ui_up"):
			motion.y = JUMP_HEIGHT
	else:
		if friction==true:
			motion.x = lerp(motion.x, 0, 0.05)
		if motion.y < 0:
			$Sprite.play("Jump")
		else:
			$Sprite.play("Fall")
	
	motion = move_and_slide(motion, UP)
	pass
