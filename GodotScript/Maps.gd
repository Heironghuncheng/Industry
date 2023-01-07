extends Node2D

# long term numbers
var numSmallWorkShop : int = 0

var numMediumWorkShop : int = 0

var numLargeWorkShop : int = 0

# all the tiles which have buildings on them
#var tilesWithBuildings : Array

# size of a tile
const tileSize : int = 32

# all the tiles in the game
#onready var allTiles : Array = get_tree().get_nodes_in_group("Tiles")

onready var hoverdTiles : Array = get_tree().get_nodes_in_group("Hover")

onready var lastHoverdTiles : Array = get_tree().get_nodes_in_group("Hover")

onready var pressedTiles : Array = get_tree().get_nodes_in_group("Pressed")

var machine : Dictionary = BuildingData.data_machines.None

var data_machine_kind : String = "A"

var arch : Vector2 = Vector2(0,0)

var building_mode : bool = false

var raid : int = 0

const wallType : String = "Machines/Wall"


func _ready():
	sort_by_position()


class MyCustomSorter:
	static func sort_ascending(a, b):
		if a.position[0] < b.position[0]:
			return true
		return false


func sort_by_position():
	var allTiles : Array = get_tree().get_nodes_in_group("Tiles")
	var a : Array = []
	# 34行
	for x in range(0,34):
		a.append([])
		for y in allTiles:
			if y.position[1] == 16 + tileSize * x:
				a[x].append(y)
		a[x].sort_custom(MyCustomSorter,"sort_ascending")
	allTiles.clear()
	for x in range(0,34):
		for y in range(a[x].size()):
			a[x][y].name = str(x) + "_" + str(y)
			allTiles.append(a[x][y])


func location_raid_transform(num_x:int,i:int,num_y:int,j:int,rotate:int):
	if rotate == 0:
		return str(num_x + i) + "_" + str(num_y + j)
	if rotate == 1:
		return str(num_x + j) + "_" + str(num_y + i)
	if rotate == 2:
		return str(num_x - i) + "_" + str(num_y - j)
	if rotate == 3:
		return str(num_x - j) + "_" + str(num_y - i)


func get_property_nodelist_machine(row: int,column: int,rotate: int,Tile):
	var place_list = []
	var num_x = int(Tile.name.split("_")[0])
	var num_y = int(Tile.name.split("_")[1])
	for i in range(row):
		for j in range(column):
			if get_node(location_raid_transform(num_x,i,num_y,j,rotate)):
				place_list.append(get_node(location_raid_transform(num_x,i,num_y,j,rotate)))
	return place_list


# highlights the tiles we can place buildings on
func highlight_available_tiles_machine (row:int,column:int,raid:int):
	# rotate 0,1,2,3
	var num_x = 0
	var num_y = 0
	var if_place : bool = true
	var lastRaid : int = raid - 1
	if lastRaid < 0: 
		lastRaid = 3
	if lastHoverdTiles != []:
		for i in get_property_nodelist_machine(row,column,raid,lastHoverdTiles[0]):
			i.turn_highlight(false)
	if hoverdTiles != [] and lastHoverdTiles != []:
		var nodelist = get_property_nodelist_machine(row,column,raid,hoverdTiles[0])
		for i in get_property_nodelist_machine(row,column,lastRaid,hoverdTiles[0]):
			i.turn_highlight(false)
		if len(nodelist) == row * column:
			for i in nodelist:
				if not i.placed and hoverdTiles[0].circled:
					i.turn_highlight(true,"blue")
				else:
					if_place = false
					i.turn_highlight(true,"red")
		else: 
			if_place = false
			for i in nodelist:
				i.turn_highlight(true,"red")
	else:
		if_place = false
	return if_place


