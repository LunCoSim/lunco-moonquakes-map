extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

#https://nssdc.gsfc.nasa.gov/planetary/lunar/lunar_sites.html
var apollos = [
				Vector2(0.67416, 23.47314), 
				Vector2(-3.02, -23.42), 
				Vector2(-3.64589, -17.47194),
				Vector2(26.13239	, 3.63330), 
				Vector2(-8.9734, 15.5011),
				Vector2(20.1911, 30.7723)
			]
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

func get_event_type(event_type):
	#based on https://pds-geosciences.wustl.edu/lunar/urn-nasa-pds-apollo_seismic_event_catalog/data/gagnepian_2006_catalog.xml
	if event_type == "M":
		return EventType.NATURAL_IMPACT
	elif "A" in event_type:
		return EventType.DEEP_MOONQAUKE
	elif event_type == "SH":
		return EventType.SHALLOW
	else:
		return EventType.ARTIFICIAL

var colors = {
	EventType.NATURAL_IMPACT: Color(0.5, 0.5, 0.5, 1),
	EventType.DEEP_MOONQAUKE: Color(1, 0.5, 0.5, 1),
	EventType.SHALLOW: Color(0.5, 1, 0.5, 1),
	EventType.ARTIFICIAL: Color(0.5, 0.5, 1, 1)
}

func _ready():
#	add_apollo_locations()
	
	moonquakes = LCDataSet.new()
#	moonquakes.load("res://assets/levent.1008weber.csv")
	moonquakes.load("res://assets/gagnepian_2006_catalog.csv")
	
	for row_idx in moonquakes.data[0].size():
		
		var type = get_event_type(moonquakes.data[0][row_idx])
		var lat = float(moonquakes.data[1][row_idx])
		var lon = float(moonquakes.data[2][row_idx])
		
		var depth = float(moonquakes.data[3][row_idx])
		
		var date = int(moonquakes.data[4][row_idx])
		
		print(type)
		var pin = Mark.instance()
		#You could now make changes to the new instance if you wanted
		
		pin.translation = spherical_to_cartesian(1+depth/100, lat, lon)
		pin.set_color(colors[type])
		#Attach it to the tree
		$Moon.add_child(pin)
	
func add_apollo_locations():
	var r = 1
	
	for loc in apollos:
		var pin = Mark.instance()
#		pin.pin.material.albedo = RGB()
		#You could now make changes to the new instance if you wanted
		
		pin.translation = spherical_to_cartesian(r, loc.x, loc.y)
		
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

var speed = 24 #hours/sec

var current_time = 0

#func _process(delta):
#	pass
