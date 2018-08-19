#!/usr/bin/python3

# Temperature thresholds
CRITICAL = 80
DANGER   = 60
WARNING  = 40

with open('/sys/class/thermal/thermal_zone0/temp', 'r') as f:
    temperature = float(f.read()) / 1000

if temperature > CRITICAL:
    colour = 'fg=red'
elif temperature > DANGER:
    colour = 'fg=colour202'
elif temperature > WARNING:
    colour = 'fg=yellow'
else:
    colour = 'fg=blue'

print(f'#[{colour}]{temperature}°C')
