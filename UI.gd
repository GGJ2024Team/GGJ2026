extends CanvasLayer

const MIN_HEALTH: int = 23

var max_hp: int = 4

onready var player: KinematicBody2D = get_parent().get_node("Player")
onready var mask = player.get_node("Mask")
onready var health_bar: TextureProgress = get_node("HealthBar")
onready var health_bar_tween: Tween = get_node("HealthBar/Tween")
onready var countdown = $VBoxContainer/Countdown
onready var maskSprite = $VBoxContainer/MaskSprite
onready var maskName = $VBoxContainer/MaskName

func _ready() -> void:
    max_hp = player.hp
    _update_health_bar(100)
    var _duration_timer = Timer.new()
    add_child(_duration_timer)
    _duration_timer.connect("timeout", self, "_update_countdown")
    _duration_timer.wait_time = 1.0
    _duration_timer.start()

func _update_health_bar(new_value: int) -> void:
    var __ = health_bar_tween.interpolate_property(health_bar, "value",
        health_bar.value, new_value, 0.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
    __ = health_bar_tween.start()


func _on_Player_hp_changed(new_hp):
    var new_health: int = int(100 - MIN_HEALTH) *float(new_hp)/max_hp + MIN_HEALTH
    _update_health_bar(new_health)

func _update_countdown():
    if mask:
        var p_type = mask.GetNextMaskType()
        var path = get_node("/root/Config").GetMaskTexturePath(p_type)
        var tex = load(path) as Texture
        if tex:
            maskSprite.texture = tex
        var name = get_node("/root/Config").GetMaskConfig(p_type).name
        maskName.text = name
        countdown.text = String(mask.GetRemainingTime())

