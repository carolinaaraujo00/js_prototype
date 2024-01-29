extends Node

const ACTION_LEFT_MOUSE = "action_left_mouse"
const ACTION_INTERACT = "interact"
const ACTION_DEBUG = "debug"

const SIGNAL_INTERACTABLE_INTERACTION_FINISHED = "interaction_finished"
const SIGNAL_NPC_REACHED_TARGET = "npc_target_reached"

const MASK_WORLD: int = 1
const MASK_PLAYER: int = 2
const MASK_NPC: int = 3

const ANIMATION_GROUND_TARGET_LOCATION = "ground_target_animation"

const SCENE_TEST_MOVEMENT = "res://testing/test_movement.tscn"
const SCENE_GROUND_TARGET = "res://assets/target_location/target_location.tscn"
const SCENE_MAIN_MENU = "res://main_menu/main_menu.tscn"
const SCENE_LVL0_THREE_LITTLE_PIGS = "res://world/lvl01_three_little_pigs.tscn"
const SCENE_HUFF_AND_PUFF = "res://world/huff/wolf_huff_puff.tscn"

const GROUP_PLAYER = "player"
const GROUP_TARGET_POSITION = "target"

const DIALOGUE_EXERCISE1 = "exercise1"

const DICT_COLORS: Dictionary = {
	ENUM_COLORS.AZUL: Color(Color.DEEP_SKY_BLUE),
	ENUM_COLORS.VERMELHO: Color(Color.RED),
	ENUM_COLORS.AMARELO: Color(Color.YELLOW),
	ENUM_COLORS.VERDE: Color(Color.WEB_GREEN)
}

enum ENUM_COLORS {
	AZUL, VERMELHO, AMARELO, VERDE
}

enum ENUM_HUFF_TYPE {
	HUFF1, HUFF2, HUFF3
}


func _ready() -> void: 
	randomize()
