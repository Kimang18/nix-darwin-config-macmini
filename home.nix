{ config, pkgs, ... }: {
  # this is internal compatibility configuration
  # for home-manager, dont change this!
  home.stateVersion = "25.05";
  # Let home-manager install and manage itself.
  # config file setup
  xdg.configFile = {
    "aerospace/aerospace.toml" = {
      source = ./aerospace_configuration;
      force = true;
    };
    # ".config/kitty/gruvbox_cs/gruvbox_dark.conf".source = ./kitty/gruvbox_cs/gruvbox_dark.conf;
    # ".config/kitty/gruvbox_cs/gruvbox_light.conf".source = ./kitty/gruvbox_cs/gruvbox_light.conf;
    # ".config/kitty/tokyonight_night.conf".source = ./kitty/tokyonight_night.conf;
    "fish/functions/fish_prompt.fish" = {
      source = ./fish_prompt.fish;
      force = true;
    };
    "nvim/init.lua" = {
      source = ./init.lua;
      force = true;
    };
    "tmux/tmux.conf" = {
      source = ./tmux.conf;
      force = true;
    };
    "ghostty/config" = {
      source = ./ghostty.conf;
      force = true;
    };
    "zathura/zathurarc" = {
      source = ./zathura_configuration;
      force = true;
    };
  };

  programs.home-manager.enable = true;
  home.packages = with pkgs; [
    (pkgs.python3.withPackages (ppkgs: [
      ppkgs.numpy
      ppkgs.matplotlib
      ppkgs.ipython
      ppkgs.jupyter
      ppkgs.pyyaml
    ]))
  ];

  # vim setup
  home.sessionVariables = {
    EDITOR = "nvim";
  };
  # programs.vim = {
  #   enable = true;
  #   extraConfig = builtins.readFile(./vim_configuration);
  #   plugins = with pkgs.vimPlugins; [
  #     gruvbox
  #     nerdtree
  #     vim-nix
  #     vim-airline
  #     vim-airline-themes
  #     vim-gitgutter
  #     vim-devicons
  #     YouCompleteMe
  #   ];
  # }; 

programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      # quarto.quarto
      mvllow.rose-pine
      vscodevim.vim
      ms-python.python
      # ms-toolsai.jupyter
    ];
    # userSettings = {
    #   "quarto.render.renderOnSave" = true;
    # };
  };

  programs.neovim = {
    enable = true;
  };
  programs.yazi = {
    enable = true;
    settings = {
      mgr = {
        ratio = [
          1
          4
          3
        ];
      };
      keymap = {
        mgr.append_keymap = [
          {
            on =[ "g" "p" ];
            run = "cd ~/Documents/01_Projects";
            desc = "Go to project folders";
          }
        ];
      };
    };
  };
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    options = [ "--cmd cd" ];
  };

  #programs.ghostty = {
  #  enable = true;
  #  #shell = "${pkgs.tmux}/bin/tmux";
  #  #settings = {
  #  #  initial-command = "${pkgs.tmux}/bin/tmux"; # Or the path to your script
  #  #};
  #};

  # tmux setup
  programs.tmux = {
    enable = true;
    # shell = "${pkgs.fish}/bin/fish";
    #prefix = "C-q";
    # baseIndex = 1;
    # sensibleOnTop = false;
    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      #sensible
      catppuccin
      resurrect
      continuum
      cpu
      battery
    ];
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      cfg-vim = "vim ~/nix/vim_configuration";
      cfg-nvim = "nvim ~/nix/init.lua";
      cfg-tmux = "nvim ~/nix/home.nix";
      cfg-kit = "nvim ~/nix/kitty_configuration";
      god = ''cd "$(find ~/Documents ~/Downloads ~/Desktop ~/Movies ~/Music ~/Pictures -type d | fzf --height 40% --color 'border:#ffa07a,info:#ffff00' --border )"'';
    };
    interactiveShellInit = ''
      fish_vi_key_bindings
    '';
    functions = {
    };
  };

  # kitty setup
  programs.kitty = {
    enable = false;
    # extraConfig = builtins.readFile(./kitty_configuration);
  };

  # git setup
  programs.git = {
    enable = true;
    userName = "Kimang18";
    userEmail = "allenkhun22@gmail.com";
    ignores = [ ".DS_Store" ];
  };

}
