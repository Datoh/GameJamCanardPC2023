extends Control

var correct_scroll = null
var correct_identity = null
var correct_other = null

signal clue_discovered(clue_label: String, clue_type: Clue.Type)

func _on_clue_discovered(clue_label: String, clue_type: Clue.Type):
  clue_discovered.emit(clue_label, clue_type)

func _ready():
  #var correct_scrolls = [
    #["frappé", "Igor", "Gaudotine", "lingot"],
    #["frappé", "Sue-Ellen", "Refill", "bouteille"],
    #["frappé", "A", "Bout", "raquette"],
    #["frappé", "Zi", "Zivara", "marteau"],
    #["frappé", "JB", "Bouton", "livre"],
  #]
  correct_scroll = ["frappé", "Zi", "Zivara", "marteau"]
  correct_identity = [
    "Sue-Ellen", "Refill", "bouteille",
    "A", "Bout", "raquette",
    "JB", "Bouton", "livre",
    "Igor", "Gaudotine", "lingot",
    "Zi", "Zivara", "marteau"]
  correct_other = [
    "A", "Bout",
    "Zi", "Zivara",
    "Sue-Ellen", "Refill",
    "JB", "Bouton",
    "Igor", "Gaudotine", "enferme", "rédacteurs"]
