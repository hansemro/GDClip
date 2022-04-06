extends Node

onready var gdclip = preload("res://bin/gdclip.gdns").new()

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Pasted text: %s" % gdclip.get_text())
	print(gdclip.has_image())
	if gdclip.has_image():
		var image_byte_array = gdclip.get_image_as_pbarray()
		var test_sprite = Sprite.new()
		var texture = ImageTexture.new()
		var image = Image.new()
		var size = gdclip.get_image_size()
		print(size)
		image.create_from_data(size[0], size[1], false, Image.FORMAT_RGBA8, image_byte_array)
		print(image.get_size())
		texture.create_from_image(image)
		test_sprite.set_texture(texture)
		test_sprite.position = get_viewport().get_visible_rect().size/2
		add_child(test_sprite)
