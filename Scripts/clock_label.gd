class_name ClockLabel extends Label


var timer: Timer

func _ready():
	set_current_time()
	
	timer = get_node("Timer")
	timer.start()


func set_current_time():
	var datetime = Time.get_datetime_string_from_system(false, true)
	text = "%s SEST" % datetime


func _on_timer_timeout():
	set_current_time()
