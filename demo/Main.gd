extends Node

onready var gdclip = preload("res://bin/gdclip.gdns").new()

# Called when the node enters the scene tree for the first time.
func _ready():
	print("GDClip Library version: %s" % gdclip.get_version())
	print("Pasted text: %s" % gdclip.get_text())
	print(gdclip.has_image())
	if gdclip.has_image():
		var image_byte_array = gdclip.get_image_as_pbarray()
		var size = gdclip.get_image_size()
		print(size)
		draw_pbarray(image_byte_array, size[0], size[1])
	test_gdclip_not_null()
	print("test_gdclip_not_null Passed")
	test_clear_1()
	print("test_clear_1 Passed")
	test_clear_2()
	print("test_clear_2 Passed")
	test_set_text_1()
	print("test_set_text_1 Passed")
	test_set_text_2()
	print("test_set_text_2 Passed")
	test_get_text_1()
	print("test_get_text_1 Passed")
	test_get_text_2()
	print("test_get_text_2 Passed")
	test_get_text_3()
	print("test_get_text_3 Passed")
	test_has_image_1()
	print("test_has_image_1 Passed")
	test_has_image_2()
	print("test_has_image_2 Passed")
	test_has_image_3()
	print("test_has_image_3 Passed")
	test_get_image_size_1()
	print("test_get_image_size_1 Passed")
	test_get_image_size_2()
	print("test_get_image_size_2 Passed")
	test_get_image_size_3()
	print("test_get_image_size_3 Passed")
	test_get_image_as_pbarray_1()
	print("test_get_image_as_pbarray_1 Passed")
	test_get_image_as_pbarray_2()
	print("test_get_image_as_pbarray_2 Passed")
	test_get_image_as_pbarray_3()
	print("test_get_image_as_pbarray_3 Passed")
	test_set_image_from_pbarray_1()
	print("test_set_image_as_pbarray_1 Passed")
	test_set_image_from_pbarray_2()
	print("test_set_image_as_pbarray_2 Passed")

func draw_pbarray(pbarray: PoolByteArray, width: int, height: int):
	var test_sprite = Sprite.new()
	var texture = ImageTexture.new()
	var image = Image.new()
	image.create_from_data(width, height, false, Image.FORMAT_RGBA8, pbarray)
	print(image.get_size())
	texture.create_from_image(image)
	test_sprite.set_texture(texture)
	test_sprite.position = get_viewport().get_visible_rect().size/2
	add_child(test_sprite)

# TEST functions

func gen_random_colors(num_colors: int) -> PoolByteArray:
	var ret = []
	if num_colors > 0:
		for _i in range(0, num_colors):
			ret.append(randi() % 256)
			ret.append(randi() % 256)
			ret.append(randi() % 256)
			ret.append(randi() % 256)
	return ret

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
	var orange_pixel = [255, 110, 18, 255]
	assert(gdclip)
	assert(gdclip.set_image_from_pbarray(orange_pixel, 1, 1))
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
	var black_pixel = [0, 0, 0, 255]
	assert(gdclip)
	assert(gdclip.set_image_from_pbarray(black_pixel, 1, 1))
	assert(gdclip.has_image())
	assert(gdclip.get_text() == "")

# Return [0, 0] array if there is no image in clipboard
func test_get_image_size_1():
	assert(gdclip)
	assert(gdclip.clear())
	var size = gdclip.get_image_size()
	assert(size[0] == 0)
	assert(size[1] == 0)

# Return correct sizes for various sample images in clipboard
func test_get_image_size_2():
	var one_by_one = gen_random_colors(1)
	var two_by_three = gen_random_colors(6)
	assert(gdclip)
	assert(gdclip.set_image_from_pbarray(one_by_one, 1, 1))
	var size = gdclip.get_image_size()
	assert(size[0] == 1)
	assert(size[1] == 1)
	assert(gdclip.set_image_from_pbarray(two_by_three, 2, 3))
	size = gdclip.get_image_size()
	assert(size[0] == 2)
	assert(size[1] == 3)

# Return [0, 0] array if text has been set
func test_get_image_size_3():
	assert(gdclip)
	assert(gdclip.set_text("test_get_image_size_3"))
	var size = gdclip.get_image_size()
	assert(size[0] == 0)
	assert(size[1] == 0)

# Return empty array if clipboard is empty
func test_get_image_as_pbarray_1():
	assert(gdclip)
	assert(gdclip.clear())
	assert(gdclip.get_image_as_pbarray().empty())

# Return empty array if text is set
func test_get_image_as_pbarray_2():
	assert(gdclip)
	assert(gdclip.set_text("test_get_image_as_pbarray_2"))
	assert(gdclip.get_image_as_pbarray().empty())

# Set pbarray images and compare with pbarray images from clipboard
func test_get_image_as_pbarray_3():
	var one_by_one = gen_random_colors(1)
	var two_by_three = gen_random_colors(6)
	assert(gdclip)
	assert(gdclip.set_image_from_pbarray(one_by_one, 1, 1))
	var image_byte_array = gdclip.get_image_as_pbarray()
	for i in range(0, 4):
		assert(image_byte_array[i] == one_by_one[i])
	assert(gdclip.set_image_from_pbarray(two_by_three, 2, 3))
	image_byte_array = gdclip.get_image_as_pbarray()
	for i in range(0, 6*4):
		assert(image_byte_array[i] == two_by_three[i])

# Return false if image width or height is zero
func test_set_image_from_pbarray_1():
	assert(gdclip)
	assert(!gdclip.set_image_from_pbarray([], 0, 0))
	assert(!gdclip.set_image_from_pbarray([], 0, 2))
	assert(!gdclip.set_image_from_pbarray([], 2, 0))
	assert(!gdclip.set_image_from_pbarray([255, 255, 255, 255], 0, 0))

# Return false if PoolByteArray size is less than width*height*4
func test_set_image_from_pbarray_2():
	var two_by_three = gen_random_colors(6)
	assert(gdclip)
	assert(!gdclip.set_image_from_pbarray(two_by_three, 3, 3))
	assert(!gdclip.set_image_from_pbarray(two_by_three, 2, 4))
	assert(gdclip.set_image_from_pbarray(two_by_three, 1, 3))
	assert(gdclip.set_image_from_pbarray(two_by_three, 2, 2))
