extends KinematicBody2D
class_name Character, "res://art/v1.1 dungeon crawler 16X16 pixel pack/heroes/knight/knight_idle_anim_f0.png"

const FRICTION: float = 0.15

export(int) var hp: int = 2 setget set_hp
export(String) var mask: String = "None" setget set_mask

signal hp_changed(new_hp)
signal mask_change(new_mask)

export(int) var accerelation: int = 40
export(int) var max_speed: int = 100

## 面具等外部施加的移速倍率，1.0 为无修正
var speed_multiplier: float = 1.0

var mov_direction: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO

onready var state_machine: Node = get_node("FiniteStateMachine")
onready var animated_sprite: AnimatedSprite = get_node("AnimatedSprite")



func _physics_process(_delta: float) -> void:
    velocity = move_and_slide(velocity)
    velocity = lerp(velocity, Vector2.ZERO, FRICTION)
    
    
func move() -> void:
	mov_direction = mov_direction.normalized()
	var acc = int(accerelation * speed_multiplier)
	var cap = int(max_speed * speed_multiplier)
	velocity += mov_direction * acc
	velocity = velocity.clamped(cap)

func take_damage(dam: int, dir: Vector2, force: int) -> void:
    if state_machine.state != state_machine.states.hurt and state_machine.state != state_machine.states.dead:
#		_spawn_hit_effect()
        self.hp -= dam
        if name == "Player":
            SavedData.hp = hp
            if hp == 0:
                SceneTransistor.start_transition_to("res://Game.tscn")
                SavedData.reset_data()
        if hp > 0:
            state_machine.set_state(state_machine.states.hurt)
            velocity += dir * force
        else:
            state_machine.set_state(state_machine.states.dead)
            velocity += dir * force * 2
            
func set_hp(new_hp: int) -> void:
    hp = new_hp
    emit_signal("hp_changed", new_hp)
    
func set_mask(new_mask: String) -> void:
    mask = new_mask
    emit_signal("mask_change", new_mask)
