#!/usr/bin/python3

with open('/sys/class/thermal/thermal_zone0/temp', 'r') as f:
    temperature = float(f.read()) / 1000

print(f'{temperature}°C')
