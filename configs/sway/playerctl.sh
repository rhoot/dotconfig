#!/bin/bash

# Specialized script for prioritized media focus control

CHROMIUMS=$(playerctl --list-all | grep chromium. | xargs | sed 's/ /,/g')
FIREFOXES=$(playerctl --list-all | grep firefox. | xargs | sed 's/ /,/g')
playerctl --player spotify,$CHROMIUMS,$FIREFOXES $@
