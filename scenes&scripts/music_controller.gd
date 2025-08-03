extends Node

@onready var title_music: AudioStreamPlayer = $title_music
@onready var gameplay_music: AudioStreamPlayer = $gameplay_music
@onready var crowd_groan: AudioStreamPlayer = $crowd_groan

func play_title_theme():
	gameplay_music.stop()
	title_music.play()
	
func play_gameplay_music():
	title_music.stop()
	gameplay_music.play()
	
func play_crowd_groan():
	crowd_groan.play()
	
