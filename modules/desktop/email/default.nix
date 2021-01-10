{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.email;
  xdg = config.home-manager.users.ps.xdg;
in {
  options.modules.desktop.email = { enable = mkBoolOpt false; };
  config = mkIf cfg.enable {
    home-manager.users.ps = {
      programs.mbsync.enable = true;
      services.mbsync = {
        enable = true;
        preExec = "${xdg.configHome}/mbsync/preExec";
        postExec = "${xdg.configHome}/mbsync/postExec";
      };

      xdg.configFile."mbsync/preExec" = with pkgs; {
        text = ''
          #!${stdenv.shell}

          ${coreutils}/bin/mkdir -p $HOME/.mail/dhs
        '';
        executable = true;
      };
      xdg.configFile."mbsync/postExec" = with pkgs; {
        text = ''
          #!${stdenv.shell}

          ${mu}/bin/mu index
          ${emacsPgtkGcc}/bin/emacsclient -e '(mu4e-update-index)'
        '';
        executable = true;
      };
      programs.mu.enable = true;
      accounts.email = {
        accounts.dhs = rec {
          address = "pan.song@dhs.sg";
          userName = address;
          imap.host = "imap.gmail.com";
          primary = true;

          mu.enable = true;
          mbsync = {
            enable = true;
            create = "maildir";
            extraConfig.channel.MaxMessages = 10000;
            # Throttle mbsync so we don't go over gmail's quota.
            extraConfig.account.PipelineDepth = 10;
          };
          # gpg2 --output ~/dhs_pass.gpg --symmetric ~/dhs_password
          passwordCommand =
            "${pkgs.gnupg}/bin/gpg2 -q --for-your-eyes-only --no-tty -d ~/dhs_pass.gpg";
        };
        maildirBasePath = ".mail";
      };
    };
  };
}
