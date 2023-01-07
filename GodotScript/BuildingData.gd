extends Node2D

# var base = Building.new(0, preload("res://Sprites/Base.png"), 0, 0, 0, 0)
# var mine = Building.new(1, preload("res://Sprites/Mine.png"), 2, 1, 4, 1)
# var greenhouse = Building.new(2, preload("res://Sprites/Greenhouse.png"), 1, 1, 0, 0)
# var solarpanel = Building.new(3, preload("res://Sprites/SolarPanel.png"), 4, 1, 0, 0)

var data_machines = {
	"steel_strip_furnace": {
		"row": 2,
		"column": 4,
		"type": "Machines/SteelStripFurnace",
		"kinds":{
			"A": [0.9,8,5],
			"B": [0.85,6,5],
			"C": [0.6,6,2]
		}
	},
	"assembly_machine": {
		"row": 2,
		"column": 4,
		"type": "Machines/AssemblyMachine",
		"kinds":{
			"A": [0.98,8,4],
			"B": [0.9,6,4.5],
			"C": [0.85,6,3]
		}
	},
	"electron_beam_welding_machine": {
		"row": 2,
		"column": 2,
		"type": "Machines/ElectronBeamWeldingMachine",
		"kinds":{
			"A": [0.98,6,5],
			"B": [0.9,5,4.5],
			"C": [0.8,5,3]
		}
	},
	"oil_seal_trimming_machine": {
		"row": 2,
		"column": 2,
		"type": "Machines/OilSealTrimmingMachine",
		"kinds":{
			"A": [0.98,8,4],
			"B": [0.9,6,4.5],
			"C": [0.85,6,3]
		}
	},
	"shot_peening_machine": {
		"row": 2,
		"column": 2,
		"type": "Machines/ShotPeeningMachine",
		"kinds":{
			"A": [0.95,4,2],
			"B": [0.85,3,1],
			"C": [0.75,3,0.5]
		}
	},
	"None": {
		"row": 0,
		"column": 0,
		"type": "",
		"kinds":{
			"A": [],
			"B": [],
			"C": []
		}
	}
}

class Building:
	var type : String
	var row : int
	var column : int
	var kinds : Dictionary
	func _init(row:int,column:int,type:String,kinds : Dictionary):
		self.type = type
		self.row = row
		self.column = column
		self.kinds = kinds

var wall1101 = load("res://filesystem/Walls/1101.png")
var wall1010 = load("res://filesystem/Walls/1010.png")
var wall1011 = load("res://filesystem/Walls/1011.png")
var wall1100 = load("res://filesystem/Walls/1100.png")
var wall0111 = load("res://filesystem/Walls/0111.png")
var wall1110 = load("res://filesystem/Walls/1110.png")

#var machine_list : Dictionary
#func _ready():
#	for i in data_machines:
#		machine_list[i] = Building.new(data_machines.i.row,data_machines.i.column,data_machines.i.type,data_machines.i.kinds)
#
#var steel_strip_furnace =  Building.new(data_machines.steel_strip_furnace.row,data_machines.steel_strip_furnace.column,data_machines.steel_strip_furnace.type,data_machines.steel_strip_furnace.kinds)
#var assembly_machine =  Building.new(data_machines.assembly_machine.row,data_machines.assembly_machine.column,data_machines.assembly_machine.type,data_machines.assembly_machine.kinds)
#var electron_beam_welding_machine = Building.new(data_machines.electron_beam_welding_machine.row,data_machines.electron_beam_welding_machine.column,data_machines.electron_beam_welding_machine.type,data_machines.electron_beam_welding_machine.kinds)
#var oil_seal_trimming_machine = Building.new(data_machines.oil_seal_trimming_machine.row,data_machines.oil_seal_trimming_machine.column,data_machines.oil_seal_trimming_machine.type,data_machines.oil_seal_trimming_machine.kinds)
#var shot_peening_machine = Building.new(data_machines.shot_peening_machine.row,data_machines.shot_peening_machine.column,data_machines.shot_peening_machine.type,data_machines.shot_peening_machine.kinds)
#var None = Building.new(data_machines.None.row,data_machines.None.column,data_machines.None.type,data_machines.None.kinds)



