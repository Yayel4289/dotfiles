#!/bin/bash

internal_monitor=eDP-1
external_monitor=DP-3
desktops_by_mon=5 

add_monitor() {
	for desktop in $(bspc query -D -m $internal_monitor | tail -$desktops_by_mon) 
	do 
		bspc desktop $desktop --to-monitor $external_monitor
	done

	bspc desktop Desktop --remove

	polybar secondmon &
}

remove_monitor() {
	bspc monitor $external_monitor -a Desktop # Tmp bc at least 1 desktop by mon
	for desktop in $(bspc query -D -m $external_monitor)
	do 
		bspc desktop $desktop --to-monitor $internal_monitor
	done

	bspc desktop Desktop --remove
}

if [[ $(xrandr -q | grep "$external_monitor connected") ]]; then
	add_monitor
else 
	remove_monitor
fi
