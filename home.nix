{ config, pkgs, ... }: {
  # this is internal compatibility configuration
  # for home-manager, dont change this!
  home.stateVersion = "23.05";
  # Let home-manager install and manage itself.
  programs.home-manager.enable = true;
  home.packages = with pkgs; [ ];

  # vim setup
  home.sessionVariables = {
    EDITOR = "vim";
  };
  programs.vim = {
    enable = true;
    extraConfig = builtins.readFile(./vim_configuration);
    plugins = with pkgs.vimPlugins; [
      gruvbox
      nerdtree
      vim-nix
      vim-airline
      vim-airline-themes
      vim-gitgutter
      vim-devicons
      YouCompleteMe
    ];
  }; 

  # neovim setup but not working yet
  #programs.neovim = {
  #  enable = true;
  #  extraConfig = builtins.readFile(./init.lua);
  #};

  # tmux setup
  programs.tmux = {
    enable = true;
    shell = "${pkgs.fish}/bin/fish";
    #prefix = "C-q";
    baseIndex = 1;
    sensibleOnTop = false;
    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
    ];
    terminal = "screen-256color";
    extraConfig = ''
      set-option -g prefix C-q
      unbind-key C-q
      bind-key C-q send-prefix
      bind-key v split-window -h
      bind-key h split-window -v
      set -g mouse on
      bind -n S-Left previous-window
      bind -n S-Right next-window
      set-window-option -g mode-keys vi
      bind-key -T copy-mode-vi v send -X begin-selection
      bind-key -T copy-mode-vi v send -X selection-line
      bind-key -T copy-mode-vi y send -X copy-pipe-and-cancel 'xclip -in -selection clipboard'
    '';
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      cfg-vim = "vim ~/nix/vim_configuration";
      cfg-tmux = "vim ~/nix/home.nix";
      cfg-kit = "vim ~/nix/kitty_configuration";
    };
    interactiveShellInit = ''
      fish_vi_key_bindings
    '';
  };

  # kitty setup
  programs.kitty = {
    enable = true;
    extraConfig = builtins.readFile(./kitty_configuration);
  };

  # git setup
  programs.git = {
    enable = true;
    userName = "Kimang18";
    userEmail = "allenkhun22@gmail.com";
    ignores = [ ".DS_Store" ];
    defaultBranch = "main";
  };

  # aerospace setup
  home.file.".aerospace.toml".source = ./aerospace_configuration;
}
