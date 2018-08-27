#!/usr/bin/python3

# Temperature thresholds
CRITICAL = 80
DANGER   = 60
WARNING  = 40

# Thermal zones 0 and 1 do not seem to change.
with open('/sys/class/thermal/thermal_zone2/temp', 'r') as f:
    temperature = float(f.read()) / 1000

if temperature > CRITICAL:
    colour = 'fg=red,blink'
elif temperature > DANGER:
    colour = 'bg=colour202,fg=white'
elif temperature > WARNING:
    colour = 'fg=yellow'
else:
    colour = ''

print(f'#[{colour}]{temperature}°C#[bg=default,fg=default,noblink]', end='')
