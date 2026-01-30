extends AnimatedSprite

func _ready():
    playing = true

func _on_SpawnExplosion_animation_finished() -> void:
    queue_free()
