{ config, lib, pkgs, ... }:

let
  mkimage = import ./imx-mkimage.nix;
in
{
  device = {
    manufacturer = "NXP";
    name = "i.MX8QuadMax";
    identifier = "mx8qm-mek";
  };

  hardware = {
    soc = "nxp-imx8qm";
    # Winbond W25Q16JVUXIM TR SPI NOR Flash, 3V, 16M-bit
    # TODO: check if it is configured to start from SPI.
    # SPISize = 16 / 8 * 1024 * 1024; # 16Mb → 2MB
    # TODO: determine the index
    # mmcBootIndex = "?";
  };

  Tow-Boot = with pkgs.Tow-Boot; {

    uBootVersion = "2021.04";

    src = fetchGit {
        url = "https://source.codeaurora.org/external/imx/uboot-imx.git";
        ref = "lf_v2021.04";
    };

    defconfig = "imx8qm_mek_defconfig";

    useDefaultPatches = false; # until ported to 2022.04

    builder = {

      additionalArguments = {
        #mkimage = pkgs.pkgsBuildHost.callPackage ./imx-mkimage.nix {
        #  BL31 = armTrustedFirmwareIMX8QM;
        #  imx-firmware = imxFirmware;
        #  ubootImx8 = pkgs.Tow-Boot.outputs.firmware;
        #};
      };

      installPhase = ''
        install -m 0755 u-boot.bin $out/binaries/
        install -m 0755 spl/u-boot-spl.bin $out/binaries/
        install -m 0755 u-boot.bin $out/binaries/Tow-Boot.$variant.bin
        echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        ${mkimage {pkgs=pkgs; ubootImx8="$out/binaries/";}}
      '';
    };

   # preInstallPhases = [ "showWhatsHappening" ];
#
   # showWhatsHappening = ''
   #   echo !&!&!&!&!&!&!&!&!&!&!&!&!&!&!&
   #   ls -la
   #   echo &!&!&!&!&!&!&!&!&!&!&!&!&!&!&!&
   # '';
        # 

    # Does not build right now, anyway blind UX.
    withLogo = false;
  };
}
