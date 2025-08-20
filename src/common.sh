#!/bin/sh

STATUS_FILE=.status
BUILD_USER=$(whoami)

init_module() {
    git submodule update --init --remote --depth 1 modules/$1
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

    echo "Waiting for init..."
    sleep 5

    cd ~/git/plx-build
    git submodule add https://github.com/Pullinux/plx-$1.git modules/$1

    deinit_module $1
    du -sh .
}

step_is_done() {
  local step="$1"
  grep -Fqx -- "$step" "$STATUS_FILE"
}

mark_step_done() {
  local step="$1"
  sed -i "\|^${step}\$|d" "$STATUS_FILE"
  printf '%s\n' "$step" >> "$STATUS_FILE"
}

run_step() {
  local step="$1"
  if step_is_done "$step"; then
    echo "==> Skipping ${step} (already done)"
    return 0
  fi
  echo "==> Running ${step}..."
  "$step"    # call the function
  mark_step_done "$step"
}

plx_format() {
    sudo mkfs.ext4 -v $PLX_DEV
}

plx_mount() {
    sudo mkdir -p $PLX
    sudo mount $PLX_DEV $PLX
}

plx_init() {
    sudo chown root:root $PLX
    sudo chmod 755 $PLX
}

plx_create_paths() {
    sudo mkdir -pv $PLX/{etc,var,tools,lib64} $PLX/usr/{bin,lib,sbin}
    
    for i in bin lib sbin; do
        sudo ln -sv usr/$i $PLX/$i
    done

    sudo chown -v $BUILD_USER $PLX/{usr{,/*},var,etc,tools,lib64}
}

plx_user_setup() {
    echo "nothing"
}
