extends Node

var frame_skip_arr: Array
var frame_sort_arr: Array
var frame_type_arr: Array

# So this is a funny one. I had some major performance issues and this solved 50% of them!
# I basically just made everything skip frames by an amount. To make sure it's evenly distributed,
# I made this singleton and let it distribute things evenly.

func get_frame_ticket(type, frame_skip):
	for i in frame_type_arr.size():
		if type != frame_type_arr[i]:
			break
		if frame_skip != frame_skip_arr[i]:
			break
		
		frame_sort_arr[i] += 1
		if (frame_sort_arr[i] + 1) > frame_skip:
			frame_sort_arr[i] = 0
		return frame_sort_arr[i]
	
	frame_type_arr.append(type)
	frame_sort_arr.append(0)
	frame_skip_arr.append(frame_skip)
	return 0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(0) # Do I even need this lol


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
