extends Node2D

@onready var overlay = %FadeOverlay

@onready var exploring = %Exploring
@onready var thinking = %Thinking
@onready var credits = %Credits
@onready var exploring_switch = %ExploringSwitch
@onready var thinking_switch = %ThinkingSwitch
@onready var settings = %Settings

func _ready():
  var data = SaveGame.load_game()
  if not data.is_empty():
    _restore_clue("clue", data[0])
    _restore_clue("scroll_clue", data[1])
    _restore_clue("identity_clue", data[2])
    _restore_clue("other_clue", data[3])
  _validate("scroll_clue", $UI/LevelCustomContent/Exploring.correct_scroll, find_child("ScrollOK"), find_child("ScrollKO"))
  _validate("identity_clue", $UI/LevelCustomContent/Exploring.correct_identity, find_child("IdentityOK"), find_child("IdentityKO"))
  _validate("other_clue", $UI/LevelCustomContent/Exploring.correct_other, find_child("OtherOK"), find_child("OtherKO"))

  %HintButton.button_pressed = UserSettings.get_value(UserSettings.SHOWHIGHLIGHT)
  %HintButton.get_node("TextureRect").modulate = Color.GREEN if %HintButton.button_pressed else Color.RED
  GlobalPopup.update_popup()

  exploring.clue_discovered.connect(_on_clue_discovered)
  for node in get_tree().get_nodes_in_group("scroll_clue"):
    node.updated.connect(_on_clue_updated)
  for node in get_tree().get_nodes_in_group("identity_clue"):
    node.updated.connect(_on_clue_updated)
  for node in get_tree().get_nodes_in_group("other_clue"):
    node.updated.connect(_on_clue_updated)
  for node in get_tree().get_nodes_in_group("area_highlight"):
    if node.has_method("popup_visible"):
      node.popup_visible = false
    if node.has_signal("clue_discovered"):
      node.clue_discovered.connect(_on_clue_discovered)
  for node in get_tree().get_nodes_in_group("door"):
    node.go_to.connect(_on_go_to)
  overlay.visible = true
  overlay.on_complete_fade_out.connect(_on_fade_overlay_on_complete_fade_out)

func _on_clue_updated():
  _save_game()
  var scroll_ok = _validate("scroll_clue", $UI/LevelCustomContent/Exploring.correct_scroll, find_child("ScrollOK"), find_child("ScrollKO"))
  var identity_ok = _validate("identity_clue", $UI/LevelCustomContent/Exploring.correct_identity, find_child("IdentityOK"), find_child("IdentityKO"))
  var other_ok = _validate("other_clue", $UI/LevelCustomContent/Exploring.correct_other, find_child("OtherOK"), find_child("OtherKO"))
  var has_new_ok = scroll_ok.new or identity_ok.new or other_ok.new
  if has_new_ok:
    if scroll_ok.ok and identity_ok.ok and other_ok.ok:
      exploring.visible = false
      thinking.visible = false
      credits.visible = true
      $GameDoneJingle.play()
    elif scroll_ok.ok or identity_ok.ok or other_ok.ok:
      $ThinkingOkJingle.play()

func _validate(group: String, correct_array: Array, node_ok: Node, node_ko: Node) -> Dictionary:
  var was_all_correct = node_ok.visible
  var nodes = get_tree().get_nodes_in_group(group)
  assert(nodes.size() == correct_array.size())
  var all_correct = not nodes.is_empty()
  var index = 0
  for node in nodes:
    all_correct = all_correct and correct_array[index] == node.label
    index += 1
  node_ok.visible = all_correct
  node_ko.visible = not all_correct
  return {"ok" : all_correct, "new": not was_all_correct and all_correct}

func _on_thinking_label_gui_input(event: InputEvent):
  if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
    thinking.visible = true
    exploring.visible = false
    thinking_switch.visible = true
    exploring_switch.visible = false

func _on_exploring_label_gui_input(event):
  if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
    thinking.visible = false
    exploring.visible = true
    thinking_switch.visible = false
    exploring_switch.visible = true
    credits.visible = false

func _on_quit_button_pressed():
  overlay.fade_out()

func _on_settings_button_pressed():
  settings.visible = true

func _on_hint_button_toggled(toggled_on):
  UserSettings.set_value(UserSettings.SHOWHIGHLIGHT, toggled_on)
  GlobalPopup.update_popup()
  %HintButton.get_node("TextureRect").modulate = Color.GREEN if toggled_on else Color.RED

func _on_fade_overlay_on_complete_fade_out():
  get_tree().change_scene_to_file("res://scenes/MainMenuScene.tscn")

func _on_clue_discovered(clue_label: String, clue_type: Clue.Type):
  var empty_node = null
  var found = false
  for node in get_tree().get_nodes_in_group("clue"):
    if node.visible and node.label == clue_label and node.type == clue_type:
      found = true
    if empty_node == null and not node.visible:
      empty_node = node
  if not found and empty_node != null:
    empty_node.set_data(clue_label, clue_type)
    empty_node.visible = true
    $ClueOkJingle.play()
    _save_game()

func _restore_clue(group: String, data: Array):
  var index = 0
  for node in get_tree().get_nodes_in_group(group):
    node.set_data(data[index][1], data[index][0])
    node.visible = node.visible or not node.label.is_empty()
    index += 1

func _save_game():
  SaveGame.save_game(get_tree().get_nodes_in_group("clue"),
    get_tree().get_nodes_in_group("scroll_clue"),
    get_tree().get_nodes_in_group("identity_clue"),
    get_tree().get_nodes_in_group("other_clue"))

func _on_go_to(source: Node, destination: Node, keep_source_visible: bool):
  destination.visible = true
  source.visible = keep_source_visible

func _on_settings_out_gui_input(event):
  if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
    settings.visible = false

func _on_settings_return_button_pressed():
  settings.visible = false

func _on_credits_meta_clicked(meta):
  OS.shell_open(meta)

func _on_credits_popup_gui_input(event):
  if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
    exploring.visible = false
    thinking.visible = true
    credits.visible = false
