extends Node2D
export(NodePath) var collision_shape_path

onready var collision_shape: CollisionShape2D = get_node(collision_shape_path)
onready var anime = $AnimatedSprite
onready var area = $Area2D


func _ready() -> void:
    area.collision_mask = 2
    anime.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#    pass


func _on_Area2D_area_entered(_area: Area2D) -> void:
    pass


func _on_Area2D_body_entered(body: Node) -> void:
    if body != null and body.has_method("take_damage"):
        print("take damage")
        body.is_in_poision_area = true
        body.take_damage(1, Vector2.ZERO, 0, 'poision')
        


func _on_Area2D_body_exited(body: Node) -> void:
    if body != null and body.has_method("take_damage"):
        body.is_in_poision_area = false
