# Brave Browser OLED Auto-Hide Tabs (AHK v2)

A bulletproof AutoHotkey v2 script that brings a native-like "auto-hide" feature to the Brave Browser tab bar and address bar. Designed specifically for **OLED monitor owners** to prevent burn-in and users who want a clean, distraction-free UI without sacrificing functionality.

Unlike simple overlay hacks, this script uses advanced Windows API calls and state management to ensure a seamless user experience.

---

## ✨ Features

* **OLED Burn-in Protection:** Covers the static tab/URL bar area with a customizable dark overlay when not in use.
* **Hysteresis Logic (No Flickering):** The overlay disappears instantly when your mouse hits the top screen edge ($y \le 6\text{px}$), but stays visible until your kursor moves past the threshold ($y > 95\text{px}$). This allows you to close tabs or click extensions without the overlay aggressively cutting back in.
* **Native Fullscreen Detection:** Automatically suspends itself when watching YouTube videos in full-screen or pressing F11. It detects the removal of the `WS_CAPTION` style, making it 100% reliable.
* **Multi-Monitor & Window Scaling Friendly:** Uses `WinGetClientPos` instead of regular window positioning, meaning it maps perfectly to Brave's viewport, ignoring invisible Windows 11 drop-shadow borders and handling screen transitions flawlessly.
* **Click-Through Capable:** Uses the `+E0x20` (WS_EX_TRANSPARENT) window style, so even if the overlay is visible, background clicks safely pass through to the browser.

---

## 🚀 Installation & Usage

1.  **Install AutoHotkey v2:** Make sure you have [AutoHotkey v2](https://www.autohotkey.com/) installed on your system (v1 is not supported).
2.  **Download the script:** Download `BraveAutoHideTabs.ahk` from this repository.
3.  **Run the script:** Double-click the file to launch it.

### ⌨️ Hotkeys
* `Ctrl + Alt + H` : Toggle the auto-hide engine on/off.
* `Ctrl + Alt + Q` : Safely exit the script.

### 🏠 Run on Windows Startup
To make it completely automated:
1. Press `Win + R`, type `shell:startup`, and hit Enter.
2. Create a shortcut to `BraveAutoHideTabs.ahk` and paste it into that folder.

---

## 🔧 Calibration (Crucial Step)

Every user has a different scaling setting, resolution, or might use the Bookmarks Bar. To make the overlay pixel-perfect for your setup, open `BraveAutoHideTabs.ahk` in a text editor and adjust these variables at the top:

```autohotkey
revealZone    := 6        ; Trigger zone to show tabs (px from the top of the window)
keepAliveH    := 95       ; Hysteresis zone to hide tabs (must be higher than overlayH)
overlayH      := 84       ; The exact height of your Brave tab + URL bar
themeColor    := "1E1E1E" ; Match this with your Brave dark theme background color
