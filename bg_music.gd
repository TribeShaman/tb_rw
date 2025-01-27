extends AudioStreamPlayer

var tracks = {
	1: preload("res://Sounds/Music/beat1.mp3"),
	2: preload("res://Sounds/Music/beat2.mp3")
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func change_music(level: int):
	if tracks.has(level):
		stream = tracks[level]  # Change the music track
		play()  # Play the selected track
