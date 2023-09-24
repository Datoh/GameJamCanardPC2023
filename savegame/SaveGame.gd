## Script that manages saving games.
class_name SaveGame extends Node

const ENABLED = true
const ENCRYPTION_KEY = "godotrules"
const SAVE_GAME_TEMPLATE = "savegame.save"

static func delete_save() -> void:
  if not ENABLED:
    return
  DirAccess.remove_absolute("user://" + SAVE_GAME_TEMPLATE)

static func has_save() -> bool:
  return FileAccess.file_exists("user://" + SAVE_GAME_TEMPLATE)

static func _save_clues(clues: Array) -> Array:
  var array_clues = []
  for clue in clues:
    array_clues.push_back([clue.type, clue.label])
  return array_clues

static func save_game(clues: Array, scroll_clue: Array, identity_clue: Array, other_clue: Array):
  if not ENABLED:
    return

  var save_game_file = null
  if OS.is_debug_build():
    save_game_file = FileAccess.open("user://" + SAVE_GAME_TEMPLATE, FileAccess.WRITE)
  else:
    save_game_file = FileAccess.open_encrypted_with_pass("user://" + SAVE_GAME_TEMPLATE, FileAccess.WRITE, ENCRYPTION_KEY)

  var clues_array = _save_clues(clues)
  var scroll_clues_array = _save_clues(scroll_clue)
  var identity_clues_array = _save_clues(identity_clue)
  var other_clues_array = _save_clues(other_clue)
  
  save_game_file.store_line(JSON.stringify([clues_array, scroll_clues_array, identity_clues_array, other_clues_array]))


static func load_game() -> Array:
  if not ENABLED:
    return []

  if not has_save():
    print("No save game found. Skipped loading!")
    return []

  var save_game_file = null
  if OS.is_debug_build():
    save_game_file = FileAccess.open("user://" + SAVE_GAME_TEMPLATE, FileAccess.READ)
  else:
    save_game_file = FileAccess.open_encrypted_with_pass("user://" + SAVE_GAME_TEMPLATE, FileAccess.READ, ENCRYPTION_KEY)

  var string_data = ""
  while save_game_file.get_position() < save_game_file.get_length():
    string_data += save_game_file.get_line()

  if string_data.is_empty():
    return []

  var test_json_conv = JSON.new()
  test_json_conv.parse(string_data)
  return test_json_conv.get_data()
