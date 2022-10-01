extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

#https://nssdc.gsfc.nasa.gov/planetary/lunar/lunar_sites.html
var apollos = {
				"Apollo 11": Vector2(0.67416, 23.47314), 
				"Apollo 12": Vector2(-3.02, -23.42), 
				"Apollo 14": Vector2(-3.64589, -17.47194),
				"Apollo 15": Vector2(26.13239	, 3.63330), 
				"Apollo 16": Vector2(-8.9734, 15.5011),
				"Apollo 17": Vector2(20.1911, 30.7723)
			}
#Load the resourse using preload
const Mark = preload("res://models/mark.tscn")

const to_rad = 3.14/180

#const IVTableImporter := preload("res://addons/ivoyager/table_importer.gd")
const LCDataset := preload("res://addons/tools/dataset.gd")

var moonquakes

const DateTime := preload("res://addons/datetime/datetime.gd")

enum EventType {
	NATURAL_IMPACT,
	DEEP_MOONQAUKE,
	SHALLOW,
	ARTIFICIAL
}

var start_time = DateTime.new()
var current_time = start_time
var end_time = DateTime.new()

var speed = 24 #hours/sec
var speed_factor = 1

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

func _ready():
	add_apollo_locations()
	
	moonquakes = LCDataSet.new()
#	moonquakes.load("res://assets/levent.1008weber.csv")
	moonquakes.load("res://assets/gagnepian_2006_catalog.tsv")
	
	for row_idx in moonquakes.data[0].size():
		
		var type = get_event_type(moonquakes.data[0][row_idx])
		var lat = float(moonquakes.data[1][row_idx])
		var lon = float(moonquakes.data[2][row_idx])
		
		var depth = float(moonquakes.data[3][row_idx])
		
		var date = to_datetime(moonquakes.data[4][row_idx])
	
		var pin = Mark.instance()
		#You could now make changes to the new instance if you wanted
		
		pin.translation = spherical_to_cartesian(1+depth/10000, lat, lon)
		pin.set_color(colors[type])
		pin.set_text(event_types_text[type] + ": " + date.to_string())
		#Attach it to the tree
		$Moon.add_child(pin)
	
func add_apollo_locations():
	var r = 1
	
	for key in apollos:
		var pin = Mark.instance()
#		pin.pin.material.albedo = RGB()
		#You could now make changes to the new instance if you wanted
		var loc = apollos[key]
		pin.translation = spherical_to_cartesian(r, loc.x, loc.y)
		pin.set_text(key)
		#Attach it to the tree
		$Moon.add_child(pin)

static func spherical_to_cartesian(r, phi_degrees, theta_degrees):
	var location := Vector3.ZERO
		
	var phi = phi_degrees*to_rad - 3.14/2
	var theta = theta_degrees*to_rad
	
	location.z = r*sin(phi)*cos(theta)
	location.x = r*sin(phi)*sin(theta)
	location.y = r*cos(phi)
	
	return location
	
# Called every frame. 'delta' is the elapsed time since the previous frame.



#func _process(delta):
#	pass
