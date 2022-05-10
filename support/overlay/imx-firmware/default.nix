{ stdenv
, lib
, fetchurl
}:
let
  imxurl = "https://www.nxp.com/lgfiles/NMG/MAD/YOCTO";

  fwHdmiVersion = "8.15";
  fwScVersion = "1.10.0";
  fwSecoVersion = "3.8.2";

  firmwareHdmi = fetchurl rec {
    url = "${imxurl}/firmware-imx-${fwHdmiVersion}.bin";
    sha256 = "QQP7jcQBs/EZK9X+mwFumauEcpOiJNa0hHm+fMBOHB8=";
    executable = true;
  };

  firmwareSc = fetchurl rec {
    url = "${imxurl}/imx-sc-firmware-${fwScVersion}.bin";
    sha256 = "aQBefLYrR9SA0NoJJ6ZadwvMMcgroeKjpd8pUXbqCiI=";
    executable = true;
  };

  firmwareSeco = fetchurl rec {
    url = "${imxurl}/imx-seco-${fwSecoVersion}.bin";
    sha256 = "kks3aEZ0c+Z26yy9PP1Z06g97kvKG1Ck0wGNHeAk3RY=";
    executable = true;
  };

  filesToInstall = [
    "firmware-imx-${fwHdmiVersion}/firmware/hdmi/cadence/dpfw.bin"
    "firmware-imx-${fwHdmiVersion}/firmware/hdmi/cadence/hdmi?xfw.bin"
    "imx-sc-firmware-${fwScVersion}/mx8qm-mek-scfw-tcm.bin"
    "imx-seco-${fwSecoVersion}/firmware/seco/mx8qmb0-ahab-container.img"
  ];

in
stdenv.mkDerivation {
  pname = "imxFirmware";
  version = "5.15.X_1.0.0-Yocto";

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  sourceRoot = ".";

  unpackPhase = ''
    ${firmwareHdmi} --auto-accept --force
    ${firmwareSc} --auto-accept --force
    ${firmwareSeco} --auto-accept --force
  '';

  installPhase = ''
    mkdir -p $out
    cp -vt $out ${lib.concatStringsSep " " filesToInstall}
    mv $out/*?scfw-tcm.bin $out/scfw_tcm.bin
  '';

  meta = with lib; {
    description = "Firmware packages needed for booting i.MX8QM board";
    license = licenses.unfreeRedistributableFirmware;
  };
}
