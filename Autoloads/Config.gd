extends Node

var mask_icon_path = {
    "normal_mask": "res://Assets/mask0.png",
    "gas_mask": "res://Assets/mask1.png",
    "stealth_mask": "res://Assets/mask2.png"
}

## 面具图片基础路径
const MASK_TEXTURE_BASE: String = "res://Assets/mask"

## 面具配置（speed_multiplier 影响玩家移速，1.0 为基准）
const MASK_CONFIG: Dictionary = {
    0: {  # GAS：防毒但降低移速
        "name": "防毒面具",
        "skill_name": "防毒",
        "skill_effect": "免疫毒气伤害，但会降低移速",
        "duration": 30.0,
        "speed_multiplier": 0.7
    },
    1: {  # STEALTH：潜行提高移速
        "name": "潜行面具",
        "skill_name": "潜行",
        "skill_effect": "降低被敌人发现的概率，能够提高移速",
        "duration": 25.0,
        "speed_multiplier": 1.2
    },
    2: {  # NORMAL
        "name": "普通面具",
        "skill_name": "无",
        "skill_effect": "",
        "duration": 20.0,
        "speed_multiplier": 1.0
    }
}

const MASK_TYPE_NORMAL: int = 2


func GetMaskConfig(p_type: int) -> Dictionary:
    return MASK_CONFIG.get(p_type, MASK_CONFIG[MASK_TYPE_NORMAL]).duplicate()


func GetMaskTexturePath(p_type: int) -> String:
    return MASK_TEXTURE_BASE + str(p_type) + ".png"
