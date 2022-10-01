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

func _ready():
#	add_apollo_locations()
	
	moonquakes = LCDataSet.new()
#	moonquakes.load("res://assets/levent.1008weber.csv")
	moonquakes.load("res://assets/gagnepian_2006_catalog.csv")
	
	for row_idx in moonquakes.data[0].size():
		var lat = float(moonquakes.data[1][row_idx])
		var lon = float(moonquakes.data[2][row_idx])
		print(lat, lon)
		var pin = Mark.instance()
		#You could now make changes to the new instance if you wanted
		
		pin.translation = spherical_to_cartesian(1, lat, lon)
		
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
#func _process(delta):
#	pass
