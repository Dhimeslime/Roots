extends KinematicBody2D
const UP = Vector2(0, -1)
const GRAVITY = 20
const MAX_SPEED = 200
const JUMP_HEIGHT = -550
const ACCELERATION = 15
var motion = Vector2()
var jumptimes = 0
export var max_health = 100
var health = max_health
var falldamage = 0;
var sword_ready = false
var sword_sheath = false
var fallspeed = 1
var canrun = true
var alive = true
var timeslow = 1
func _physics_process(delta):

#-------------------------------------------------------------------------------------------------------------------------------
#Timeslow
	if Input.is_key_pressed(KEY_SPACE):
		Engine.time_scale = 0.4
		timeslow = 2
	else:
		Engine.time_scale = 1
		timeslow = 1
		
#-------------------------------------------------------------------------------------------------------------------------------
#Death
	if(health<=0&&alive==true):
		alive=false
		$Sprite.play("Die")
		canrun=false
		yield(get_node("Sprite"), "animation_finished")
		
#-------------------------------------------------------------------------------------------------------------------------------
#Falling mechanic
	if(motion.y<2700):
		motion.y += GRAVITY*fallspeed
	fallspeed=1
	var friction = false

#-------------------------------------------------------------------------------------------------------------------------------
#Game controls
	if (Input.is_action_pressed("game_ctrl")&&Input.is_action_just_pressed("ui_right")&&canrun==true):
		motion.x+=2000
		$Sprite.flip_h = false
		$Sprite.play("Jump")
	if (Input.is_action_pressed("game_ctrl")&&Input.is_action_just_pressed("ui_left")&&canrun==true):
		motion.x-=2000
		$Sprite.flip_h = true
		$Sprite.play("Jump")
	if Input.is_action_pressed("game_shift"):
		if(!sword_ready==true&&is_on_floor()&&alive==true):
			$Sprite.play("Sword_Draw")
			canrun=false
			yield(get_node("Sprite"), "animation_finished")
			sword_sheath=true
			sword_ready=true
			canrun=true
	if (!Input.is_action_pressed("game_shift")):
		if(!sword_ready==true&&sword_sheath==true&&is_on_floor()&&alive==true):
			$Sprite.play("Sword_Sheath")
			canrun=false
			yield(get_node("Sprite"), "animation_finished")
			sword_ready=false
			sword_sheath=false
			canrun=true
		sword_ready=false
	if Input.is_action_pressed("ui_right")&&!Input.is_action_pressed("game_ctrl")&&canrun==true:
		motion.x = min(motion.x+ACCELERATION, MAX_SPEED)
		$Sprite.flip_h = false
		if is_on_floor():
			$Sprite.play("Run")
	elif Input.is_action_pressed("ui_left")&&!Input.is_action_pressed("game_ctrl")&&canrun==true:
		motion.x = max(motion.x-ACCELERATION, -MAX_SPEED)
		$Sprite.flip_h = true
		if is_on_floor():
			$Sprite.play("Run")
	else:
		friction=true
		if is_on_floor()&&alive==true:
			if Input.is_action_pressed("ui_down"):
				$Sprite.play("Crouch")
			else:
				if sword_ready==true:
					$Sprite.play("Attack_Idle")
				else:
					$Sprite.play("Idle")
					
#-------------------------------------------------------------------------------------------------------------------------------
#Jumping and wall cling
	if is_on_wall():
		jumptimes=0
	if is_on_floor()&&alive==true:
		jumptimes=0
		if(falldamage>0):
			if(timeslow==1):
				if(falldamage>30):
					health-=round(falldamage/1.5);
					print(round(falldamage/1.5))
					print("Health: " + str(health))
					$Label.text = "Health: " + str(health)
			else:
				if(falldamage>60):
					health-=round(falldamage/3);
					print(round(falldamage/3))
					print("Health: " + str(health))
					$Label.text = "Health: " + str(health)
			falldamage=0
		if friction==true:
			motion.x = lerp(motion.x, 0, 0.2)
		if Input.is_action_just_pressed("ui_up"):
			motion.y = JUMP_HEIGHT*timeslow
	else:
		falldamage=motion.y/30
		if friction==true:
			motion.x = lerp(motion.x, 0, 0.05)
		if motion.y < 0&&alive==true:
			$Sprite.play("Jump")
		else:
			if is_on_wall()&&!is_on_floor()&&alive==true:
				fallspeed=.008
				if(motion.y>10):
					fallspeed=-0.05
				$Sprite.play("Wall_Slide")
				
			else:
				if alive==true:
					$Sprite.play("Fall")
	if (jumptimes<1&&!is_on_floor()&&alive==true):
		if friction==true:
			motion.x = lerp(motion.x, 0, 0.2)
		if Input.is_action_just_pressed("ui_up"):
			motion.y = JUMP_HEIGHT*timeslow
			jumptimes+=1
	motion = move_and_slide(motion, UP)
	pass
