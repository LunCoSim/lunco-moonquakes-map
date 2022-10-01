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

func _ready():
	#Make instance
	var mark = Mark.instance()
	#You could now make changes to the new instance if you wanted
	mark.translation = Vector3(0, 0, 1)
	
	#Attach it to the tree
#	self.add_child(mark)
	var r = 1
	
	for loc in apollos:
		var pin = Mark.instance()
		#You could now make changes to the new instance if you wanted
		
		var location: Vector3
		
		var phi = loc.x*to_rad - 3.14/2
		var theta = loc.y*to_rad
		
		location.z = r*sin(phi)*cos(theta)
		location.x = r*sin(phi)*sin(theta)
		location.y = r*cos(phi)
		
		pin.translation = location
		#Attach it to the tree
		$Moon.add_child(pin)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
