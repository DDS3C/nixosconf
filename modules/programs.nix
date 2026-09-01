{ pkgs, ... }:

{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    extraPackages = with pkgs; [ ];
  };

  programs.niri.enable = true;

  programs.kdeconnect.enable = true;

  services.flatpak.enable = true;

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  programs.noctalia = {
    enable = true;
    systemd.enable = true;
  };

  # 1. Reguły Firewalla dla AudioRelay
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 59100 59200 ];
    allowedUDPPorts = [ 59100 59200 59716 ];
  };

  # 2. Konfiguracja wirtualnego mikrofonu w PipeWire
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    
    extraConfig.pipewire."99-audiorelay-virtual-mic" = {
      "context.modules" = [
        {
          name = "libpipewire-module-loopback";
          args = {
            "audio.position" = "FL,FR";
            "capture.props" = {
              "node.name" = "audiorelay-virtual-mic-sink";
              "node.description" = "Virtual-Mic-Sink";
              "media.class" = "Audio/Sink";
            };
            "playback.props" = {
              "node.name" = "Virtual-Mic";
              "media.class" = "Audio/Source";
              "node.description" = "Virtual Microphone (AudioRelay)";
              "node.passive" = true;
            };
          };
        }
      ];
    };
  };
}

