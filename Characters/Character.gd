extends KinematicBody2D
class_name Character, "res://art/v1.1 dungeon crawler 16X16 pixel pack/heroes/knight/knight_idle_anim_f0.png"

const FRICTION: float = 0.15

export(int) var hp: int = 2 setget set_hp

export(bool) var task_poision_damage:bool = false

signal hp_changed(new_hp)

export(int) var accerelation: int = 40
export(int) var max_speed: int = 100

## 面具等外部施加的移速倍率，1.0 为无修正
var speed_multiplier: float = 1.0
## 力量面具等施加的伤害倍率，1.0 为无修正
var damage_multiplier: float = 1.0
## 力量面具等施加的攻速倍率，1.0 为无修正
var attack_speed_multiplier: float = 1.0

var is_in_poision_area: bool = false
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

func is_task_poision_damage():
    return task_poision_damage


func _is_wearing_gas_mask() -> bool:
    var mask_node = get_node_or_null("Mask")
    if not mask_node or not mask_node.has_method("GetCurrentMask"):
        return false
    var info = mask_node.GetCurrentMask()
    return info.get("type", 0) == 1


## 潜行面具时敌人看不见
func is_visible_to_enemies() -> bool:
    var mask_node = get_node_or_null("Mask")
    if not mask_node or not mask_node.has_method("GetCurrentMask"):
        return true
    var info = mask_node.GetCurrentMask()
    return info.get("type", 0) != 2


func on_timeout_take_poision_damage(timer):
    if not is_in_poision_area:
        timer.queue_free()
        return
    if _is_wearing_gas_mask():
        timer.queue_free()
        return
    take_damage(1, Vector2.ZERO, 0, "normal")

func take_damage(dam: int, dir: Vector2, force: int, damage_type: String = "normal", from_poison_timer: bool = false, attacker = null) -> void:
    if damage_type == "poision":
        if _is_wearing_gas_mask():
            return
        if is_task_poision_damage():
            var timer = Timer.new()
            timer.wait_time = 1
            timer.one_shot = false
            add_child(timer)
            timer.connect("timeout", self, "on_timeout_take_poision_damage", [timer])
            timer.start()
        return
    if state_machine.state != state_machine.states.hurt and state_machine.state != state_machine.states.dead:
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
            if attacker and attacker.has_method("on_kill"):
                attacker.on_kill()

func set_hp(new_hp: int) -> void:
    hp = new_hp
    emit_signal("hp_changed", new_hp)


