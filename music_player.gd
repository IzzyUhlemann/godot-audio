extends AudioStreamPlayer


@export var loop_beat = 0
var curStream: AudioStream = null


func _ready():
	
	# Set reference to current file
	curStream = get("stream")
	
	# Set loop point to beginning of correct beat
	if !curStream.loop_offset && curStream.bpm:
		curStream.loop_offset = (60 * loop_beat) / curStream.bpm


func _on_finished():
	pass
