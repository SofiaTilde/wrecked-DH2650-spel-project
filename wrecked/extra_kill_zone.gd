extends Area3D

var SPLASH_SOUND := preload("res://sounds/fall.wav")

func play_splash_sfx():
	var p := AudioStreamPlayer.new()
	p.stream = SPLASH_SOUND
	add_child(p)
	p.play()
	p.finished.connect(p.queue_free)

func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		if body.player_data.can_swim:
			body.player_data.can_jump=false
			var swim_timer = get_tree().create_timer(0.4) #needed if we dont want to gain much momentum from boyancy
			swim_timer.connect("timeout", Callable(body, "_on_swim_timer_timeout"))
		else:
			body.velocity = body.velocity * 0.3 # lose speed when entering water
			play_splash_sfx()
			body.respawn()
