extends Node

var recording = []

func record(host) -> void:
	recording.append(host.global_transform.origin)

func get_record() -> Dictionary:
	var temp_record = recording.duplicate()
	recording.clear()
	return temp_record
