#!/bin/bash
SESSION="algoritems"
SESSIONEXISTS=$(tmux list-sessions | grep $SESSION)
START_DIR='/home/adi/PycharmProjects/algoritems/'
CONDA_DEFAULT_ENV="al" 

cd "$START_DIR"
# Only create tmux session if it doesn't already exist
if [ "$SESSIONEXISTS" = "" ]
then
    tmux new-session -c $START_DIR -d -s $SESSION
    tmux split-window -v -p 30
    tmux split-window -v 

    tmux select-pane -t $SESSION:1.1
    tmux send-keys "vim" C-m
    tmux send-key ":Exp" C-m

    tmux select-pane -t $SESSION:1.2

    tmux select-pane -t $SESSION:1.3

    tmux new-window -t $SESSION:2 -n debug
    sleep .5
    tmux select-pane -t $SESSION:2.1

    tmux select-window -t $SESSION:1
    tmux attach-session -t $SESSION 
else
    tmux attach-session -t $SESSION
fi
