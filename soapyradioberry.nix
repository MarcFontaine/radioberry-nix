{ lib
, stdenv
, fetchFromGitHub
, cmake
, soapysdr
, rpi ? "rpi-4"
}:

stdenv.mkDerivation rec {
  pname = "soapyradioberry";
  version = "0.0.0";
  src = fetchFromGitHub {
    owner = "pa3gsb";
    repo = "Radioberry-2.x";
    rev = "master";
    sha256 = "sha256-kJ8D6EukhDIkbv8qUgO+1uZaBOY3W9+yTKlkljAJ2lU=";
  };

  patches = [ ./0001-Fix-soapyradioberry-build.patch ];
  patchFlags = [ "-p4" ];
  
  sourceRoot = "${src.name}/SBC/${rpi}/SoapyRadioberrySDR";

  nativeBuildInputs = [ cmake soapysdr ];

  cmakeFlags = [
    "CXXFLAGS=-Wno-unused-parameter"
  ];

  meta = {
    description = "Soapy module for the Radioberry SDR";
    homepage = "https://github.com/pa3gsb/Radioberry-2.x/";
    license = with lib.licenses; [
    ];
    maintainers = with lib.maintainers; [ mafon ];
  };
}
