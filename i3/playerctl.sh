#!/bin/bash

# Specialized script for prioritized media focus control

FIREFOXES=$(playerctl --list-all | grep firefox. | xargs | sed 's/ /,/g')
playerctl --player spotify,$FIREFOXES $@
