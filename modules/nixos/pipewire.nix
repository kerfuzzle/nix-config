{
  pkgs,
  config,
  lib,
  ...
}:
{
  options.hostConfig.pipewire.enable = lib.mkEnableOption "pipewire" // {
    default = true;
  };
  config =
    let
      resample-quality = {
        "10-hires" = {
          "stream.properties" = {
            "resample.quality" = 14;
          };
        };
      };

      mkRule = key: value: props: {
        matches = [
          {
            ${key} = value;
          }
        ];
        actions = {
          update-props = props;
        };
      };
    in
    lib.mkIf config.hostConfig.pipewire.enable {
      # Allows pipewire to use the realtime scheduler for improved performance
      security.rtkit.enable = true;
      # Add alsa-utils so alsamixer can be used
      environment.systemPackages = with pkgs; [ alsa-utils ];
      services.pipewire = {
        enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        pulse.enable = true;
        jack.enable = true;

        wireplumber = {
          enable = true;
          # Sink/Node config
          extraConfig = {
            "alsa-rules" = {
              "monitor.alsa.rules" = [
                (mkRule "node.name" "alsa_output.pci-0000_00_1f.3.analog-stereo" {
                  # Assign a better description
                  "node.description" = "Built-in Output";
                  # Reduce the priority of the built-in audio so that other audio outputs are favoured
                  "priority.driver" = 100;
                  "priority.session" = 100;
                })
                (mkRule "node.name" "alsa_input.pci-0000_00_1f.3.analog-stereo" {
                  # Assign a better description
                  "node.description" = "Built-in Input";
                })
                (mkRule "node.name" "alsa_output.usb-MOONDROP_MOONDROP_Dawn_Pro_MOONDROP_Dawn_Pro-00.analog-stereo"
                  {
                    # Assign a shorter description
                    "node.description" = "MOONDROP Dawn Pro";
                  }
                )
              ];
            };
          };
        };

        extraConfig = {
          # Device config
          pipewire = {
            "hires" = {
              "context.properties" = {
                # Let pipewire pick the highest sample rate based on the content
                "default.clock.allowed-rates" = [
                  44100
                  48000
                  64000
                  88200
                  96000
                  128000
                  176400
                  192000
                  256000
                  352800
                  384000
                ];
              };
              "stream.properties" = {
                "resample.quality" = 14;
              };
            };

            "dawn-pro" = {
              "device.rules" = [
                (mkRule "device.product.name" "MOONDROP Dawn Pro" {
                  # Make DAC show up as headphones in GUI
                  "device.form-factor" = "headphone";
                })
              ];
            };
          };

          client = resample-quality;
          pipewire-pulse = resample-quality;
        };
      };
    };
}
