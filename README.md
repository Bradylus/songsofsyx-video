# Songs Of Syx Video Mod

This code mod attempts to fix various display issues like:
- borderless fullscreen not working on GNU/Linux.
- window not displayed on the correct monitor with borderless or windowed.
- unexpected use of exclusive fullscreen instead of borderless.

## Installing

Download the latest version from the [releases](https://github.com/Bradylus/songsofsyx-video/releases) page. Then extract the file in your mods folder.

- Linux: `~/.local/share/songsofsyx/mods`
- Windows: `%AppData%\songsofsyx\mods` (that should be something like `C:\users\your_user_name\AppData\Roaming\songsofsyx\mods`)

The directory structure under mods should look like this:

- mods
  - Video Settings Mod
    - V66
    - _Info.txt

Finally, run Songs Of Syx, then click the Launch button in the launcher window. You should be presented with the list of mods available. Click on "Video Settings Mod" to enable it and click the Play button.

## Known issues:

- Borderless and windowed behave the same if in windowed mode, the width/height are 100%. This is already the case in vanilla. Fixing this requires deeper changes.
