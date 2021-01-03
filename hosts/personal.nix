{ config, lib, ... }:

with lib;
{
  ## Location config 
  time.timeZone = mkDefault "Europe/London";
  i18n.defaultLocale = mkDefault "en_US.UTF-8";

  ##
  modules.shell.bitwarden.config.server = "p.v0.io";
}
