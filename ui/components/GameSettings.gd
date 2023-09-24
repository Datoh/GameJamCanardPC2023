extends VBoxContainer

@onready var master_volume_slider := %MasterVolumeSlider
@onready var music_volume_slider := %MusicVolumeSlider
@onready var sound_volume_slider := %SoundVolumeSlider
@onready var fullscreen_check_box := %FullscreenCheckBox

func _ready():
  master_volume_slider.value = UserSettings.get_value(UserSettings.GLOBALVOLUME)
  music_volume_slider.value = UserSettings.get_value(UserSettings.MUSICVOLUME)
  sound_volume_slider.value = UserSettings.get_value(UserSettings.SOUNDVOLUME)
  fullscreen_check_box.button_pressed = UserSettings.get_value(UserSettings.FULLSCREEN)

func _on_master_volume_slider_value_changed(value):
  UserSettings.set_value(UserSettings.GLOBALVOLUME, value)

func _on_music_volume_slider_value_changed(value):
  UserSettings.set_value(UserSettings.MUSICVOLUME, value)

func _on_sound_volume_slider_value_changed(value):
  UserSettings.set_value(UserSettings.SOUNDVOLUME, value)

func _on_fullscreen_check_box_toggled(toggled_on):
  UserSettings.set_value(UserSettings.FULLSCREEN, toggled_on)
