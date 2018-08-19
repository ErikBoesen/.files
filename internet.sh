#!/bin/bash

#network=$(iwgetid -r)
ip=$(hostname -i)
printf "☰ ${ip::-2}"
