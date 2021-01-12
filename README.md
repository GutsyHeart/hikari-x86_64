## yin-x86_64 <img alt="" align="right" src="https://badges.pufler.dev/visits/owl4ce/yin-x86_64?style=flat-square&label=&color=fa74b2&logo=GitHub&logoColor=white&labelColor=373e4d"/>

<p align="center">
  <img alt="info" align="center" src="./info.png"/>
</p>
<p align="center">🎀 Optimized for multitasking under extreme load 🎀</p>

## [Kernel Sources](./usr_src_linux)
<img alt="logo" align="right" width="400px" src="./logo.png"/>

- LZ4 bzImage (vmlinuz)
- Xanmod-CacULE patchset + Gentoo patches (ebuild)
  - [Gentoo Xanmod](https://gitlab.com/src_prepare/src_prepare-overlay/-/tree/master/sys-kernel/xanmod-sources) (CacULE included)
  - [CacULE Scheduler](https://github.com/hamadmarri/cacule-cpu-scheduler)
- Disabled numa, debugging, etc. (kernel hacking)
  - See suggested configs on [cacule-cpu-scheduler]
- Enabled swap compressed block as default (LZ4)
- Android binder and ashmem support (Anbox support)
- AMD SoC only (disabled most intel features)
- Governor performance as default (high perfomance)
- BFQ I/O Scheduler as default (low latency)
- Custom boot logo ([UwU](./usr_src_linux/drivers/video/logo/logo_linux_clut224.ppm))
- 250Hz tick rate (low latency)

## [Localmodconfig](./home_username_.config) (optional)
- [Modprobed-db](https://github.com/graysky2/modprobed-db)    

---

### Store current module
> **Optional**: If you want minimal kernel
- **References**: [wiki.archlinux/Modprobed-db](https://wiki.archlinux.org/index.php/Modprobed-db)
  ```bash
  modprobed-db store
  ```

### Kernel sources directory
- **Gentoo**: `/usr/src/linux`
  ```bash
  cp .config_yin .config
  make -j`nproc` menuconfig # If you want to adjust yourself again
  
  # Optional, if you want minimal kernel
  # Using the database from modprobed-db to set the module to be used. Adjust <username> to where the database is located.
  make -j`nproc` LSMOD=/home/<username>/.config/modprobed.db localmodconfig
  
  # Make sure this and so on down as root
  make -j`nproc` modules_install
  make -j`nproc` install
  ```

### Generate initramfs (if using)
- **Dracut**  
  Adjust <version> with the kernel version you compiled/use (as root)
  ```bash
  dracut --kver <version> /boot/initramfs-<version>.img --force
  ```
  
> In order for the logo to appear on boot, make sure to use `loglevel=4` in the [kernel parameters](https://wiki.archlinux.org/index.php/Kernel_parameters).

vmlinuz|modules
|--|--|
![](./vmlinuz.png)|![](./modules.png)

[backup_gentoo_config](https://github.com/owl4ce/hold-my-gentoo)
