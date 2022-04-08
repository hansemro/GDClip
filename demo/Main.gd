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

# TEST functions

# checks if gdclip library was loaded successfully
func test_gdclip_not_null():
	assert(gdclip)

# clear clipboard and check if clipboard is empty
func test_clear_1():
	assert(gdclip)
	assert(gdclip.clear())
	assert(gdclip.get_text() == "")
	assert(!gdclip.has_image())

# add text to clipboard, clear, then check if clipboard is empty
func test_clear_2():
	assert(gdclip)
	assert(gdclip.set_text("text set from godot"))
	assert(gdclip.clear())
	assert(gdclip.get_text() == "")
	assert(!gdclip.has_image())

# set various text to clipboard and check
func test_set_text_1():
	assert(gdclip)
	var strings = ["", "free software is best software", "☆☆☆☆"]
	for s in strings:
		assert(gdclip.set_text(s))
		assert(gdclip.get_text() == s)
		assert(!gdclip.has_image())

# set text after clearing and check
func test_set_text_2():
	var text = "test set_text_2"
	assert(gdclip)
	assert(gdclip.clear())
	assert(gdclip.set_text(text))
	assert(gdclip.get_text() == text)

# return empty string after clear
func test_get_text_1():
	assert(gdclip)
	assert(gdclip.clear())
	assert(gdclip.get_text() == "")

# return string after setting text in clipboard
func test_get_text_2():
	var text = "test get_text_2"
	assert(gdclip)
	assert(gdclip.set_text(text))
	assert(gdclip.get_text() == text)

# return empty string after setting image
func test_get_text_3():
	var orange_pixel = [255, 110, 18, 0]
	assert(gdclip)
	assert(gdclip.set_image_from_pbarray(orange_pixel))
	assert(gdclip.get_text() == "")

# return false after setting text
func test_has_image_1():
	assert(gdclip)
	assert(gdclip.set_text("test_has_image_1"))
	assert(!gdclip.has_image())

# return false after clear
func test_has_image_2():
	assert(gdclip)
	assert(gdclip.clear())
	assert(!gdclip.has_image())

# return true after setting image
func test_has_image_3():
	var black_pixel = [0, 0, 0, 0]
	assert(gdclip)
	assert(gdclip.set_image_from_pbarray(black_pixel))
	assert(gdclip.has_image())
	assert(gdclip.get_text() == "")
