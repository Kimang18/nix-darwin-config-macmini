{
  description = "Zenful nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/8809585e6937d0b07fc066792c8c9abf9c3fe5c4";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
      home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, home-manager }:
  let
    configuration = { pkgs, config, ... }: {

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = with pkgs; [
	htop
        fzf
        fish
        neovim
        vim
        tmux
	kitty
        poetry
	mkalias
      ];

      #environment.variables = {
      #  TERMINFO_DIRS = "${pkgs.kitty.terminfo.outPath}/share/terminfo";
      #};

      fonts.packages = [
          (pkgs.nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
      ];

      homebrew = {
        enable = true;
	casks = [
	  "autodesk-fusion"
          "aerospace"
          "the-unarchiver"
          "vlc"
	  "bambu-studio"
	];
        masApps = {
          "Vimari" = 1480933944;
          "Menu Bar Calendar" = 1558360383;
          "MonitorControlLite" = 1595464182;
        };
	onActivation.cleanup = "zap";
	onActivation.autoUpdate = false;
	onActivation.upgrade = false;
      };

      # configure to allow search for applications installed by Nix
      system.activationScripts.applications.text = let
      	env = pkgs.buildEnv {
	  name = "system-applications";
	  paths = config.environment.systemPackages;
	  pathsToLink = "/Applications";
	};
      in
      	pkgs.lib.mkForce ''
        # Set up applications.
        echo "setting up /Applications..." >&2
	    rm -rf /Applications/Nix\ Apps
	    mkdir -p /Applications/Nix\ Apps
	    find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
	    while read -r src; do
	      app_name=$(basename "$src")
	      echo "copying $src" >&2
	      ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
	    done
        '';

      # disable computer sleeping
      power.sleep.computer = "never";

      system.defaults = {
        dock = {
          # auto show and hide dock
          autohide = true;
          # remove delay for showing dock
	    autohide-delay = 0.0;
	    # how fast is the dock showing animation
	    autohide-time-modifier = 0.2;
	    expose-animation-duration = 0.2;
	    launchanim = false;
	    showhidden = true;
	    show-recents = false;
	    show-process-indicators = true;
	    orientation = "left";
	    mru-spaces = false;
	    persistent-apps = [
	      "${pkgs.kitty}/Applications/Kitty.app"
	      "/Applications/Safari.app"
	      "/Applications/BambuStudio.app"
	      "/System/Applications/Launchpad.app"
	      "/System/Applications/Calendar.app"
	      "/System/Applications/Mail.app"
	    ];
          wvous-br-corner = 10;
        };
	finder = {
	  FXPreferredViewStyle = "clmv";
	  AppleShowAllExtensions = true;
          ShowPathbar = true;
          ShowStatusBar = true;
	};
        magicmouse.MouseButtonMode = "TwoButton";
        menuExtraClock = {
          Show24Hour = true;
          ShowDate = 0;
          ShowDayOfMonth = true;
          ShowDayOfWeek = true;

        };
        NSGlobalDomain = {
          AppleMeasurementUnits = "Centimeters";
          AppleMetricUnits = 1;
          AppleScrollerPagingBehavior = true; # jump to the spot that's clicked on the scroll bar
          AppleShowScrollBars = "Always";
          AppleTemperatureUnit = "Celsius";
        };
        WindowManager.GloballyEnabled = false;
        #universalaccess.reduceMotion = true;
        controlcenter = {
          Bluetooth = true;
          Display = true;
          Sound = true;
        };
	loginwindow.GuestEnabled = false;
	screencapture.location = "~/Pictures/screenshots";
	screensaver.askForPasswordDelay = 10;

      };
      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      #programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      # declare the user that will be running `nix-darwin`
      users.users.kimangkhun = {
        name = "kimangkhun";
        home = "/Users/kimangkhun";
      };
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."macmini" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
	  home-manager.darwinModules.home-manager {
	    home-manager.useGlobalPkgs = true;
	    home-manager.useUserPackages = true;
	    home-manager.verbose = true;
	    home-manager.users.kimangkhun = import ./home.nix;
	  }
	  nix-homebrew.darwinModules.nix-homebrew {
	    nix-homebrew = {
	      enable = true;
	      # Apple Silicon only
	      enableRosetta = true;
	      # User owning the Homebrew prefix
	      user = "kimangkhun";
	    };
	  }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."macmini".pkgs;
  };
}
