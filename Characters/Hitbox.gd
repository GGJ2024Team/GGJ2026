extends Area2D
class_name Hitbox

export(int) var damage: int = 1
var knockback_direction: Vector2 = Vector2.ZERO
export(int) var knockback_force: int = 300

var body_inside: bool = false

onready var collision_shape: CollisionShape2D = get_child(0)
onready var timer: Timer = Timer.new()


func _init() -> void:
    var __ = connect("body_entered", self, "_on_body_entered")
    __ = connect("body_exited", self, "_on_body_exited")
    
    
func _ready() -> void:
    assert(collision_shape != null)
    timer.wait_time = 1
    add_child(timer)
    
    
func _on_body_entered(body: PhysicsBody2D) -> void:
    body_inside = true
    timer.start()
    while body_inside:
        _collide(body)
        yield(timer, "timeout")
    
    
func _on_body_exited(_body: KinematicBody2D) -> void:
    body_inside = false
    timer.stop()
    
    
func _collide(body: KinematicBody2D) -> void:
    if body == null or not body.has_method("take_damage"):
        queue_free()
        return
    var node = self
    for _i in range(4):
        node = node.get_parent() if node else null
    var attacker = node
    var actual_dam = damage
    if attacker and attacker.get("damage_multiplier") != null:
        actual_dam = int(damage * attacker.damage_multiplier)
    body.take_damage(actual_dam, knockback_direction, knockback_force, "normal", false, attacker)
