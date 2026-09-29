# System monitors, wanted on every host regardless of role. Hardware-specific
# tools (e.g., amdgpu_top) belong in the host that has the hardware.
{
  programs.htop.enable = true;
  programs.btop.enable = true;
}
