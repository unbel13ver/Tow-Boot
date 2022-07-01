{ config, lib, pkgs, ... }:

let
  mkimage = pkgs.pkgsBuildHost.callPackage ./imx-mkimage.nix {ubootpkgs = pkgs;};
in
{
  device = {
    manufacturer = "NXP";
    name = "i.MX8QuadMax";
    identifier = "mx8qm-mek";
  };

  hardware = {
    soc = "nxp-imx8qm";
  };

  Tow-Boot =  {

    uBootVersion = "2021.04";

    src = fetchGit {
        url = "https://source.codeaurora.org/external/imx/uboot-imx.git";
        ref = "lf_v2021.04";
    };

    defconfig = "imx8qm_mek_defconfig";

    useDefaultPatches = false; # until ported to 2022.04

    builder = {
      installPhase = ''
        install -m 0755 ${mkimage}/flash.bin $out/binaries/Tow-Boot.$variant.bin
      '';
    };

    # Does not build right now, anyway blind UX.
    withLogo = false;
  };
}
