#!/bin/bash

PICOM_CONF="$HOME/.config/picom/picom.conf"

current_value=$(grep -m 1 "active-opacity = " $PICOM_CONF | cut -d'=' -f2 | sed 's/[^0-9.]*//g')
new_value=$([ "$current_value" == "1" ] && echo "0.95" || echo "1")

sed -i "s/^active-opacity = $current_value;/active-opacity = $new_value;/g" $PICOM_CONF

