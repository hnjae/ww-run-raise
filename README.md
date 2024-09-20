ww. Utility to raise or jump an applications in KDE. It interacts with KWin using KWin scripts and it is compatible with X11 and Wayland. It also works with multiple screens. It is intended as a wmctrl alternative (only for the raising windows part) compatible with wayland.

# Installing

## Using non-nix distro

1. Download ww from this repository
2. Copy `ww` into your path. e.g.:

```sh
cp ww /usr/local/bin
```

Do not forget to install required packages. Read `flake.nix`'s `runtimeInputs` elements for requirements.

## Using `flake.nix`

**I highly recommend pinning or forking this repository, because its behavior can be changed at any time.**

Add this repo to your `flake.nix`:

```nix
{
  inputs = {
    # ...
    ww-run-raise = {
      url = "github:hnjae/ww-run-raise";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        devshell.follows = "devshell";
      };
    };
  }

  # ...
}
```

Add the `default` package to your system. If using home-manager:

```nix
  home.packages = [
    inputs.ww-run-raise.packages.${pkgs.stdenv.system}.default
  ];
```

# Usage

ww only works in KDE. It works in X11 and Wayland. Run `ww -h` to list parameters.

## Create shortcuts

You can use KDE custom shortcuts to add a custom shortcut that calls ww

![image](https://user-images.githubusercontent.com/227916/126187702-90105aff-32a4-48dd-95c9-a7c1a2623c9e.png)

## Using plasma-manager

Following is my snippets using `ww` with plasma-manager:

```nix
  xdg.desktopEntries."ww-terminal" = {
    name = "ww-terminal";
    exec = "ww -pn konsole -fc org.kde.konsole -d org.kde.konsole";
    type = "Application";
    noDisplay = true;
    startupNotify = false;
    settings = {
      "X-KDE-GlobalAccel-CommandShortcut" = "true";
    };
  };

  programs.plasma.shortcuts."services/ww-terminal.desktop"."_launch" = "Meta+E";
```

## Limitation

It seems that instances launched with the custom shortcut `ww` in KDE are recognized as a different app from original app. In my environment, when I run `flatpak permissions desktop-used-apps`, both `ww-terminal` and `org.kde.konsole` are listed as registered apps:

```
Table             Object                                  App                    Permissions        Data
desktop-used-apps video/quicktime                         org.kde.konsole        mpv,3,3            0x00
desktop-used-apps video/quicktime                         ww-terminal            mpv,3,3            0x00
```

It seems that KDE's custom shortcuts work by executing desktop entries, which causes these.

# TODO

Here some ideas of improvements that I'd like to explore, but my knowledge on kwin scripts doesn't allow me:

* Use a single kwin script with signals instead of loading and running one each time?
* pgrep 로 검색하지 말고, kwin 에게 물어서 윈도우가 켜져 있는지 확인할 것.
