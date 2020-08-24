# mpv-gif-generator *for windows*

![Yuri On Ice Example](https://i.imgur.com/6wIylNl.gif)

Original script created by [Ruin0x11](https://github.com/Ruin0x11), which you can find [here](https://gist.github.com/Ruin0x11/8fae0a9341b41015935f76f913b28d2a).
This is a port of his gif generator script for Windows.

# Requirements 
- Windows
- mpv
- ffmpeg with libass enabled–as long as you're using the zeronoe builds you're good!
 
# Installation

First of all, you must make sure `ffmpeg` is in your `%PATH%` and accesible via your command line. After ensuring this, clone or download as zip. Then, head to `%APPDATA%/mpv/scripts` and place `mpv-gif.lua` in there; if neither `%APPDATA%/mpv` nor `%APPDATA%/mpv/scripts` exist, you will have to create them. It's as easy as that!

# Configuration

After setup, and if you wish, create a `%APPDATA%/mpv/script-opts` directory if it isn't created already and write a `gif.conf` file to configure the script. The three options the script offers are:

* `dir` – Sets the output directory. Default is `C:/Program Files/mpv/gifs`.
* `rez` – Sets the resolution of the output gifs. Default is 600.
* `fps` – Sets the framerate of the output gifs. Default is 15. Don't go too overboard or the filesize will balloon.
 
## Hotkeys

* `g` - Start time
* `G` - End time
* `CTRL+g` - Export GIF
* `CTRL+G` - Export GIF with subtitles
