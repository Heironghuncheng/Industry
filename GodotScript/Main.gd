extends Node2D

var raid : int = 0

var hour : int = 0

var money : int = 0

func _ready():
	$Camera.start_menu()
		
func _physics_process(delta):
	if $Tiles.building_mode:
		if Input.is_action_just_pressed("ui_cancel"):
			$Tiles.building_mode = false
	if Input.is_action_just_pressed("Shutdown"):
		get_tree().quit()
	if Input.is_action_just_pressed("test"):
		save_data()
		
		
func _on_StartMenu_Begin():
	$Camera.game_start()
	$Timer.start()


func _on_UI_MachineBuilding():
	print("Machine")
	$Tiles.building_mode = true
	yield(get_tree().create_timer(0.1),"timeout")
	$Tiles.machine = $Camera/UI.machine_kind
	$Tiles.data_machine_kind = $Camera/UI.data_machine_kinds[$Camera/UI.data_machine_kind]
	$Tiles.arch = Vector2(0,0)


func _on_UI_ArchBuilding():
	print("Arch")
	$Tiles.building_mode = true
	yield(get_tree().create_timer(0.1),"timeout")
	$Tiles.arch = $Camera/UI.arch_kind
	$Tiles.machine = BuildingData.data_machines.None

func one_work_shop_sum(machines:Dictionary):
	var result : Dictionary = {"rate":0,"workers":0,"time":0}
	var shortest : int = 10
	for i in machines:
		var lenth = len(machines[i])
		if lenth == 0:
			return {"rate":0,"workers":0,"time":0}
		if shortest > lenth:
			shortest = lenth
	for i in range(shortest):
		for j in machines:
			var machine = machines[j][i]
			var percentage = machine.percentage
			result.rate += machine.rate * percentage
			result.workers += machine.workers * percentage
			result.time += machine.time * percentage
	return result

func multi_work_shops_sum(workshops:Array):
	var result : Dictionary = {"rate":0,"workers":0,"time":0}
	for i in workshops:
		var machines = {
		"AssemblyMachine":[],
		"ElectronBeamWeldingMachine":[],
		"OilSealTrimmingMachine":[],
		"ShotPeeningMachine":[],
		"SteelStripFurnace":[]
		}
		for j in i.get_children():
			if j.kind in machines.keys():
				machines[j.kind].append(j)
		var workshop = one_work_shop_sum(machines)
		result.rate += workshop.rate
		result.workers += workshop.workers
		result.time += workshop.time
	return result

func _on_Timer_timeout():
	var smallWorkShops = get_tree().get_nodes_in_group("smallWorkShops")
	var mediumWorkShops = get_tree().get_nodes_in_group("mediumWorkShops")
	var largeWorkShops = get_tree().get_nodes_in_group("largeWorkShops")
	var allWorkShops = [smallWorkShops,mediumWorkShops,largeWorkShops]
	var allWorkShopsResult : Dictionary = {"rate":0,"workers":0,"time":0}
	for i in allWorkShops:
		if i != []:
			var workshops = multi_work_shops_sum(i)
			allWorkShopsResult.rate += workshops.rate
			allWorkShopsResult.workers += workshops.workers
			allWorkShopsResult.time += workshops.time
	
func save_data():
	for i in $Tiles/WorkShops.get_children():
		print(i)
