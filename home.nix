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
  programs.neovim = {
    enable = true;
    # plugins = with pkgs.vimPlugins; [
    #   vim-airline
    #   vim-airline-themes
    # ];
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
    # terminal = "screen-256color";
    extraConfig = ''
      set -g default-command fish
      set-option -g prefix C-q
      unbind-key C-q
      bind-key C-q send-prefix
      set -g mouse on
      set-option -g default-terminal 'tmux-256color'
      set-option -g terminal-overrides ',xterm-256color:RGB'
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D
      bind-key v split-window -h
      bind-key h split-window -v
      bind-key u split-window "aerospace focus --window-id $(aerospace list-windows --all | fzf --height 40% --color 'border:#ffa07a,info:#ffff00' --border | cut -d'|' -f1 | tr -d '[:blank:]')"
      bind -n S-Left previous-window
      bind -n S-Right next-window
      set -g renumber-windows "on"
      set -g @continuum-restore "on"
      set -g @resurrect-strategy-nvim 'session'
      set -g @catppuccin_flavor "mocha"
      set -g @catppuccin_window_status_style "rounded"
      set -g @catppuccin_window_number_position "right"
      set -g @catppuccin_window_default_text "#W"
      set -g @catppuccin_window_current_fill "number"
      set -g @catppuccin_window_current_text "#W"
      set -g @catppuccin_date_time_text "%d.%m. %H:%M"

      set -g status-right-length 100
      set -g status-left-length 100
      set -g status-left "#{E:@catppuccin_status_session} "
      set -g status-right "#{E:@catppuccin_status_application}"
      set -agF status-right "#{E:@catppuccin_status_cpu}"
      set -ag status-right "#S #[fg=#{@thm_fg},bg=#{@thm_mantle}] #(tmux-mem-cpu-load --interval 2 | cut -d ' ' -f1 )#[default]"
      set -ag status-right "#{E:@catppuccin_status_uptime}"
      set -ag status-right "#{E:@catppuccin_status_date_time}"
      set -agF status-right "#{E:@catppuccin_status_battery}"
      run ${pkgs.tmuxPlugins.catppuccin}/share/tmux-plugins/catppuccin/catppuccin.tmux
      run-shell ${pkgs.tmuxPlugins.sensible}/share/tmux-plugins/sensible/sensible.tmux
      run-shell ${pkgs.tmuxPlugins.resurrect}/share/tmux-plugins/resurrect/resurrect.tmux
      run-shell ${pkgs.tmuxPlugins.continuum}/share/tmux-plugins/continuum/continuum.tmux
      run-shell ${pkgs.tmuxPlugins.cpu}/share/tmux-plugins/cpu/cpu.tmux
      run-shell ${pkgs.tmuxPlugins.battery}/share/tmux-plugins/battery/battery.tmux
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
    # ".config/nvim/diary_template.md".source = ./diary_template.md;
    ".config/ghostty/config".source = ./ghostty.conf;
    ".config/zathura/zathurarc".source = ./zathura_configuration;
  };
}
