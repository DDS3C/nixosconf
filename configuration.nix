{ config, pkgs, ... }:

{
  imports =
    [ # Include the hardware scan and separate user modules
      ./hardware-configuration.nix
      ./modules/packages.nix
      ./modules/programs.nix
      ./modules/services.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Prevent ly from looking ass.
  boot.kernelParams = [
  "nvidia_drm.fbdev=1"
  "video=DP-1:1920x1080@165"
  "video=HDMI-A-1:1920x1080@60"
  ];

  # Polkit because fuckass niri refuses to do it on its own.
  security.polkit.enable = true;

  networking.hostName = "vanguard_rev2"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pl_PL.UTF-8";
    LC_IDENTIFICATION = "pl_PL.UTF-8";
    LC_MEASUREMENT = "pl_PL.UTF-8";
    LC_MONETARY = "pl_PL.UTF-8";
    LC_NAME = "pl_PL.UTF-8";
    LC_NUMERIC = "pl_PL.UTF-8";
    LC_PAPER = "pl_PL.UTF-8";
    LC_TELEPHONE = "pl_PL.UTF-8";
    LC_TIME = "pl_PL.UTF-8";
  };

  # Enable the trash (X11) windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.ly.enable = true;
  services.desktopManager.gnome.enable = true;

  # Configure keymap in trash display server (X11).
  services.xserver.xkb = {
    layout = "pl";
    variant = "";
  };

  # Configure console keymap.
  console.keyMap = "pl2";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."shvpk" = {
    isNormalUser = true;
    description = "shvpk";
    extraGroups = [ "networkmanager" "wheel" ];
initialPassword="2137";
  };

  # Allow unfree packages.
  nixpkgs.config.allowUnfree = true;

  # Allow actually sane fucking commands.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Probably won't ever need to edit this one.
  system.stateVersion = "26.05"; # Did you read the comment?

}
