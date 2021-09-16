{ config, lib, pkgs, ... }:

#let
#  blogGenerator = import /home/solomon/Development/haskell/blogGenerator/release.nix;
#in
{
  imports = [
    ./modules/home-manager/zshExtras.nix
  ];

  #nixpkgs.overlays = [
  #  (import ./overlays/graphqurl.nix)
  #  #(import.b/overlays/xmonad.nix)
  #];

  programs.home-manager.enable = true;

  home.username = "solomon";
  home.homeDirectory = "/home/solomon";
  home.stateVersion = "21.11";
  home.sessionPath = [
    "${config.home.homeDirectory}/.local/scripts"
    "${config.home.homeDirectory}/.local/bin"
    "${config.home.homeDirectory}/.cabal/bin"
  ];

  home.packages = with pkgs; [
    # Editors
    emacs
    vimHugeX

    # Chat/Communication
    discord
    slack
    zoom-us

    # General CLI Tools
    niv
    acpi
    batsignal
    exa
    fzf
    git
    gnugrep
    gnumake
    #graphqurl
    htop
    inetutils
    jq
    pass
    rclone
    ripgrep
    s3fs
    tree
    unzip
    wget
    yadm
    sqlite
    xclip

    # Dev Tools
    docker-compose

    # Media
    vlc                        # Video Player
    scrot                      # Screenshot Tool
    zathura                    # PDF Reader
    feh                        # Image Preview Tool
    obs-studio                 # Screencasting
    spotify

    # Pandoc Related
    pandoc                     # Conversion between markup formats
    (texlive.combine {
      inherit (texlive) tikz-cd scheme-full;
    })
    #texlive.combined.scheme-full # TeX Live environment for scheme-basic
    python37Packages.pygments  # A generic syntax highlighter
    poppler_utils              # A PDF rendering library

    # Games
    mudlet

    # Web Browsers
    firefox
    google-chrome

    # UI
    xmobar
    xmobar-solomon
    kmonad
    brightnessctl

    # Misc
    # blogGenerator
  ];

  home.sessionVariables = {
    VISUAL = "vim";
    EDITOR = "vim";
    SCRIPTS = "${config.home.homeDirectory}/.local/scripts";
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    userName = "ssbothwell";
    userEmail = "ssbothwell@gmail.com";
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableHistorySubstringSearch = true;
    autoSuggestions.highlightStyle = "fg=3";

    history = {
      expireDuplicatesFirst = true;
      extended = true;
      ignoreDups = true;
      ignoreSpace = true;
      save = 10000;
      share = true;
      size = 50000;
    };

    saveNoDups = true; # This should be in the history submodule but I dont own it.

    historySubstring = {
      highlightFound = "fg=green";
      highlightNotFound = "fg=red";
    };

    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.1.0";
          sha256 = "0snhch9hfy83d4amkyxx33izvkhbwmindy0zjjk28hih1a9l2jmx";
        };
      }
    ];

    initExtra = ''
      bindkey '^l' autosuggest-accept
      bindkey '^h' autosuggest-clear
      bindkey '^k' history-substring-search-up
      bindkey '^j' history-substring-search-down

      # Load Functions
      if [ -f ${config.home.sessionVariables.SCRIPTS}/functions ]; then
          source ${config.home.sessionVariables.SCRIPTS}/functions
      fi

      [ $TERM = "dumb" ] && unsetopt zle && PS1='$ '
    '';

    shellAliases = {
      ls = "exa -l";
      refresh = "exec $SHELL -l";
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      character = {
        success_symbol = "➜";
        error_symbol = "✗";
      };
      line_break.disabled = false;
    };
  };

  services.lorri.enable = true;

  services.picom = {
    enable = true;
    activeOpacity = "1.0";
    inactiveOpacity = "0.9";
    backend = "glx";
    fade = false;
    fadeDelta = 5;
    shadow = true;
    shadowOpacity = "0.75";
  };
}
