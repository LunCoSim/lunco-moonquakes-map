
extends Spatial

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_color(color=Color(0.92, 1, 1, 1.0)):
	var newMaterial = SpatialMaterial.new() #Make a new Spatial Material
	newMaterial.albedo_color = color #Set color of new material
#	newMaterial.emission_enabled = true
#	newMaterial.emission = Color(color) #Set color of new material
#	newMaterial.emission_energy = 1 #Set color of new material
	
	if $pin:
		$pin.material = newMaterial #Assign new material to material overrride

func set_text(text: String):
	$site.text = text


