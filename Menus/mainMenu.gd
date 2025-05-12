extends Node
onready var botonLevel= preload("res://Menus/levelButton.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	load_data()
	generateLevels()



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_exit_pressed():
	self.get_tree().quit()


func _on_ranking_pressed():
	pass # Replace with function body.


func _on_level_pressed():
	$Popup.popup()

func _on_credits_pressed():
	$Popup2.popup()

func _on_archivements_pressed():
	pass # Replace with function body.


##Generate Levels


func generateLevels():
	var niveles = get_parent().niveles
	for i in range(len(niveles)):
		var nivel=botonLevel.instance()
		nivel.text=" lvl"+str(i+1)+" "
		nivel.nivelInfo=niveles[i]
		nivel.nivelId=i+1

		if(save_dictionary['scores'].has(str(i+1))):
			nivel.stars=int(save_dictionary['scores'][str(i+1)])
		$"Popup/ratio/margin/GridContainer".add_child(nivel)

	




####SAVEGAME SYSTEM

var save_dictionary = {
"scores" : {},
}

const save_path = "user://monsterRanger.save"

func load_data():
	var save_file = File.new()
	if save_file.file_exists(save_path) == true:
		save_file.open(save_path, File.READ)
		var json_string = save_file.get_line()
		save_file.close()
		save_dictionary = parse_json(json_string)
		print("SAVEGAME:")
		print(save_dictionary)
	else:
		print("no save")


	


