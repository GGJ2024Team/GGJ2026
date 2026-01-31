extends Node

var mask_icon_path = {
    "normal_mask": "res://Assets/mask0.png",
    "gas_mask": "res://Assets/mask1.png",
    "stealth_mask": "res://Assets/mask2.png",
    "power_mask": "res://Assets/mask3.png"
}

## 面具图片基础路径
const MASK_TEXTURE_BASE: String = "res://Assets/mask"

## 面具配置
const MASK_CONFIG: Dictionary = {
    0: {  # NORMAL
        "name": "normalMask",
        "skill_name": "无",
        "skill_effect": "",
        "duration": 5.0,
        "speed_multiplier": 1.0
    },
    1: {  # GAS：防毒但降低移速
        "name": "gasMask",
        "skill_name": "防毒",
        "skill_effect": "免疫毒气伤害，但会降低移速",
        "duration": 5.0,
        "speed_multiplier": 0.7
    },
    2: {  # STEALTH：敌人看不见、80% 透明度、降低移速、无法攻击
        "name": "stealthMask",
        "skill_name": "潜行",
        "skill_effect": "敌人看不见，整体 80% 透明，降低移速，潜行期间无法攻击",
        "duration": 5.0,
        "speed_multiplier": 0.5,
        "stealth_opacity": 0.5
    },
    3: {  # POWER
        "name": "powerMask",
        "skill_name": "力量",
        "skill_effect": "攻击力、攻速、移速、体型与攻击距离增加；使用期间未击杀敌人则切换后面具时扣 1 血",
        "duration": 5.0,
        "speed_multiplier": 1.3,
        "damage_multiplier": 1.5,
        "attack_speed_multiplier": 1.3,
        "scale_multiplier": 1.2,
        "lose_hp_if_no_kill": true
    }
}

const MASK_TYPE_NORMAL: int = 0
const MASK_TYPE_POWER: int = 3
const POWER_MASK_TRIGGER_SWITCH: int = 10


func GetMaskConfig(p_type: int) -> Dictionary:
    return MASK_CONFIG.get(p_type, MASK_CONFIG[MASK_TYPE_NORMAL]).duplicate()


func GetMaskTexturePath(p_type: int) -> String:
    return MASK_TEXTURE_BASE + str(p_type) + ".png"


func IsPowerMaskTriggerSwitch() -> bool:
    return SavedData.mask_switch_count >= POWER_MASK_TRIGGER_SWITCH and not SavedData.power_mask_already_shown
