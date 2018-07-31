#!/usr/bin/env bash

mencoder mf://*.bmp -mf w=640:h=480:fps=30:type=bmp -ovc lavc \
    -lavcopts vcodec=mpeg4:mbd=2:trell -oac copy -o output.avi
