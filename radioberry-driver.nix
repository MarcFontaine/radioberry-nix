{ lib
, stdenv
, fetchFromGitHub
, kernel
, dtc
, rpi ? "rpi-4"
, fpgatype ? "CL016"
}:

stdenv.mkDerivation rec {
  pname = "radioberry";
  version = "0.0.0";
  src = fetchFromGitHub {
    owner = "pa3gsb";
    repo = "Radioberry-2.x";
    rev = "master";
    sha256 = "sha256-kJ8D6EukhDIkbv8qUgO+1uZaBOY3W9+yTKlkljAJ2lU=";
  };

  patches = [ ./0001-Disable-hidden-spyware.patch ];

  outputs = [ "out" "ko" "dts" "dev" "firmware" ];
  
  hardeningDisable = [ "pic" "format" ];

  nativeBuildInputs = [ dtc ] ++ kernel.moduleBuildDependencies;

  makeFlags = [
    "RPI=${rpi}"
    "FPGATYPE=${fpgatype}"
    "KERNELRELEASE=${kernel.modDirVersion}"
    "KERNEL_HEADERS=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"    
  ];

  buildFlags = [ "driver" "firmware"];

  installPhase = ''
    mkdir -p $out/bin
    mv SBC/${rpi}/device_driver/firmware/radioberry $out/bin/

    mkdir -p $ko/lib/modules/${kernel.modDirVersion}/
    mv SBC/${rpi}/device_driver/driver/radioberry.ko $ko/lib/modules/${kernel.modDirVersion}/

    mkdir -p $dts
    mv SBC/${rpi}/device_driver/driver/radioberry.dts $dts/
    mv SBC/${rpi}/device_driver/driver/radioberry.dtbo $dts/

    mkdir -p $dev/include
    mv SBC/${rpi}/device_driver/driver/radioberry_ioctl.h $dev/include/

    mkdir -p $firmware/lib/firmware
    cp "SBC/${rpi}/releases/dev/CL016/radioberry.rbf" $firmware/lib/firmware
  '';

  meta = {
    description = "Radioberry driver suite";
    homepage = "https://github.com/pa3gsb/Radioberry-2.x/";
    license = with lib.licenses; [
    ];
    maintainers = with lib.maintainers; [ mafon ];
  };
}
