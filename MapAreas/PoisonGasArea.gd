extends Node2D
export(NodePath) var collision_shape_path

onready var collision_shape: CollisionShape2D = get_node(collision_shape_path)
onready var anime = $AnimatedSprite


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    anime.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#    pass


func _on_Area2D_area_entered(area: Area2D) -> void:
    pass # Replace with function body.


func _on_Area2D_body_entered(body: Node) -> void:
    if body != null and body.has_method("take_damage"):
        print("take damage")
        body.is_in_poision_area = true
        body.take_damage(1, Vector2.ZERO, 0, 'poision')
        


func _on_Area2D_body_exited(body: Node) -> void:
    if body != null and body.has_method("take_damage"):
        body.is_in_poision_area = false
