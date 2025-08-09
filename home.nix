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
  programs.neovim.enable = true;

  # tmux setup
  programs.tmux = {
    enable = true;
    shell = "${pkgs.fish}/bin/fish";
    #prefix = "C-q";
    baseIndex = 1;
    sensibleOnTop = false;
    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      #sensible
      catppuccin
      resurrect
      continuum
    ];
    terminal = "screen-256color";
    extraConfig = ''
      set-option -g prefix C-q
      unbind-key C-q
      bind-key C-q send-prefix
      set-option -g default-terminal 'screen-256color'
      set-option -g terminal-overrides ',xterm-256color:RGB'
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D
      bind-key v split-window -h
      bind-key h split-window -v
      bind-key u split-window "aerospace focus --window-id $(aerospace list-windows --all | fzf --height 40% --color 'border:#ffa07a,info:#ffff00' --border | cut -d'|' -f1 | tr -d '[:blank:]')"
      set -g mouse on
      bind -n S-Left previous-window
      bind -n S-Right next-window
      set -g renumber-windows on
      set -g @continuum-restore 'on'
      set -g @resurrect-strategy-nvim 'session'
      set -g @catppuccin_window_tabs_enabled on
      set -g @catppuccin_window_left_separator ""
      set -g @catppuccin_window_right_separator " "
      set -g @catppuccin_window_middle_separator " █"
      set -g @catppuccin_window_number_position "right"
      set -g @catppuccin_window_default_fill "number"
      set -g @catppuccin_window_default_text "#W"
      set -g @catppuccin_window_current_fill "number"
      set -g @catppuccin_window_current_text "#W#{?window_zoomed_flag,(),}"
      set -g @catppuccin_status_modules_right "directory date_time"
      set -g @catppuccin_status_modules_left "session"
      set -g @catppuccin_status_left_separator  " "
      set -g @catppuccin_status_right_separator " "
      set -g @catppuccin_status_right_separator_inverse "no"
      set -g @catppuccin_status_fill "icon"
      set -g @catppuccin_status_connect_separator "no"
      set -g @catppuccin_directory_text "#{b:pane_current_path}"
      set -g @catppuccin_date_time_text "%H:%M"
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
      cfg-nvim = "nvim ~/nix/init.lua";
      cfg-tmux = "vim ~/nix/home.nix";
      cfg-kit = "vim ~/nix/kitty_configuration";
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
    enable = true;
    extraConfig = builtins.readFile(./kitty_configuration);
  };

  # git setup
  programs.git = {
    enable = true;
    userName = "Kimang18";
    userEmail = "allenkhun22@gmail.com";
    ignores = [ ".DS_Store" ];
  };

  # config file setup
  home.file = {
    ".aerospace.toml".source = ./aerospace_configuration;
    ".config/kitty/gruvbox_cs/gruvbox_dark.conf".source = ./kitty/gruvbox_cs/gruvbox_dark.conf;
    ".config/kitty/gruvbox_cs/gruvbox_light.conf".source = ./kitty/gruvbox_cs/gruvbox_light.conf;
    ".config/kitty/tokyonight_night.conf".source = ./kitty/tokyonight_night.conf;
    ".config/fish/functions/fish_prompt.fish".source = ./fish_prompt.fish;
    ".config/nvim/init.lua".source = ./init.lua;
    ".config/ghostty/config".source = ./ghostty.conf;
    ".config/zathura/zathurarc".source = ./zathura_configuration;
  };
}
