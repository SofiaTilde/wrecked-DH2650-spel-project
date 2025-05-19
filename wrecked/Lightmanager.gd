extends DirectionalLight3D

@onready var GlobaLlight = $"."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#används för att få tillgång till globala ljus riktningen för shading exempelvis
func _process(delta: float) -> void:
	if GlobaLlight:
		#is this needed?
		var light_dir = -GlobaLlight.global_transform.basis.z
		RenderingServer.global_shader_parameter_set("global_light_dir", light_dir)
