extends CharacterBody2D

var speed = 40
var player_chase = false
var player = null
var slime_health = 100
var player_in_attack_zone = false

var can_take_dmg = true


func _physics_process(delta: float) -> void:
	deal_with_damage()
	
	if player_chase:
		position += (player.position - position)/speed
		
		$AnimatedSprite2D.play("walk_side")
		
		if (player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
		
	else:
		$AnimatedSprite2D.play("idle_side")


func _on_detectian_area_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true
	
func _on_detectian_area_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false

func enemy():
	pass



func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_attack_zone = true


func _on_enemy_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_attack_zone = false
		
		
func deal_with_damage():
	if player_in_attack_zone and Global.player_current_attack == true:
		if can_take_dmg == true:
			slime_health = slime_health - 20
			can_take_dmg = false
			$take_damage_cooldown.start()
			print("slime health = ", slime_health)
			if slime_health <= 0:
				self.queue_free()


func _on_take_damage_cooldown_timeout() -> void:
	can_take_dmg = true
