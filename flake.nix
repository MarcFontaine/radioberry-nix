{
  description = "Radioberry support for NIX";

  outputs = { self }:
    let
      soapyradioberry = prev: prev.pkgs.callPackage ./soapyradioberry.nix {};

      new_plugins = prev: oldArgs: {
          extraPackages = oldArgs.extraPackages ++ [ (soapyradioberry prev) ];
      };

      new_soapy_src = prev: old: {
        name =  "soapy-0.8.1-unstable-mf";
        src = prev.pkgs.fetchFromGitHub {
          owner = "pothosware";
          repo = "SoapySDR";
          rev = "fbf9f3c328868f46029284716df49095ab7b99a6";
          hash = "sha256-W4915c6hV/GR5PZRRXZJW3ERsZmQQQ08EA9wYp2tAVk=";
        };
      };

      new_soapy_remote_src = prev: old: {
        name =  "soapyremote-30-03-2025";
        src = prev.pkgs.fetchFromGitHub {
          owner = "pothosware";
          repo = "SoapyRemote";
          rev = "54caa5b2af348906607c5516a112057650d0873d";
          sha256 = "sha256-uekElbcbX2P5TEufWEoP6tgUM/4vxgSQZu8qaBCSo18=";
        };
      };
    in
    {
      overlays.soapysdr-with-plugins = final: prev:
        {
          soapysdr = prev.soapysdr.overrideAttrs (new_soapy_src prev);
          soapysdr-with-plugins = prev.soapysdr-with-plugins.override (new_plugins prev);
          soapyremote = prev.soapyremote.overrideAttrs (new_soapy_remote_src prev);
        };
      nixosModules.radioberry-driver = { config, lib, ... }:
        { options.radiobery-driver = lib.mkOption {
            default = config.boot.kernelPackages.callPackage ./radioberry-driver.nix {};
          };
        };
    };
}
