extends Node2D

var accent := Color("54d8e8")

func _draw() -> void:
	draw_rect(Rect2(-14,-35,28,44),Color("0a1220"))
	draw_rect(Rect2(-12,-33,24,39),Color("33465b"))
	draw_rect(Rect2(-10,-31,20,5),Color("54667a"))
	for y in [-23,-14,-5]:
		draw_rect(Rect2(-9,y,18,6),Color("172338"))
		draw_rect(Rect2(-7,y+2,3,2),accent)
		draw_line(Vector2(-1,y+2),Vector2(6,y+2),Color("627487"),1)
	draw_rect(Rect2(-12,5,24,3),Color("142333"))
