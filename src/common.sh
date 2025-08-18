#!/bin/sh

init_module() {
    git submodule update --init --depth 1 modules/$1
}

deinit_module() {
    git submodule deinit -f modules/$1
    rm -rf .git/modules/modules/$1
}
