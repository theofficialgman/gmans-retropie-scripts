#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-retro8"
rp_module_desc="Pico-8 Player"
rp_module_help="ROM Extensions: .png .p8\n\nCopy your Pico-8 games to $romdir/pico8\n\n"
rp_module_licence="GPL3 https://raw.githubusercontent.com/Jakz/retro8/master/LICENSE"
rp_module_repo="git https://github.com/Jakz/retro8.git master"
rp_module_section="exp"
rp_module_flags="!all 64bit"

function depends_lr-retro8() {
    local depends=()
    getDepends "${depends[@]}"
}

function sources_lr-retro8() {
    gitPullOrClone
}

function build_lr-retro8() {
    make
    md_ret_require="$md_build/retro8_libretro.so"
}

function install_lr-retro8() {
    md_ret_files=(
        'retro8_libretro.so'
    )
}

function configure_lr-retro8() {
    mkRomDir "pico8"
    ensureSystemretroconfig "pico8"
    setRetroArchCoreOption "builtin_imageviewer_enable" "false"
    addEmulator 1 "$md_id" "pico8" "$md_inst/retro8_libretro.so"
    addSystem "pico8"
}