func place_machine(machine: Dictionary,raid: int):
	if highlight_available_tiles_machine(machine.row,machine.column,raid):
		pressedTiles = get_tree().get_nodes_in_group("Pressed")
		if pressedTiles != []:
			for i in get_property_nodelist_machine(machine.row,machine.column,raid,hoverdTiles[0]):
				i.turn_highlight(false)
			var rows = 0
			var columns = 0
			for i in get_property_nodelist_machine(machine.row,machine.column,raid,pressedTiles[0]):
				rows += i.position.x
				columns += i.position.y
				i.placed = true
			var newBuilding = get_node(machine.type).duplicate()
			newBuilding.position.x = rows / machine.row / machine.column
			newBuilding.position.y = columns / machine.row / machine.column
			newBuilding.rotation_degrees += 90 * raid
			newBuilding.name += "_" + str(position.x) + "_" + str(position.y)
			newBuilding.rate = machine.kinds[data_machine_kind][0]
			newBuilding.workers = machine.kinds[data_machine_kind][1]
			newBuilding.time = machine.kinds[data_machine_kind][2]
			pressedTiles[0].owned.add_child(newBuilding)
			building_mode = false
			return 0
		else:
			return raid
	else:
		return raid


func get_property_nodelist_arch(width : int,lenth: int,rotate: int,Tile):
	var place_list = []
	var num_x = int(Tile.name.split("_")[0])
	var num_y = int(Tile.name.split("_")[1])
	for i in range(width):
		if i == 0 or i == width - 1:
			for j in range(lenth):
				if get_node(location_raid_transform(num_x,i,num_y,j,rotate)):
					place_list.append(get_node(location_raid_transform(num_x,i,num_y,j,rotate)))
		else:
			if get_node(location_raid_transform(num_x,i,num_y,0,rotate)):
				place_list.append(get_node(location_raid_transform(num_x,i,num_y,0,rotate)))
			if get_node(location_raid_transform(num_x,i,num_y,lenth - 1,rotate)):
				place_list.append(get_node(location_raid_transform(num_x,i,num_y,lenth - 1,rotate)))
	return place_list


func highlight_available_tiles_arch (width:int,lenth:int,raid:int):
	# rotate 0,1,2,3
	var num_x = 0
	var num_y = 0
	var if_place : bool = true
	var lastRaid : int = raid - 1
	if lastRaid < 0: 
		lastRaid = 3
	if lastHoverdTiles != []:
		for i in get_property_nodelist_arch(width,lenth,raid,lastHoverdTiles[0]):
			i.turn_highlight(false)
	if hoverdTiles != [] and lastHoverdTiles != []:
		var nodelist = get_property_nodelist_arch(width,lenth,raid,hoverdTiles[0])
		for i in get_property_nodelist_arch(width,lenth,lastRaid,hoverdTiles[0]):
			i.turn_highlight(false)
		if len(nodelist) == width * 2 + lenth * 2 - 4:
			for i in nodelist:
				if not i.placed:
					i.turn_highlight(true,"blue")
				else:
					if_place = false
					i.turn_highlight(true,"red")
		else:
			if_place = false
			for i in nodelist:
				i.turn_highlight(true,"red")
	else:
		if_place = false
	return if_place

	
func number_raid_transform(x:int, y:int, rotate:int):
	if rotate == 0:
		return [x,y]
	if rotate == 1:
		return [y,x]
	if rotate == 2:
		return [-x,-y]
	if rotate == 3:
		return [-y,-x]

	
