#!/usr/bin/env bash


rp_module_id="lr-bsnes-hd-beta"
rp_module_desc="Super Nintendo Emulator - bsnes hd beta port for libretro"
rp_module_help="ROM Extensions: .bml .smc .sfc .zip\n\nCopy your SNES roms to $romdir/snes"
rp_module_licence="GPL3 https://raw.githubusercontent.com/DerKoun/bsnes-hd/master/LICENSE"
rp_module_repo="git https://github.com/DerKoun/bsnes-hd.git master"
rp_module_section="opt"
rp_module_flags="!armv6"

function depends_lr-bsnes-hd-beta() {
    if compareVersions $__gcc_version lt 7; then
        md_ret_errors+=("You need an OS with gcc 7 or newer to compile $md_id")
        return 1
    fi
    local depends=()
    depends+=(build-essential libgtk2.0-dev libpulse-dev mesa-common-dev libcairo2-dev libsdl2-dev libxv-dev libao-dev libopenal-dev libudev-dev)
    getDepends "${depends[@]}"
}

function sources_lr-bsnes-hd-beta() {
    gitPullOrClone
}

function build_lr-bsnes-hd-beta() {
    local params=(target="libretro" build="release" binary="library")
    make -C bsnes clean "${params[@]}"
    make -C bsnes "${params[@]}"
    md_ret_require="$md_build/bsnes/out/bsnes_hd_beta_libretro.so"
}

function install_lr-bsnes-hd-beta() {
    md_ret_files=(
        'bsnes/out/bsnes_hd_beta_libretro.so'
        'LICENSE'
        'README.md'
    )
}

function configure_lr-bsnes-hd-beta() {
    mkRomDir "snes"
    ensureSystemretroconfig "snes"

    addEmulator 1 "$md_id" "snes" "$md_inst/bsnes_hd_beta_libretro.so"
    addSystem "snes"
}
