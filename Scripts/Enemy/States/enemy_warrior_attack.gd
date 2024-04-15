extends EnemyState
class_name EnemyWarriorAttack

var target_position: Vector2
var current_time = 0

func Enter():
	super.Enter()
	enemy_animator.play("enemy_warrior_attack")
	current_time = 0

func Update(delta: float):
	super.Update(delta)
	
	if enemy.target == null:
		Transitioned.emit(self, "EnemyWarriorRoam")
	else:
		if enemy.position.distance_to(enemy.target.position) > 100.0:
			Transitioned.emit(self, "EnemyWarriorHunt")
			
		if current_time >= 1:
			enemy.target.hit()
			current_time = 0
			
	current_time += delta

func Physics_Update(delta: float):
	super.Physics_Update(delta)
	if enemy:
		enemy.velocity = Vector2.ZERO

