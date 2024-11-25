extends Camera3D

@export var follow_target: Node3D  # Karakteren kameraet skal følge
@export var offset: Vector3 = Vector3(0, 5, -10)  # Kameraets posisjon i forhold til karakteren
@export var smooth_follow: bool = true  # Myk oppfølging av karakteren
@export var follow_speed: float = 5.0  # Hvor raskt kameraet følger karakteren

func _process(delta: float) -> void:
	if not follow_target:
		return

	# Få karakterens posisjon
	var target_position = follow_target.global_transform.origin + offset

	# Myk oppfølging av karakteren
	if smooth_follow:
		global_transform.origin = global_transform.origin.lerp(target_position, follow_speed * delta)
	else:
		global_transform.origin = target_position

	# Kameraet ser alltid på karakteren
	look_at(follow_target.global_transform.origin, Vector3.UP)
