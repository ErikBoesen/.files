#!/bin/bash


for prog in MOOSDB cat curl emacs open tmux vim zsh; do
    ln -s "$(which sl)" ~/.local/bin/"$prog"
done

echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.bashrc
