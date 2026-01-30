extends Node2D
export(NodePath) var collision_shape_path

onready var collision_shape: CollisionShape2D = get_node(collision_shape_path)



# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#    pass


func _on_Area2D_area_entered(area: Area2D) -> void:
    pass # Replace with function body.


func _on_Area2D_body_entered(body: Node) -> void:
    print("body enter")


func _on_Area2D_body_exited(body: Node) -> void:
    print("body exit")
