extends Node

class State:
	var name: String
	func _init(s_name: String):
		name = s_name

class stateMachine:
	var currentState: State
	var possibleStates : Array[State] = []
	var stateTransitions: Dictionary[String, Array] = {}
	
	func _init(States: Array[State]):
		possibleStates = States
		currentState = States[0]
		
	func add_state(name: String):
		possibleStates.push_back(State.new(name))
	
	func transition_to_State(toState: State):
		var possibleTransitionCalls: Array[Callable] = stateTransitions.get(currentState.name+"_"+toState.name)
		if possibleTransitionCalls != null:
			currentState = toState
			for callObj in possibleTransitionCalls:
				callObj.call()
		return self
	
	func transition_to_String(toState: String):
		var transitions = stateTransitions.get(currentState.name+"_"+toState)
		if transitions != null:
			for fn in transitions:
				fn.call()
		for state in possibleStates:
				if state.name == toState:
					currentState = state
					break
		return self
			
	func on_transition_between_State(fromState: State, toState: State, callObj: Callable):
		var term := fromState.name+"_"+toState.name
		if stateTransitions.get(term) == null:
			stateTransitions[term] = []
		stateTransitions.get(term).push_back(callObj)
		return self
		
	func on_transition_between_String(fromState: String, toState: String, callObj: Callable):
		var term := fromState+"_"+toState
		if stateTransitions.get(term) == null:
			stateTransitions[term] = []
		stateTransitions.get(term).push_back(callObj)
		return self
		
	func on_transition_to_State(toState: State, callObj: Callable):
		var stateExists: bool = false
		for state in possibleStates:
			if state.name != toState.name:
				self.on_transition_between_State(state, toState, callObj)
				stateExists = true
		if !stateExists:
			self.add_state(toState.name)
		return self
		
	func on_transition_to_String(toState: String, callObj: Callable):
		var stateExists: bool = false
		for state in possibleStates:
			if state.name != toState:
				self.on_transition_between_String(state.name, toState, callObj)
				stateExists = true
		if !stateExists:
			self.add_state(toState)
		return self

var gameStateMachine: stateMachine
var gameStateNothing: State
var gameStates: Array[State]

func _ready() -> void:
	gameStateNothing = State.new("gameStateNothing")
	gameStates.push_back(gameStateNothing)
	gameStateMachine = stateMachine.new(gameStates)
	
