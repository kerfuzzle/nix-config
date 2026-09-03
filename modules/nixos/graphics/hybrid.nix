{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.hostConfig.nvidia;
in
{
  config = lib.mkIf (cfg.enable && cfg.hybrid.enable) (
    lib.mkMerge [
      {
        hardware.nvidia = {
          # Experiemental PRIME offload power management
          # Allows dGPU to power down fully when not in use
          powerManagement.finegrained = true;
          # Balances power between CPU and GPU depending on workload for improved perforamance per watt
          dynamicBoost.enable = true;

          # PRIME hybrid GPU support
          prime =
            let
              # Converts from lspci's domain:bus:device.function to xorg's PCI:bus@domain:device:function
              bdfToXorgBusId =
                bdfBusId:
                let
                  toDenaryString = hex: hex |> lib.fromHexString |> toString;
                  components = lib.custom.splitStringByDelimiters [ ":" "." ] bdfBusId |> map toDenaryString;
                  getComponent = builtins.elemAt components;
                in
                "PCI:${getComponent 1}@${getComponent 0}:${getComponent 2}:${getComponent 3}";
            in
            {
              # Use PRIME offload mode
              offload = {
                enable = true;
                # Use the wrapper `nvidia-offload COMMAND` to run on dGPU
                enableOffloadCmd = true;
              };

              # Set xorg PCI bus IDs
              intelBusId = if cfg.hybrid.intelBdfBusId == "" then "" else bdfToXorgBusId cfg.hybrid.intelBdfBusId;
              nvidiaBusId = bdfToXorgBusId cfg.hybrid.nvidiaBdfBusId;
              amdgpuBusId = if cfg.hybrid.amdBdfBusId == "" then "" else bdfToXorgBusId cfg.hybrid.amdBdfBusId;
            };
        };
        # Create symlinks for the dgpu and igpu in /dev/dri as the card numbers can change
        services.udev.packages = lib.mkIf cfg.hybrid.enable (
          let
            mkPciPath = bdfBusId: "dri/by-path/pci-${bdfBusId}-card";
            igpuBdfBusId =
              if cfg.hybrid.intelBdfBusId != "" then cfg.hybrid.intelBdfBusId else cfg.hybrid.amdBdfBusId;
          in
          [
            # Create a package in the store containing a lib/udev/rules.d directory so it is picked up by services.udev.packages
            (pkgs.writeTextDir "lib/udev/rules.d/61-gpu-offload.rules" ''
              SYMLINK=="${mkPciPath igpuBdfBusId}", SYMLINK+="dri/igpu"
              SYMLINK=="${mkPciPath cfg.hybrid.nvidiaBdfBusId}", SYMLINK+="dri/dgpu"
            '')
          ]
        );
      }
      # Only add hyprland wayland session entries if hyprland is enabled
      (lib.mkIf config.programs.hyprland.enable (
        let
          # --- Create wrappers for hyprland with different GPUs
          hyprland = lib.getExe' config.programs.hyprland.package "start-hyprland";
          # Use iGPU only, monitors connected to dGPU won't work
          # but dGPU will power off until a program is offloaded to it
          hyprland-igpu-wrapper = pkgs.writeShellScriptBin "hyprland-igpu" ''
            export AQ_DRM_DEVICES="/dev/dri/igpu"
            exec ${hyprland}
          '';
          # Primary renderer is iGPU, secondary is dGPU so that HDMI monitors are detected
          hyprland-hybrid-wrapper = pkgs.writeShellScriptBin "hyprland-hybrid" ''
            export AQ_DRM_DEVICES="/dev/dri/igpu:/dev/dri/dgpu"
            exec ${hyprland}
          '';
          # Primary renderer is dGPU, secondary is iGPU (Needs to be there otherwise builtin display doesn't work)
          hyprland-dgpu-wrapper = pkgs.writeShellScriptBin "hyprland-hybrid" ''
            export AQ_DRM_DEVICES="/dev/dri/dgpu:/dev/dri/igpu"
            exec ${hyprland}
          '';

          niri-igpu-wrapper = pkgs.writeShellScriptBin "niri-igpu" ''
            exec niri-session
          '';

          mkSessionPackage =
            {
              name,
              desc,
              exec,
            }:
            let
              formattedName = lib.replaceStrings [ " " ] [ "-" ] name;
            in
            # Write desktop file into share/wayland-sessions
            (pkgs.writeTextDir "share/wayland-sessions/${formattedName}.desktop" ''
              [Desktop Entry]
              Name=${name}
              Comment=${desc}
              Exec=${exec}
            '').overrideAttrs
              (_: {
                # Set providedSessions so that it is picked up by sessionPackages
                passthru.providedSessions = [ formattedName ];
              });
        in
        {
          # Add wrappers to path incase they need to be launched from a shell
          environment.systemPackages = [
            hyprland-igpu-wrapper
            hyprland-hybrid-wrapper
            hyprland-dgpu-wrapper
          ];

          services.displayManager.sessionPackages = [
            (mkSessionPackage {
              name = "Hyprland iGPU";
              desc = "Launch hyprland on the iGPU";
              exec = lib.getExe hyprland-igpu-wrapper;
            })
            (mkSessionPackage {
              name = "Hyprland Multi GPU";
              desc = "Launch hyprland with both iGPU and dGPU";
              exec = lib.getExe hyprland-hybrid-wrapper;
            })
            (mkSessionPackage {
              name = "Hyprland dGPU";
              desc = "Launch hyprland with dGPU as primary renderer";
              exec = lib.getExe hyprland-dgpu-wrapper;
            })
          ];
        }
      ))
    ]
  );
}
