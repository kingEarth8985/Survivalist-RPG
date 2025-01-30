extends HFlowContainer

# Preload heart textures
var full_heart = preload("res://art/ui/hud/heart_full.png")
var half_heart = preload("res://art/ui/hud/heart_half.png")
var empty_heart = preload("res://art/ui/hud/heart_empty.png")

# Called every frame
func _process(delta):
	load_health()

# This function updates the health bar based on the current health
func load_health():
	var health = global.player_health
	print(health)
	
	# Store heart nodes in an array
	var hearts = [$Heart1, $Heart2, $Heart3, $Heart4, $Heart5]

	# Loop through each heart and update its texture
	for i in range(5):  # 5 hearts, each worth 2 HP
		var heart_hp = health - (i * 2)  # Calculate remaining HP for this heart
		
		if heart_hp >= 2:
			hearts[i].texture = full_heart  # Full heart
		elif heart_hp == 1:
			hearts[i].texture = half_heart  # Half heart
		else:
			hearts[i].texture = empty_heart  # Empty heart
