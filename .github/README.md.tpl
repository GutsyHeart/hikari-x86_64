# <p align="center">`_KVER_`</p>

<p align="center"><samp>✲ optimized for multitask under extreme loads ✲</samp></p>

## [linux](./linux) <img alt="" align="right" src="https://badges.pufler.dev/visits/owl4ce/hikari-x86_64?style=flat-square&label=&color=000000&logo=GitHub&logoColor=white&labelColor=373e4d"/>

<p align="center"><a href="#general-linux-kernel-compilation-with-gcc-toolchain"><img alt="" src="https://repository-images.githubusercontent.com/308812995/e978591c-11ed-452f-bab8-718c2fca29cf"/></a></p>

<details>
<summary>Featured configuration</summary>
  
  <br>
  
  > * Linux souces based on [Xanmod-~~CacULE~~ patchset](https://xanmod.org) with [Gentoo patches](https://wiki.gentoo.org/wiki/Project:Kernel/Gentoo-sources) from [src_prepare-overlay](https://gitlab.com/src_prepare/src_prepare-overlay/-/tree/master/sys-kernel/xanmod-sources)
  > * Implement [LRNG](https://github.com/smuellerDD/lrng) to provide sufficient entropy during boot as well as virtual environments and SSDs
  > * Use Voluntary Kernel Preemption to allows applications run more smoothly even system under loads
  > * Use balanced 500Hz timer frequency for fast desktop interactivity and smoothness with energy-efficient
  > * Use [Clang/LLVM toolchain](https://kernel.org/doc/html/latest/kbuild/llvm.html) with O3 optimization for processor family x86-64-v3 and ThinLTO by default
  > * Use [LZ4](https://github.com/lz4/lz4) compressed bzImage by default for fastest de/compression speed with low compression ratio
  > * Use [BFQ I/O Scheduler](https://kernel.org/doc/html/latest/block/bfq-iosched.html) which guarantees high system, application responsiveness, and low-latency
  > * Use [Performance Governor](https://kernel.org/doc/html/latest/admin-guide/pm/cpufreq.html) by default for max CPU speed, change if too high energy consumptions
  > * Use [LZ4](https://github.com/lz4/lz4) with [z3fold](https://kernel.org/doc/html/latest/vm/z3fold.html) zswap compressed block by default which balanced between ratio and speed
  > * Disabled unused features like 5-level page tables, debugging, kexec, kprobes, NUMA, Xen, etc.
  > * Enabled F2FS (SSD) and EXT4 (HDD) as built-in which optimized, and BTRFS as module
  > * Enabled AMD-specific or Intel-specific features, other SoCs are all disabled
  > * Enabled [AMD-pstate](https://lore.kernel.org/lkml/20211029130241.1984459-1-ray.huang@amd.com/T) driver for schedutil and ondemand governor
  > * Enabled New Paragon's Software [NTFS3](https://kernel.org/doc/html/latest/filesystems/ntfs3.html) driver
  > * Full-support [EFI stub](https://kernel.org/doc/html/latest/admin-guide/efi-stub.html) w/o initramfs
  > * Many more.

</details>

##  
> #### General Linux kernel compilation with GCC toolchain
```sh
# Copy my hikari configuration as default config.
cp -v .config_hikari .config

# Many people usually use `menuconfig`, use `nconfig` to use beautiful curses interface.
make -j$(nproc) nconfig 

# Build Linux with niceness -1 as root.
nice -n -1 make -j$(nproc)

# Install the kernel modules.
make -j$(nproc) modules_install

# Install the bzImage, known as vmlinuz.
make -j$(nproc) install
```
> #### General Linux kernel compilation with LLVM toolchain
```sh
# Copy my hikari configuration as default config.
cp -v .config_hikari .config

# Many people usually use `menuconfig`, use `nconfig` to use beautiful curses interface.
make -j$(nproc) LLVM=1 LLVM_IAS=1 nconfig

# Build Linux with niceness -1 as root.
nice -n -1 make -j$(nproc) LLVM=1 LLVM_IAS=1

# Install the kernel modules.
make -j$(nproc) LLVM=1 LLVM_IAS=1 modules_install

# Install the bzImage, known as vmlinuz.
make -j$(nproc) LLVM=1 LLVM_IAS=1 install
```
> ㅤ  
> Estimated may be longer than the GCC toolchain, but significally improving performance by using ThinLTO.
> <p align="center"><img src="./.github/screenshots/2021-10-30-072210_1301x748_scrot.png" alt="O3"/></p>
> <p align="center"><img src="./.github/screenshots/2021-10-30-073344_1301x748_scrot.png" alt="thin.lto"/></p>
> <p align="center"><img src="./.github/screenshots/2021-10-30-072151_1301x748_scrot.png" alt="march"/></p>

> See also Linux kernel configuration at [Gentoo Wiki](https://wiki.gentoo.org/wiki/Kernel/Configuration).

##  
### How to convert my own framebuffer logo?
> Simply install `netpbm` then convert your own logo, an example **.png** file into 224 24-bit colors ASCII pixmap.
> 
> > Generally, the Linux kernel framebuffer logo size is **80**x**80** pixels, but if you want to adjust the full screen size, you have to set up your logo with a size that matches your screen resolution e.g **1366**x**768**.
>
> Below will replace the default Tux logo with our custom logo. ~Initially I made a patch, but I think it's less effective because it's enough to replace then build the kernel.~ Created [linucc224](https://github.com/owl4ce/linucc224) for auto-patching. :tada:
```sh
pngtopnm /path/to/your_logo.png | ppmquant -fs 223 | pnmtoplainpnm > logo_linux_clut224.ppm

doas cp -fv logo_linux_clut224.ppm /usr/src/linux/drivers/video/logo/logo_linux_clut224.ppm
```

> To make framebuffer logo to appear on boot, ensure to use `loglevel=4` in the [kernel parameters](https://wiki.archlinux.org/index.php/Kernel_parameters).

> #### Note
> If you're using custom framebuffer logo like mine.  
> > The framebuffer logo must be cleared before init runs, you can modify your init. I've only ever tried on **runit** and **sysvinit**+**openrc**, other than that I don't know. For example **sysvinit**+**openrc** on Gentoo/Linux, I created [wrapper script](https://github.com/owl4ce/hmg/blob/main/sbin/localh3art-init) to run curses **clear** command before executing **openrc sysinit**. See my [inittab](https://github.com/owl4ce/hmg/blob/main/etc/inittab#L19-L20).  
> 
> **Below is an example of my trick ..**  
> Run the following commands as root.
> ```sh
> cat > /sbin/localh3art-init << "EOF"
> #!/bin/sh
> LC_ALL=POSIX LANG=POSIX; W='\033[1;37m' R='\033[1;31m' G='\033[1;32m' NC='\033[0m'
> 
> INIT='/sbin/openrc sysinit'
> 
> kern() { printf " ${G}* ${W}Booting with ${R}$(uname -r) "; }
> dots() {
>     for S in $(seq 1 4); do
>         if [ "$S" -gt 1 ]; then
>             printf "${W}.${NC}"
>         fi
>         sleep .1s
>     done
> }
> 
> kern; dots; clear; exec ${INIT}
> EOF
> ```
> ```sh
> chmod +x /sbin/localh3art-init
> ```
> ```sh
> sed -i 's|si::sysinit:/sbin/openrc sysinit|si::sysinit:/sbin/localh3art-init|' /etc/inittab

> **Or, if you're actually don't care about framebuffer logo ..**  
> Simply enable this to disable the framebuffer logo that appears on boot.
> ```cfg  
> CONFIG_FRAMEBUFFER_CONSOLE_DEFERRED_TAKEOVER=y
> ```
> `Device Drivers` 🡲 `Graphics support` 🡲 `Console display driver support`

##  
### Generating initramfs (optional)
> #### Dracut
> Adjust version of the kernel that you build. Below is an example, run the following commands as root.
```sh
dracut --kver _KVER_ /boot/initramfs-_KVER_.img --force
```
> See also my [dracut.conf](https://github.com/owl4ce/hmg/blob/main/etc/dracut.conf). Read more at [Gentoo Wiki](https://wiki.gentoo.org/wiki/Dracut).

##  
### EFI Stub Examples
> You must have separate `/boot` type **vfat** (12/16/32) partition, run one of the two commands below as root.  

> #### With initramfs
```sh
efibootmgr --create --part 1 --disk /dev/sda --label "GENTOO.hikari-x86_64" --loader "\vmlinuz-_KVER_" \
-u "loglevel=4 initrd=\initramfs-_KVER_.img"
```
> #### Without initramfs
```sh
efibootmgr --create --part 1 --disk /dev/sda --label "GENTOO.hikari-x86_64" --loader "\vmlinuz-_KVER_" \
-u "root=PARTUUID=13992175-d060-1948-b042-ade29f8af571 rootfstype=f2fs rootflags=gc_merge,checkpoint_merge,compress_algorithm=lz4,compress_extension=*,compress_chksum,compress_cache,atgc loglevel=4"
```
> #### Show detailed entry
```sh
efibootmgr -v
```
> #### Delete entry
```sh
efibootmgr -BbXXXX
```

##  
### Acknowledgements
> * All Linux kernel developers and contributors
> * [Alexandre Frade](https://github.com/xanmod) as [Linux-Xanmod](https://xanmod.org) maintainer
> * [Hamad Al Marri](https://github.com/hamadmarri) as [CacULE (and other) scheduler](https://github.com/hamadmarri/cacule-cpu-scheduler) author
> * [Peter Jung](https://github.com/ptr1337) as [CachyOS](https://cachyos.org) developer, an optimized Arch-based Linux distribution
> * [src_prepare Group](https://src_prepare.gitlab.io), the home of systems developers especially for Gentoo/Linux
