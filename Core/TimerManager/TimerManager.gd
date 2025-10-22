extends Node

var intervals: Dictionary[int, Interval]

var timer_holder: Node

func _ready() -> void:
	CreateTimerHolder()

func CreateTimerHolder() -> void:
	timer_holder = Node.new()
	timer_holder.name = "TimerHolder"
	get_tree().current_scene.add_child(timer_holder)

func CreateNewID() -> int:
	if intervals.is_empty():
		return 0
	else:
		return (intervals.keys().max() + 1)

func CreateInterval(_owner: Object, method: Callable, duration: float, one_shot: bool = true) -> int:
	var new_interval: Interval = Interval.new()
	new_interval.owner = _owner
	new_interval.method = method
	new_interval.duration = duration
	new_interval.one_shot = one_shot
	
	var timer: Timer = Timer.new()
	timer_holder.add_child(timer)
	
	timer.wait_time = duration
	timer.one_shot = one_shot
	
	new_interval.timer = timer
	
	var new_id = CreateNewID()
	
	intervals[new_id] = new_interval
	
	timer.timeout.connect(OnTimerTimeout.bind(new_id))
	timer.start(0)
	
	return new_id

func OnSceneChanged() -> void:
	CreateTimerHolder()

func OnTimerTimeout(id: int) -> void:
	intervals[id].method.call()
