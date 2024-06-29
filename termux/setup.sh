#!/bin/bash

pkg update
pkg install -y vim git openssh cronie termux-services

ln -sf $(pwd)/.bashrc ~/.bashrc
ln -sf $(pwd)/.vimrc ~/.vimrc
ln -sf $(pwd)/sync_obsidian.sh ~/sync_obsidian.sh

termux-setup-storage

cd ~/storage/shared
mkdir repos
cd repos
git clone git@github.com/ikorihn/memo.git

