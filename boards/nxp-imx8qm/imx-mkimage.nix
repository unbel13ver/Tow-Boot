{ pkgs,
  ubootImx8,
  BL31 ? pkgs.Tow-Boot.armTrustedFirmwareIMX8QM,
  imx-firmware ? pkgs.Tow-Boot.imxFirmware,
  mx8device ? "iMX8QM"
}:

with pkgs;
stdenv.mkDerivation rec {
  pname = "imx-mkimage";
  version = "lf-5.15.5-1.0.0";

  src = pkgs.fetchgit {
    url = "https://source.codeaurora.org/external/imx/imx-mkimage.git";
    rev = version;
    sha256 = "sha256-9buTYj0NdKV9CpzHfj7sIB5sRzS4Md48pn2joy+T97U=";
    leaveDotGit = true;
  };

  buildInputs = [
    git
    glibc.static
  ];

  makeFlags = [
    "SOC=${mx8device} flash_spl"
  ];

  preBuildPhases = ["copyBinaries"];

  copyBinaries = ''
    ls -la ${ubootImx8}
    install -m 0755 ${imx-firmware}/* ${mx8device}
    install -m 0755 ${ubootImx8}/u-boot* ${mx8device}
    install -m 0755 ${BL31}/* ${mx8device}
  '';

  installPhase = ''
    mkdir $out
    install -m 0755 ${mx8device}/flash.bin $out/
  '';
}
