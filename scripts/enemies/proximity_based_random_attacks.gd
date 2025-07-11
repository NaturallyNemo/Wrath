extends AnimationPlayer
@export var ATTACK_ANIMATION: Array[String] = []
@export var ATTACK_RADIUS: Array[float] = []
@export var ATTACK_LIKELEHOOD: Array[Curve] = []
@export var LIKELIHOOD_MULTIPLIERS: Array[float] = []
@export var LIKELIHOOD_MULTIPLIER: float = 1.0
@export var ATTACKING: bool = false
@export var TARGET: Node3D
@export var BODY: Node3D

func play_random_attack(position: Vector3, target_position: Vector3, delta: float) -> void:
	#print("Playing attack:", ATTACK_ANIMATION[i])
	var indices = range(ATTACK_ANIMATION.size())  
	indices.shuffle();  #print(indices) # randomly sort attacks to distrubte priorty
	for i in indices:
		var normalized_distance = clamp(position.distance_to(target_position) / ATTACK_RADIUS[i], 0.0, 1.0)
		var attack_likelihood = ATTACK_LIKELEHOOD[i].sample(randf()) * (1.0 - normalized_distance)
		attack_likelihood *= delta * LIKELIHOOD_MULTIPLIERS[i] * LIKELIHOOD_MULTIPLIER
		if randf() < attack_likelihood:
			play(ATTACK_ANIMATION[i])
			break

func _physics_process(delta: float) -> void:
	if BODY and TARGET:
		play_random_attack(BODY.global_position, TARGET.global_position,delta)
