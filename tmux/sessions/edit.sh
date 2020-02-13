#!/bin/bash
SESSION="edit"
SESSIONEXISTS=$(tmux list-sessions | grep $SESSION)
START_DIR='/home/adi'

cd "$START_DIR"
# Only create tmux session if it doesn't already exist
if [ "$SESSIONEXISTS" = "" ]
then
    tmux new-session -c $START_DIR -d -s $SESSION
    tmux split-window -v -p 30

    tmux select-pane -t $SESSION:1.1
    tmux send-keys "vim ~/.vimrc" C-m

    tmux select-pane -t $SESSION:1.2



    tmux new-window -t $SESSION:2 -n compare
    sleep .5
    tmux select-pane -t $SESSION:2.1

    tmux send-keys "cd ~/PycharmProjects/algoritems" C-m
    tmux send-keys "vim test_class.py" C-m
    
    tmux select-window -t $SESSION:1
    tmux attach-session -t $SESSION 
else
    tmux attach-session -t $SESSION
fi
