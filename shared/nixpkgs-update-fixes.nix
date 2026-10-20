{ lib, ... }:

# Compatibility fixes for the nixpkgs update (nixos-unstable, rev 09063bd).
#
# The update introduced two unrelated regressions that break these hosts:
#
# 1. Kernel module signing
#    nixpkgs now builds per-module signing certificates and merges them into a
#    `modules.cer` file. `aggregateModules`, which backs `system.modulesTree`,
#    unconditionally copies `modules.cer` (and appends the per-module `.ko.cer`
#    files referenced by `modules.dep`). The CachyOS kernel is supplied by the
#    `pinned` overlay, i.e. it is built with the older nixpkgs revision pinned
#    by the nix-cachyos-kernel flake (545c226a). That revision has
#    `MODULE_SIG = no` and produces neither `modules.cer` nor `.ko.cer`, so the
#    build fails with:
#
#      cp: cannot stat '.../lib/modules/7.2.8-cachyos/modules.cer': No such file or directory
#
#    Restore the previous `aggregateModules` behaviour (plain depmod, no
#    certificate merge); the CachyOS kernel does not sign modules anyway.
#
# 2. hplip / __structuredAttrs
#    `buildPythonApplication` now enables `__structuredAttrs` by default. In
#    hplip's `preFixup`, `$makeWrapperArgs` is expanded without `[@]`; with
#    structured attributes it is a Bash array, so only its first element
#    (`--prefix`) is passed, corrupting the `makeWrapper` command:
#
#      error: #error makeCWrapper: Unknown argument .../lib/gio/modules
#
#    Disable structured attributes for hplip so the original list value is
#    exported as a plain string again.
{
  nixpkgs.overlays = [
    (final: prev: {
      aggregateModules =
        modules:
        prev.buildEnv {
          name = "kernel-modules";
          paths = modules;
          postBuild = ''
            source ${prev.stdenvNoCC}/setup

            if ! test -d "$out/lib/modules"; then
              echo "No modules found."
              # To support a kernel without modules
              exit 0
            fi

            kernelVersion=$(cd $out/lib/modules && ls -d *)
            if test "$(echo $kernelVersion | wc -w)" != 1; then
              echo "inconsistent kernel versions: $kernelVersion"
              exit 1
            fi

            echo "kernel version is $kernelVersion"

            shopt -s extglob

            # Regenerate the depmod map files.  Be sure to pass an explicit
            # kernel version number, otherwise depmod will use `uname -r'.
            if test -w $out/lib/modules/$kernelVersion; then
              rm -f $out/lib/modules/$kernelVersion/modules.!(builtin*|order*)
              ${prev.buildPackages.kmod}/bin/depmod -b $out -C $out/etc/depmod.d -a $kernelVersion
            fi
          '';
        };

      hplip = prev.hplip.overrideAttrs (old: {
        __structuredAttrs = false;
      });
    })
  ];
}
