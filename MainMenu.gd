extends Control

func _ready() -> void:
    yield(get_tree().create_timer(3.0), "timeout")
    SavedData.reset_data()
    get_tree().change_scene("res://Game.tscn")
