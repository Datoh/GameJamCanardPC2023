@tool
extends Control

@onready var capture_input = $CaptureInput
@onready var highlight = $AnimatedSprite2D
@export var area_popup : PanelContainer = null
@export var label : RichTextLabel = null
@export var hide_highlight : bool = false

@export var popup_visible : bool = false :
  set (value):
    if area_popup != null:
      area_popup.visible = value
      capture_input.global_position = Vector2.ZERO
      capture_input.visible = value
    if label != null:
      label.visible = value
    for node in get_children():
      if node.is_in_group("area_highlight"):
        node.visible = value
  get:
    return area_popup != null and area_popup.visible

signal clue_discovered(clue_label: String, clue_type: Clue.Type)

var inside = load("res://assets/graphics/cursorGauntlet_bronze.png")
var outside = load("res://assets/graphics/cursorHand_grey.png")

func _ready():
  if hide_highlight:
    highlight.visible = false
  highlight.position = size / 2.0

func _on_gui_input(event):
  if not event is InputEventMouseButton or event.button_index != MOUSE_BUTTON_LEFT or not event.pressed:
    return
  GlobalPopup.show_popup(self)
  for node in get_children():
    if node is Clue:
      clue_discovered.emit(node.label, node.type)

func _on_mouse_entered():
  Input.set_custom_mouse_cursor(inside)

func _on_mouse_exited():
  Input.set_custom_mouse_cursor(outside)

func _on_capture_input_gui_input(event):
  if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
    GlobalPopup.hide_popup(self)
