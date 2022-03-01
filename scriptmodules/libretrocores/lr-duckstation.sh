#!/usr/bin/env bash

rp_module_id="lr-duckstation"
rp_module_desc="PlayStation emulator - Duckstation for libretro"
rp_module_help="ROM Extensions: .exe .cue .bin .chd .psf .m3u .pbp\n\nCopy your PlayStation roms to $romdir/psx\n\nCopy compatible BIOS files to $biosdir"
rp_module_licence="PROP https://creativecommons.org/licenses/by-nc-nd/4.0"
rp_module_section="exp"
rp_module_flags="!all arm !armv6 aarch64 64bit"

function __binary_url_lr-duckstation() {
    isPlatform "aarch64" && echo "https://web.archive.org/web/20220106162052/https://www.duckstation.org/libretro/duckstation_libretro_linux_aarch64.zip"
    isPlatform "arm" && echo "https://web.archive.org/web/20220106162154/https://www.duckstation.org/libretro/duckstation_libretro_linux_armv7.zip"
    isPlatform "x86" && isPlatform "64bit" && echo "https://web.archive.org/web/20220106161943/https://www.duckstation.org/libretro/duckstation_libretro_linux_x64.zip"
}

function install_bin_lr-duckstation() {
    downloadAndExtract "$(__binary_url_lr-duckstation)" "$md_inst"
}

function configure_lr-duckstation() {
    mkRomDir "psx"
    ensureSystemretroconfig "psx"

    if isPlatform "gles" && ! isPlatform "gles3"; then
        # Hardware renderer not supported on GLES2 devices
        setRetroArchCoreOption "duckstation_GPU.Renderer" "Software"
    fi

    # Pi 4 has occasional slowdown with hardware rendering
    # e.g. Gran Turismo 2 (Arcade) race start
    isPlatform "rpi4" && setRetroArchCoreOption "duckstation_GPU.Renderer" "Software"

    # Configure the memory card 1 saves through the libretro API
    setRetroArchCoreOption "duckstation_MemoryCards.Card1Type" "NonPersistent"

    # dynarec segfaults without redirecting stdin from </dev/null
    addEmulator 0 "$md_id" "psx" "$md_inst/duckstation_libretro.so </dev/null"
    addSystem "psx"
}
