# Shiro -- my laptop

{ ... }:
{
  imports = [
    ../personal.nix
    ./hardware-configuration.nix
  ];

  virtualisation.vmware.guest.enable = true;

  ## Modules
  modules = {
	  desktop = {
		  i3.enable = true;
      apps = {
        # discord.enable = true;
        rofi.enable = true;
        # skype.enable = true;
      };
      browsers = {
        default = "firefox";
        firefox.enable = true;
      };
      media = {
        documents.enable = true;
        graphics = {
          enable = true;
          raster.enable = false;
          vector.enable = false;
          sprites.enable = false;
	      };
      };
      term = {
        default = "xst";
        st.enable = true;
      };
    };
    editors = {
      default = "nvim";
      emacs.enable = true;
      vim.enable = true;
    };
    dev = {
      # cc.enable = true;
      # common-lisp.enable = true;
      # rust.enable = true;
      # lua.enable = true;
      # lua.love2d.enable = true;
    };
    hardware = {
      # audio.enable = true;
      # fs = {
      #  enable = true;
      #  ssd.enable = true;
      # };
    };
    shell = {
      direnv.enable = true;
      git.enable = true;
      # gnupg.enable = true;
      # weechat.enable = true;
      # pass.enable = true;
      tmux.enable = true;
      # ranger.enable = true;
      zsh.enable = true;
    };
    hardware = {

    };
    services = {
      # syncthing.enable = true;
      ssh.enable = true;
    };
    theme.active = "alucard";
  };


  ## Local config
  programs.ssh.startAgent = true;
  services.openssh.startWhenNeeded = true;

  # hardware.opengl.enable = true;
}
