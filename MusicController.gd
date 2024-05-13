extends Node


var stream_array = []
var cur_track
var track_num

func _ready():

	# populate array of game music
	for i in get_children():
		if i.get_class() == "AudioStreamPlayer":
			stream_array.append(i)
			
			if i.playing:
				cur_track = i
				track_num = stream_array.bsearch(i)
			else:
				cur_track = null
				track_num = 0
				

func _unhandled_input(event):
	# if player hits up, cycle to the next track
	if event.is_action_pressed("up"):
		find_beat(true)
	if event.is_action_pressed("down"):
		find_beat(false)


func find_beat(b_add):
	var next_beat
	var next_beat_time
	var crossfade_timer
	
	# If playing a track, find next beat and stop track once we reach it
	if cur_track == null:
		print("Current track not found!")
		cur_track = stream_array[0]
	elif cur_track.playing:
		# find next beat from cur track position and bpm
		next_beat = ceil((cur_track.get_playback_position() * cur_track.stream.bpm) / 60)
		next_beat_time = (60 * next_beat) / cur_track.stream.bpm
		print(next_beat_time)
			
		# create a timer that fires as soon as the current beat ends
		await get_tree().create_timer(next_beat_time - cur_track.get_playback_position()).timeout
		print(next_beat_time - cur_track.get_playback_position())
	
	if (b_add):
		add_track(cur_track, stream_array[(track_num + 1) % stream_array.size()], 0)
		track_num = (track_num + 1) % stream_array.size()
	else:
		remove_track(cur_track, stream_array[(track_num - 1) % stream_array.size()], 0)
		track_num = (track_num - 1) % stream_array.size()
	
	cur_track = stream_array[track_num]
	
	print(cur_track)


func remove_track(current, next, fade_time):
	#var tween = get_tree().create_tween().set_parallel(true)
	#tween.set_trans(Tween.TRANS_QUART)

	#next.volume_db = -20
	cur_track.stop()

	#tween.tween_property(current, "volume_db", -80, (fade_time))
	#tween.tween_property(next, "volume_db", 0, fade_time)

func add_track(current, next, fade_time):
	#var tween = get_tree().create_tween().set_parallel(true)
	#tween.set_trans(Tween.TRANS_QUART)

	#next.volume_db = -20
	next.play(cur_track.get_playback_position())

	#tween.tween_property(current, "volume_db", -80, (fade_time))
	#tween.tween_property(next, "volume_db", 0, fade_time)
