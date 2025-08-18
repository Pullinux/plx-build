#!/bin/sh

init_module() {
    git submodule update --init --depth 1 modules/$1
}

deinit_module() {
    git submodule deinit -f modules/$1
    rm -rf .git/modules/modules/$1
}

git_init() {
    git init
    git add .
    git commit -m "first commit"
    git branch -M master
    git remote add origin https://github.com/Pullinux/plx-$1.git
    git push -u origin master

    cd ~/git/plx-build
    git submodule add https://github.com/Pullinux/plx-$1.git modules/$1

    deinit_module $1
    du -sh .
}
