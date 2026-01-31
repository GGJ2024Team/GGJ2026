extends Control

func _ready() -> void:
    pass


func _on_NewGame_pressed():
    SavedData.reset_data()
    SceneTransistor.start_transition_to("res://Game.tscn")


func _on_Quit_pressed():
    get_tree().quit()
