extends EnemyState
class_name EnemyHunt

var target_position: Vector2

func Enter():
	super.Enter()
	enemy_animator.play("enemy_warrior_move")
	print("HUNBTING")


func Update(delta: float):
	super.Update(delta)
	
	if enemy.target == null:
		Transitioned.emit(self, "EnemyWarriorRoam")
	else:
		if enemy.position.distance_to(enemy.target.position) < 50.0:
			Transitioned.emit(self, "EnemyWarriorAttack")
		

		

func Physics_Update(delta: float):
	super.Physics_Update(delta)
	if enemy and enemy.target != null:
		var direction = (enemy.target.position - enemy.position).normalized()
		enemy.velocity = direction * move_speed

