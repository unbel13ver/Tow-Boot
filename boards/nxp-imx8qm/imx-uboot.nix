{ pkgs }:

let

  inherit (pkgs) buildUBoot;

in {

  ubootImx8 = buildUBoot {
    version = "2021.04";
    src = fetchGit {
      url = "https://source.codeaurora.org/external/imx/uboot-imx.git";
      ref = "lf_v2021.04";
    };
    patches = [];
    enableParallelBuilding = true;
    defconfig = "imx8qm_mek_defconfig";
    extraMeta.platforms = ["aarch64-linux"];
    filesToInstall = ["u-boot.bin" "spl/u-boot-spl.bin"];
  };

}
