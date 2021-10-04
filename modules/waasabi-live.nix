{ config, lib, pkgs, ... }:

let
  cfg = config.services.waasabi-live;
in
{
  options.services.waasabi-live = with lib; {
    enable = mkEnableOption "Automatically configure nginx to host the waasabi frontend on this machine"; 
    package = mkOption {
      type = types.package;
      description = "The static-files to serve on nginx, may be changed";
      default = pkgs.waasabi-live;
    };
  };
}
