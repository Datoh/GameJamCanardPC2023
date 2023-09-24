extends Node

var current_popups = []

func show_popup(popup: Control):
  current_popups.push_back(popup)
  popup.popup_visible = true
  _manage_mouse_child(popup)

func hide_popup(popup: Control):
  var current_popup = current_popups.pop_back()
  assert(popup == null or popup == current_popup)
  current_popup.popup_visible = false
  _manage_mouse_child(current_popups.back() if not current_popups.is_empty() else null)

func update_popup():
  _manage_mouse_child(current_popups.back() if not current_popups.is_empty() else null)

func _manage_mouse_child(popup: Control):
  var show_highlight = UserSettings.get_value(UserSettings.SHOWHIGHLIGHT)
  for control in get_tree().get_nodes_in_group("area_highlight"):
    var parent = control
    var is_popup_child = parent == popup or popup == null
    while not is_popup_child and parent != null:
      parent = parent.get_parent()
      is_popup_child = is_popup_child || parent == popup
    control.mouse_filter = Control.MOUSE_FILTER_STOP if is_popup_child else Control.MOUSE_FILTER_IGNORE
    if "highlight" in control:
      control.highlight.visible = show_highlight and not control.hide_highlight and is_popup_child and control != popup
