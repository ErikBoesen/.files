#!/usr/bin/python3

with open('/sys/class/thermal/thermal_zone0/temp', 'r') as f:
    temperature = float(f.read()) / 1000

if temperature > 80:
    colour = 'red'
elif temperature > 60:
    colour = 'colour202'
elif temperature > 40:
    colour = 'yellow'
else:
    colour = 'blue'

print(f'#[fg={colour}]{temperature}°C')
