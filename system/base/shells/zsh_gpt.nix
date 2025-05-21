{ config, lib, pkgs, ... }:

{
  config = {
    programs.zsh = {
      enable = true;
      enableCompletion = true;

      ohMyZsh = {
        enable = true;
        plugins = [
          "git"
          "virtualenv"
          "vi-mode"
        ];
        theme = "kennethreitz";
      };

      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;

      PromptInit = ''
        alias ls='lsd'
        alias l='ls -l'
        alias la='ls -a'
        alias lla='ls -la'
        alias lt='ls --tree'

        source <(fzf --zsh)
        HISTFILE=~/.zsh_history
        HISTSIZE=10000
        SAVEHIST=10000
        setopt appendhistory
      '';
    };

    users.users.nansus = {
      shell = pkgs.zsh;
    };

    environment.shells = with pkgs; [ zsh ];
  };
}