func place_arch(width:int, lenth:int, raid:int):
	if highlight_available_tiles_arch(width,lenth,raid):
		pressedTiles = get_tree().get_nodes_in_group("Pressed")
		if pressedTiles != []:
			var newWorkShop = Node2D.new()
			print(width)
			if lenth == 10:
				numSmallWorkShop += 1
				newWorkShop.name = "SmallWorkShop" + str(numSmallWorkShop)
				newWorkShop.add_to_group("smallWorkShops")
			elif lenth == 13:
				numMediumWorkShop += 1
				newWorkShop.name = "MediumWorkShop" + str(numMediumWorkShop)
				newWorkShop.add_to_group("mediumWorkShops")
			elif lenth == 14:
				numLargeWorkShop += 1
				newWorkShop.name = "LargeWorkShop" + str(numLargeWorkShop)
				newWorkShop.add_to_group("largeWorkShops")
			var num_x = int(pressedTiles[0].name.split("_")[0])
			var num_y = int(pressedTiles[0].name.split("_")[1])
			for i in range(width):
				if i == 0:
					for j in range(lenth):
						var wall = get_node(wallType).duplicate()
						if j == 0:
							wall.get_node("Icon").texture = BuildingData.wall1110
						elif j == lenth - 1:
							wall.get_node("Icon").texture = BuildingData.wall1101
						else:
							wall.get_node("Icon").texture = BuildingData.wall1100
						var posModify = number_raid_transform(j,i,raid)
						wall.position.x = pressedTiles[0].position.x + posModify[0] * tileSize
						wall.position.y = pressedTiles[0].position.y + posModify[1] * tileSize
						wall.name = "wall" + str(j) + str(i)
						newWorkShop.add_child(wall)
				elif i == width - 1:
					for j in range(lenth):
						var wall = get_node(wallType).duplicate()
						if j == 0:
							wall.get_node("Icon").texture = BuildingData.wall1011
						elif j == lenth - 1:
							wall.get_node("Icon").texture = BuildingData.wall0111
						else:
							wall.get_node("Icon").texture = BuildingData.wall1100
							wall.rotation_degrees = 180
						var posModify = number_raid_transform(j,i,raid)
						wall.position.x = pressedTiles[0].position.x + posModify[0] * tileSize
						wall.position.y = pressedTiles[0].position.y + posModify[1] * tileSize
						wall.name = "wall" + str(j) + str(i)
						newWorkShop.add_child(wall)
				else:
					for j in range(2):
						var wall = get_node(wallType).duplicate()
						wall.get_node("Icon").texture = BuildingData.wall1010
						if j == 1:
							var posModify = number_raid_transform(lenth - 1,i,raid)
							wall.position.x = pressedTiles[0].position.x + posModify[0] * tileSize
							wall.position.y = pressedTiles[0].position.y + posModify[1] * tileSize
							wall.rotation_degrees = 180
							wall.name = "wall" + str(lenth - 1) + str(i)
						else:
							var posModify = number_raid_transform(j,i,raid)
							wall.position.x = pressedTiles[0].position.x + posModify[0] * tileSize
							wall.position.y = pressedTiles[0].position.y + posModify[1] * tileSize
							wall.name = "wall" + str(j) + str(i)
						newWorkShop.add_child(wall)
			for i in get_property_nodelist_arch(width,lenth,raid,pressedTiles[0]):
				i.turn_highlight(false)
				i.placed = true
			for i in range(width):
				for j in range(lenth):
					var node = get_node(str(j + num_x) + "_" + str(i + num_y))
					node.circled = true
					node.owned = newWorkShop
			$WorkShops.add_child(newWorkShop)
			building_mode = false
			return 0
		else:
			return raid
	else:
		return raid


func _physics_process(delta):
	lastHoverdTiles = hoverdTiles
	hoverdTiles = get_tree().get_nodes_in_group("Hover")
	if building_mode:
		if machine != BuildingData.data_machines.None:
			if Input.is_action_just_pressed("rotate_building"):
				raid += 1
				if raid > 3:
					raid = 0
			raid = place_machine(machine,raid)
		elif arch != Vector2(0,0):
#			if Input.is_action_just_pressed("rotate_building"):
#				raid += 1
#				if raid > 3:
#					raid = 0
			raid = place_arch(arch[0],arch[1],raid)
		else:
			print("assert error")
	else:
		if machine != BuildingData.data_machines.None:
			for i in get_property_nodelist_machine(machine.row,machine.column,0,hoverdTiles[0]):
				i.turn_highlight(false)
			for i in get_property_nodelist_machine(machine.row,machine.column,2,hoverdTiles[0]):
				i.turn_highlight(false)
			machine = BuildingData.data_machines.None
		elif arch != Vector2(0,0):
			for i in get_property_nodelist_arch(arch[0],arch[1],0,hoverdTiles[0]):
				i.turn_highlight(false)
			arch = Vector2(0,0)

#		else:
#			print("assert error")
