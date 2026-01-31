extends Node2D

## 面具类型（与 Config 键一致：0=NORMAL，1=GAS, 2=STEALTH, 3=POWER）
enum MaskType {
    NORMAL,
    GAS,
    STEALTH,
    POWER
}

signal mask_changed(new_type)

## 当前佩戴的面具类型
var _current_type: int = MaskType.NORMAL
## 下一个将切换到的面具类型
var _next_type: int = MaskType.NORMAL

## “下一个面具”的候选池（不含 POWER，POWER 由第 10 次切换单独触发）
var _mask_pool: Array = [MaskType.GAS, MaskType.STEALTH, MaskType.NORMAL]

## 力量面具佩戴期间是否击杀过敌人
var _power_mask_got_kill: bool = false

var _mask_sprite: Sprite
var _audio_player: AudioStreamPlayer2D
var _duration_timer: Timer


func _ready() -> void:
    _mask_sprite = get_node("MaskSprite")
    _audio_player = get_node("AudioStreamPlayer2D")
    _duration_timer = get_node("DurationTimer")
    _duration_timer.one_shot = true
    var _discard = _duration_timer.connect("timeout", self, "_switch_to_next_mask")
    _apply_mask_texture(_current_type)
    _mask_sprite.visible = true
    _mask_sprite.modulate.a = 1.0
    _pick_next_mask()
    _start_duration_timer()
    _apply_mask_effect_to_player()
    _switch_to_next_mask()


func _start_duration_timer() -> void:
    var cfg = GetMaskConfig(_current_type)
    _duration_timer.wait_time = cfg["duration"]
    _duration_timer.start()


func _get_player():
    var p = get_parent()
    return p if p is Character else null


func _apply_mask_effect_to_player() -> void:
    var player = _get_player()
    if not player:
        return
    var cfg = GetMaskConfig(_current_type)
    player.speed_multiplier = cfg.get("speed_multiplier", 1.0)
    player.damage_multiplier = cfg.get("damage_multiplier", 1.0)
    player.attack_speed_multiplier = cfg.get("attack_speed_multiplier", 1.0)
    if cfg.has("stealth_opacity"):
        player.modulate.a = cfg["stealth_opacity"]
    else:
        player.modulate.a = 1.0
    var scale_mul = cfg.get("scale_multiplier", 1.0)
    player.scale = Vector2(scale_mul, scale_mul)


func _get_config_for_type(p_type: int) -> Dictionary:
    return get_node("/root/Config").GetMaskConfig(p_type)


func _pick_next_mask() -> void:
    if _mask_pool.size() == 0:
        _next_type = MaskType.NORMAL
        return
    var candidates = []
    for t in _mask_pool:
        if t != _current_type:
            candidates.append(t)
    if candidates.size() > 0:
        _next_type = candidates[randi() % candidates.size()]
    else:
        _next_type = _current_type


func _switch_to_next_mask() -> void:
    SavedData.mask_switch_count += 1
    if SavedData.mask_switch_count == get_node("/root/Config").POWER_MASK_TRIGGER_SWITCH and not SavedData.power_mask_already_shown:
        _next_type = MaskType.POWER
        SavedData.power_mask_already_shown = true
    var player = _get_player()
    if _current_type == MaskType.POWER and player:
        var cfg = GetMaskConfig(MaskType.POWER)
        if cfg.get("lose_hp_if_no_kill", false) and not _power_mask_got_kill:
            player.take_damage(1, Vector2.ZERO, 0)
        _power_mask_got_kill = false
    _current_type = _next_type
    _pick_next_mask()
    _start_duration_timer()
    _apply_mask_effect_to_player()
    _on_mask_switched(_current_type)


func _apply_mask_texture(p_type: int) -> void:
    var path = get_node("/root/Config").GetMaskTexturePath(p_type)
    var tex = load(path) as Texture
    if tex:
        _mask_sprite.texture = tex


var _switch_target_type: int = -1

## 面具切换时的回调
func _on_mask_switched(p_new_type: int) -> void:
    _switch_target_type = p_new_type
    _apply_mask_texture(p_new_type)
    _mask_sprite.visible = true
    _audio_player.stream.loop = false
    _audio_player.play()
    emit_signal("mask_changed", _next_type)


func _on_tween_mid() -> void:
    _apply_mask_texture(_switch_target_type)


func _on_tween_end() -> void:
    _mask_sprite.visible = true


## 根据面具类型获取配置
func GetMaskConfig(p_type: int) -> Dictionary:
    return _get_config_for_type(p_type)


## 获取当前面具剩余佩戴时间（秒）
func GetRemainingTime() -> int:
    return int(_duration_timer.time_left) if _duration_timer else 0


## 获取当前面具的完整配置
func GetCurrentMaskConfig() -> Dictionary:
    var cfg = GetMaskConfig(_current_type)
    cfg["type"] = _current_type
    cfg["remaining_time"] = GetRemainingTime()
    return cfg


## 获取当前面具简要信息
func GetCurrentMask() -> Dictionary:
    var cfg = GetCurrentMaskConfig()
    return {
        "type": cfg["type"],
        "remaining_time": cfg["remaining_time"],
        "duration": cfg["duration"],
        "skill_name": cfg["skill_name"],
        "name": cfg["name"]
    }


## 获取下一个面具简要信息
func GetNextMask() -> Dictionary:
    var cfg = GetMaskConfig(_next_type)
    cfg["type"] = _next_type
    return cfg

## 获取下一个面具类型
func GetNextMaskType() -> int:
    return _next_type


## 玩家击杀敌人时由 Player.on_kill 调用；力量面具期间击杀则免除切换后扣血
func OnPlayerKill() -> void:
    if _current_type == MaskType.POWER:
        _power_mask_got_kill = true


## 当前面具类型应用技能效果（移速等已通过 _apply_mask_effect_to_player 作用于 Character）
func ApplyMaskSkill(_delta: float) -> void:
    pass

