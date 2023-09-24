extends Control

@export var destination : Node = null
@export var keep_source_visible : bool = false
@export var hide_highlight : bool = false
@onready var highlight = $AnimatedSprite2D

signal go_to(source: Node, destination: Node, keep_source_visible: bool)

var inside = load("res://assets/graphics/cursorGauntlet_bronze.png")
var outside = load("res://assets/graphics/cursorHand_grey.png")

func _ready():
  if hide_highlight:
    highlight.visible = false
  highlight.position = size / 2.0

func _on_gui_input(event):
  if not event is InputEventMouseButton or event.button_index != MOUSE_BUTTON_LEFT or not event.pressed:
    return
  assert(destination != null)
  go_to.emit(get_parent(), destination, keep_source_visible)

func _on_mouse_entered():
  Input.set_custom_mouse_cursor(inside)

func _on_mouse_exited():
  Input.set_custom_mouse_cursor(outside)
