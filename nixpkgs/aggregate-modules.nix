{
  stdenvNoCC,
  kmod,
  modules,
  buildEnv,
  name ? "kernel-modules",
}:

# Same as nixpkgs' `pkgs/os-specific/linux/kmod/aggregator.nix`, but tolerant
# of kernels whose `modules` output has no `modules.cer`. Kernels built with an
# older nixpkgs (e.g. the pinned nixpkgs of the CachyOS kernel flake) predate
# the "generate deterministic module signatures and certificates" change and
# therefore do not ship that file, while the aggregator of the current nixpkgs
# unconditionally tries to copy it and fails.
buildEnv {
  inherit name;

  paths = modules;

  postBuild = ''
    source ${stdenvNoCC}/setup

    if ! test -d "$out/lib/modules"; then
      echo "No modules found."
      # To support a kernel without modules
      exit 0
    fi

    kernelVersion=$(cd $out/lib/modules && ls -d *)
    if test "$(echo $kernelVersion | wc -w)" != "1"; then
       echo "inconsistent kernel versions: $kernelVersion"
       exit 1
    fi

    echo "kernel version is $kernelVersion"

    shopt -s extglob

    # Regenerate the depmod map files.  Be sure to pass an explicit
    # kernel version number, otherwise depmod will use `uname -r'.
    if test -w $out/lib/modules/$kernelVersion; then
        rm -f $out/lib/modules/$kernelVersion/modules.!(builtin*|order*|cer)
        ${kmod}/bin/depmod -b $out -C $out/etc/depmod.d -a $kernelVersion
        cd -- "$out/lib/modules/$kernelVersion"

        # Merge the single-module certificates for external modules. Kernels
        # and modules built by an older nixpkgs do not ship per-module
        # certificates, so tolerate their absence and always create the file.
        if [[ -e modules.cer ]]; then
          cp --no-preserve=mode,ownership --remove-destination \
            -- "$(readlink -f modules.cer)" modules.cer
        fi
        sed "1,$(wc -l < modules.order)d; s/\.ko.*/.ko.cer/" modules.dep \
            | xargs -d'\n' -r bash -c 'for f in "$@"; do if [ -e "$f" ]; then cat "$f"; fi; done' _ \
            >> modules.cer
    fi
  '';
}
