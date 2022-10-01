extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_color(color=Color(0.92, 1, 1, 1.0)):
	print("set_color")
	var newMaterial = SpatialMaterial.new() #Make a new Spatial Material
	newMaterial.albedo_color = color #Set color of new material
	$pin.material = newMaterial #Assign new material to material overrride
