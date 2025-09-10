class_name FileHelper

const STRATAGEM_PATH = "res://Stratagems/"

static func get_files(path: String, deep: bool = false, full_path: bool = true) -> Array:
	var files = []
	
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin(true)
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir() and deep:
				#print(path + file_name)
				files.append_array(get_files(path + file_name, deep, full_path))
			if !dir.current_is_dir():
				if full_path:
					file_name = path + "/" + file_name
				files.append(file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	
	return files


static func load_all_stratagems() -> Array:
	var stratagems = []
	
	var stratagem_files = get_files(STRATAGEM_PATH, true)
	for stratagem_file in stratagem_files:
		var stratagem = ResourceLoader.load(stratagem_file)
		if stratagem is Stratagem and stratagem_valid(stratagem, stratagem_file):
			stratagems.append(stratagem)
	
	return stratagems

static func stratagem_valid(stratagem: Stratagem, file_name: String = "") -> bool:
	var valid = true
	
	if stratagem.name == null or stratagem.name == "":
		valid = false
		var name_error = "Stratagem name must be defined"
		if file_name != "":
			name_error = name_error + ", file name: %s" % file_name
		printerr(name_error)
	
	if stratagem.icon == null:
		valid = false
		var icon_error = "Stratagem icon must be defined"
		if file_name != "":
			icon_error = icon_error + ", file name: %s" % file_name
		printerr(icon_error)
	
	if stratagem.code == null or stratagem.code.size() == 0:
		valid = false
		var code_error = "Stratagem code must be defined"
		if file_name != "":
			code_error = code_error + ", file name: %s" % file_name
		printerr(code_error)
	
	return valid
