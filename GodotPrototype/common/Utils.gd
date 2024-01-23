extends Node

const ACTION_LEFT_MOUSE = "action_left_mouse"
const ACTION_INTERACT = "interact"

const SIGNAL_INTERACTABLE_INTERACTION_FINISHED = "interaction_finished"
const SIGNAL_NPC_REACHED_TARGET = "npc_target_reached"

const MASK_WORLD: int = 1
const MASK_PLAYER: int = 2

const ANIMATION_GROUND_TARGET_LOCATION = "ground_target_animation"

const SCENE_TEST_MOVEMENT = "res://testing/test_movement.tscn"
const SCENE_GROUND_TARGET = "res://assets/target_location/target_location.tscn"

const GROUP_PLAYER = "player"
const GROUP_TARGET_POSITION = "target"
