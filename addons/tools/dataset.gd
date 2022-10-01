class_name LCDataSet
extends Reference



# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var data := {}
export var columns = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func load(path: String):
	var file := File.new()
	if file.open(path, file.READ) != OK:
		assert(false, "Could not open file: " + path)
	
	var reading_header := true
	
	var line := file.get_line()
	while !file.eof_reached():
		if line.begins_with("#"):
			line = file.get_line()
			continue
		var line_array := line.split(",") as Array
		
		if reading_header:
			reading_header = false
			columns = line_array
			for cell_id in line_array.size():
				data[cell_id] = []
#			print(columns)	
		else:
#			print(line_array)
			for cell_id in line_array.size():
				if cell_id < data.size():
					data[cell_id].append(line_array[cell_id])
				
		line = file.get_line()
