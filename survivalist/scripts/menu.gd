extends Control

func _ready():
	self.position = get_viewport_rect().size/2

func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/player.tscn")
