-- Cursor theme
hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("XCURSOR_SIZE", "24")

-- Replace Omarchy's arrow-key focus and vim-key defaults.
for _, keys in ipairs({
  "SUPER + LEFT",
  "SUPER + RIGHT",
  "SUPER + UP",
  "SUPER + DOWN",
  "SUPER + L",
  "SUPER + J",
  "SUPER + K",
  "SUPER + E",
}) do
  hl.unbind(keys)
end

o.bind("SUPER + H", "Move window focus left", hl.dsp.focus({ direction = "l" }))
o.bind("SUPER + L", "Move window focus right", hl.dsp.focus({ direction = "r" }))
o.bind("SUPER + K", "Move window focus up", hl.dsp.focus({ direction = "u" }))
o.bind("SUPER + J", "Move window focus down", hl.dsp.focus({ direction = "d" }))

o.bind("SUPER + SHIFT + I", "Toggle window split", hl.dsp.layout("togglesplit"))
o.bind("SUPER + B", "Show key bindings", "omarchy-menu-keybindings")

-- Swap active window with the one next to it with SUPER + arrow keys.
o.bind("SUPER + LEFT", "Swap window to the left", hl.dsp.window.swap({ direction = "l" }))
o.bind("SUPER + RIGHT", "Swap window to the right", hl.dsp.window.swap({ direction = "r" }))
o.bind("SUPER + UP", "Swap window up", hl.dsp.window.swap({ direction = "u" }))
o.bind("SUPER + DOWN", "Swap window down", hl.dsp.window.swap({ direction = "d" }))

o.bind("SUPER + SHIFT + L", "Next workspace", hl.dsp.focus({ workspace = "e+1" }))
o.bind("SUPER + SHIFT + H", "Previous workspace", hl.dsp.focus({ workspace = "e-1" }))
o.bind("SUPER + SHIFT + K", "Former workspace", hl.dsp.focus({ workspace = "previous" }))

o.bind("SUPER + E", "Yazi", "omarchy-launch-tui yazi")

-- Replace Omarchy's generic keyboard backlight controls for this device.
hl.unbind("XF86KbdBrightnessUp")
hl.unbind("XF86KbdBrightnessDown")
o.bind("XF86KbdBrightnessUp", "Keyboard brightness up", "brightnessctl --device='asus::kbd_backlight' set +1", { locked = true, repeating = true })
o.bind("XF86KbdBrightnessDown", "Keyboard brightness down", "brightnessctl --device='asus::kbd_backlight' set 1-", { locked = true, repeating = true })
