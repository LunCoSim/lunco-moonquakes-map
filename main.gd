extends Node


#https://nssdc.gsfc.nasa.gov/planetary/lunar/lunar_sites.html
const apollos = {
				"Apollo 11": Vector2(0.67416, 23.47314), 
				"Apollo 12": Vector2(-3.02, -23.42), 
				"Apollo 14": Vector2(-3.64589, -17.47194),
				"Apollo 15": Vector2(26.13239	, 3.63330), 
				"Apollo 16": Vector2(-8.9734, 15.5011),
				"Apollo 17": Vector2(20.1911, 30.7723)
			}

const to_rad = 3.14/180

#Load the resourse using preload
const Mark = preload("res://models/mark.tscn")
const MarkApollo = preload("res://models/mark_apollo.tscn")
const LCDataset := preload("res://addons/tools/dataset.gd")
const DateTime := preload("res://addons/datetime/datetime.gd")

#--------------
enum EventType {
	NATURAL_IMPACT,
	DEEP_MOONQAUKE,
	SHALLOW,
	ARTIFICIAL
}

var colors = {
	EventType.NATURAL_IMPACT: Color(0.5, 0.5, 0.5, 1),
	EventType.DEEP_MOONQAUKE: Color(1, 0.5, 0.5, 1),
	EventType.SHALLOW: Color(0.5, 1, 0.5, 1),
	EventType.ARTIFICIAL: Color(0.5, 0.5, 1, 1)
}

var event_types_text = {
	EventType.NATURAL_IMPACT: "Natural",
	EventType.DEEP_MOONQAUKE: "Deep",
	EventType.SHALLOW: "Shallow",
	EventType.ARTIFICIAL: "Artificial"
}

#------------------------------------

var moonquakes

var dates = []
var marks = []

var start_time = DateTime.new()
var current_time = start_time
var end_time = DateTime.new()

var speed = 60*5 #hours/sec
var speed_factor = 1

var counter = 0
var paused = true
var is_dragging = false

#------------------------------

func get_event_type(event_type: String):
	#based on https://pds-geosciences.wustl.edu/lunar/urn-nasa-pds-apollo_seismic_event_catalog/data/gagnepian_2006_catalog.xml
	if event_type == "M":
		return EventType.NATURAL_IMPACT
	elif "A" in event_type:
		return EventType.DEEP_MOONQAUKE
	elif event_type == "SH":
		return EventType.SHALLOW
	else:
		return EventType.ARTIFICIAL

func to_datetime(datetime_str: String):
	var dt = {
		"year": int("19" + datetime_str.substr(0, 2)),
		"month": int(datetime_str.substr(2, 2)),
		"day": int(datetime_str.substr(4, 2)),
		"hour": int(datetime_str.substr(6, 2)),
		"minute": int(datetime_str.substr(8, 2))
	}
	
	return DateTime.datetime(dt)

static func spherical_to_cartesian(r, phi_degrees, theta_degrees):
	var location := Vector3.ZERO
		
	var phi = phi_degrees*to_rad - 3.14/2
	var theta = theta_degrees*to_rad
	
	location.z = r*sin(phi)*cos(theta)
	location.x = r*sin(phi)*sin(theta)
	location.y = r*cos(phi)
	
	return location
	
#=---------------

func _ready():
	$UI/Speed.text = String(speed)
	add_apollo_locations()
	add_moonquakes_locations()


func add_moonquakes_locations():
	moonquakes = LCDataSet.new()
	moonquakes.load("res://assets/gagnepian_2006_catalog.tsv")
	
	for row_idx in moonquakes.data[0].size():
		
		var type = get_event_type(moonquakes.data[0][row_idx])
		var lat = float(moonquakes.data[1][row_idx])
		var lon = float(moonquakes.data[2][row_idx])
		
		var depth = float(moonquakes.data[3][row_idx])
		
		var date = to_datetime(moonquakes.data[4][row_idx])
		dates.append(date)
		if row_idx == 0:
			start_time = date
			end_time = date
		
		if 	date._total_sec() > end_time._total_sec():
			end_time = date
		
		var pin = Mark.instance()
		
		pin.translation = spherical_to_cartesian(1+depth/10000, lat, lon)
		pin.set_color(colors[type])
		pin.set_text(String(row_idx) + " " +event_types_text[type] + ": " + date.to_string())
		
		#Attach it to the tree
		$Moon.add_child(pin)
		marks.append(pin)
	
	
	current_time = start_time.add_minutes(0)
	
func add_apollo_locations():
	var r = 1
	
	for key in apollos:
		var pin = MarkApollo.instance()
#		pin.pin.material.albedo = RGB()
		#You could now make changes to the new instance if you wanted
		var loc = apollos[key]
		pin.translation = spherical_to_cartesian(r, loc.x, loc.y)
		pin.set_text(key)
		#Attach it to the tree
		$Moon.add_child(pin)


	
#-----------------------


func update_ui():
	$UI/StartTime.text = "Start: " + start_time.to_string()
	$UI/CurrentTime.text = "Current: " + current_time.to_string()
	$UI/EndTime.text = "End: " + end_time.to_string()
	
	for idx in marks.size():
		var res = DateTime.compare(dates[idx], current_time)
		
		if res <= 0:
			marks[idx].visible = true
		else:
			marks[idx].visible = false
	
	var s = start_time._total_sec()
	var e = end_time._total_sec()
	var c = current_time._total_sec()
	
#	print(s)
	
	if not is_dragging:
		$UI/TimeLine.value = (float(c-s)/float(e-s))*100
	


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	counter += 1
	
	if not paused:
		current_time = current_time.add_minutes(int(delta*speed))
		if current_time._total_sec() > end_time._total_sec():
			current_time = end_time.add_seconds(0)
	
	if counter % 1 == 0:
		update_ui()

#------------------------

func _on_TimeLine_drag_ended(value):
	is_dragging = false
	print($UI/TimeLine.value)

func _on_TimeLine_drag_started():
	is_dragging = true

func _on_Play_pressed():
	paused = not paused

func _on_Speed_text_changed():
	speed = int($UI/Speed.text)
