{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.i3;
in {
  options.modules.desktop.i3 = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    modules.theme.onReload.i3 = "${pkgs.i3-gaps}/bin/i3-msg restart";

    environment.pathsToLink = [
      "/libexec"
    ]; # links /libexec from derivations to /run/current-system/sw

    home.file = configDirWithFilter ".i3" (/. + "${configDir}/i3") notOrgFile;

    services.xserver = {
      enable = true;
      desktopManager = { xterm.enable = false; };
      displayManager = {
        defaultSession = "none+i3";
        autoLogin = {
          enable = true;
          user = "ps";
        };
      };
      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;
        extraPackages = with pkgs; [ rofi i3status go ];
      };
    };
  };
}
