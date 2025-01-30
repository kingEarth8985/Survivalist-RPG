extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.position = get_viewport_rect().size
