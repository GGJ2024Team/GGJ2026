extends Node

var num_floor: int = 0

var hp: int = 4
var weapons: Array = []
var equipped_weapon_index: int = 0

## 面具切换次数（用于第 10 次固定出现力量面具）
var mask_switch_count: int = 0
## 力量面具是否已出现过（仅出现一次）
var power_mask_already_shown: bool = false

func reset_data() -> void:
    num_floor = 0
    hp = 4
    weapons = []
    equipped_weapon_index = 0
    mask_switch_count = 0
    power_mask_already_shown = false

