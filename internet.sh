#!/bin/bash

ip=$(hostname -i)
printf "☰ ${ip::-2}"
