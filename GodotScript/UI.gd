extends CanvasLayer

var ifRightBarOut : bool = false

var ifLeftBarOut : bool = false

var machine_kind : Dictionary = BuildingData.data_machines.None

var data_machine_kind : int = 0

const data_machine_kinds : Array = ["A","B","C"]

var arch_kind : Vector2 = Vector2(0,0)

var Speed : int = 0

signal ArchBuilding

signal MachineBuilding

signal SpeedChange

func _ready():
	pass # Replace with function body.

func _on_RightBar_mouse_exited():
	if ifRightBarOut:
		$RightBar/Scroll.play_backwards("scroll")
		yield(get_tree().create_timer(1),"timeout")
		ifRightBarOut = false

func _on_RightButton_pressed():
	if not ifRightBarOut:
		$RightBar/Scroll.queue("scroll")
		yield(get_tree().create_timer(1),"timeout")
		ifRightBarOut = true

func _on_Plus_pressed():
	if not ifLeftBarOut:
		$LevelBlock.visible = true
		$LeftBar/ShapeChange.queue("ShapeChange")
		yield(get_tree().create_timer(1),"timeout")
		ifLeftBarOut = true

func _on_LevelBlock_mouse_exited():
	if ifLeftBarOut:
		$LeftBar/ShapeChange.play_backwards("ShapeChange")
		yield(get_tree().create_timer(1),"timeout")
		ifLeftBarOut = false
		$LevelBlock.visible = false


func _on_AssemblyMachine_pressed():
	emit_signal("MachineBuilding")
	machine_kind = BuildingData.data_machines.assembly_machine

func _on_ElectronBeamWeldingMachine_pressed():
	emit_signal("MachineBuilding")
	machine_kind = BuildingData.data_machines.electron_beam_welding_machine

func _on_OilSealTrimmingMachine_pressed():
	emit_signal("MachineBuilding")
	machine_kind = BuildingData.data_machines.oil_seal_trimming_machine

func _on_ShotPeeningMachine_pressed():
	emit_signal("MachineBuilding")
	machine_kind = BuildingData.data_machines.shot_peening_machine

func _on_SteelStripFurnace_pressed():
	emit_signal("MachineBuilding")
	machine_kind = BuildingData.data_machines.steel_strip_furnace


func _on_Small_pressed():
	emit_signal("ArchBuilding")
	arch_kind = Vector2(11,10)
	print("small")


func _on_Medium_pressed():
	emit_signal("ArchBuilding")
	arch_kind = Vector2(12,13)
	print("medium")


func _on_Large_pressed():
	emit_signal("ArchBuilding")
	arch_kind = Vector2(13,14)
	print("large")


func _on_Menu_pressed():
	$ConfigurationPanel/ShowConfiguration.queue("FadeIn")
	$ConfigurationPanel.show()


func _on_Kind_pressed():
	data_machine_kind += 1 
	if data_machine_kind >= 3:
		data_machine_kind = 0
	$RightBar/ScrollContainer/VBoxContainer/Row_2/Kind.text = data_machine_kinds[data_machine_kind]


func _on_Button_pressed():
	emit_signal("SpeedChange")
	Speed += 1
	if Speed >= 4:
		Speed = 0
	
