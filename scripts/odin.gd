extends Node



var save_dictionary
const save_path = "user://monsterRanger.save"

var niveles=[
	#nivel 1 Intro Limo rosa + dragon
	{'rondas':
		[
		[['pinkblob/PinkBlob',0,0]],
		[['pinkblob/PinkBlob',0,0],['pinkblob/PinkBlob',3,3],['pinkblob/PinkBlob',-3,-3]],
		[['dragon/Dragon',0,0,25]]
		],
		'stars':[150,70,45],
		'tuto':1
	},
	#nivel2 Conejos Runner
	{'rondas':
		[
		[['bunny/Bunny',0,0,15]],
		[['bunny/Bunny',0,0,10],['bunny/Bunny',5,5,10],['bunny/Bunny',-5,-5,10]]
		]
		,'stars':[120,60,30]
	},
	#nivel3 Dragones
	{'rondas':
		[
		[['dragon/Dragon',0,0,12],['dragon/Dragon',0,3,12],['dragon/Dragon',0,-3,12]],
		[['dragon2/Dragon2',0,0,35]],
		]
		,'stars':[150,100,50]
	},
	#nivel4 mucho limo
	{'rondas':
		[
		[
			['pinkblob/PinkBlob', -6, -6, 1],
			['pinkblob/PinkBlob', -6, -3, 1],
			['pinkblob/PinkBlob', -6, 0, 1],
			['pinkblob/PinkBlob', -6, 3, 1],
			['pinkblob/PinkBlob', -6, 6, 1],
			['pinkblob/PinkBlob', -3, -6, 1],
			['pinkblob/PinkBlob', -3, -3, 1],
			['pinkblob/PinkBlob', -3, 0, 1],
			['pinkblob/PinkBlob', -3, 3, 1],
			['pinkblob/PinkBlob', -3, 6, 1],
			['pinkblob/PinkBlob', 0, -6, 1],
			['pinkblob/PinkBlob', 0, -3, 1],
			['pinkblob/PinkBlob', 0, 0, 1],
			['pinkblob/PinkBlob', 0, 3, 1],
			['pinkblob/PinkBlob', 0, 6, 1],
			['pinkblob/PinkBlob', 3, -6, 1],
			['pinkblob/PinkBlob', 3, -3, 1],
			['pinkblob/PinkBlob', 3, 0, 1],
			['pinkblob/PinkBlob', 3, 3, 1],
			['pinkblob/PinkBlob', 3, 6, 1],
			['pinkblob/PinkBlob', 6, -6, 1],
			['pinkblob/PinkBlob', 6, -3, 1],
			['pinkblob/PinkBlob', 6, 0, 1],
			['pinkblob/PinkBlob', 6, 3, 1],
			['pinkblob/PinkBlob', 6, 6, 1]
		],
		]
		,'stars':[150,100,70]
	},
	#nivel5 gran final
	{'rondas':
		[
		[['dragon2/Dragon2',0,0,100]],
		]
		,'stars':[100,50,30]
	}
]

func save(level,stars):
	load_data()
	print("Level "+ str(level)+ "Stars "+str(stars))
	if save_dictionary['scores'].has(str(level)) and save_dictionary['scores'][str(level)] < stars:
		save_dictionary['scores'][str(level)]=stars
		save_data()
	else:
		save_dictionary['scores'][str(level)]=stars
		save_data()

func save_data():
	var json_string = to_json(save_dictionary)
	var save_file = File.new()
	save_file.open(save_path, File.WRITE)
	save_file.store_line(json_string)
	save_file.close()
	
func load_data():
	var save_file = File.new()
	if save_file.file_exists(save_path) == true:
		save_file.open(save_path, File.READ)
		var json_string = save_file.get_line()
		save_file.close()
		save_dictionary = parse_json(json_string)
	else:
		print("no save")
		save_dictionary = {
			"scores" : {},
		}
