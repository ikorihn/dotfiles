#!/bin/bash

pkg update
pkg install vim git openssh

termux-setup-storage

cd ~/storage/shared
mkdir repos
cd repos
git clone git@github.com/ikorihn/memo.git



