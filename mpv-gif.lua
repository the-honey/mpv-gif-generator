-- Original by Ruin0x11
-- Ported to Windows by Scheliux, Dragoner7

-- Create animated GIFs with mpv
-- Requires ffmpeg.
-- Adapted from http://blog.pkh.me/p/21-high-quality-gif-with-ffmpeg.html
-- Usage: "g" to set start frame, "G" to set end frame, "Ctrl+g" to create.

require 'mp.options'
local msg = require 'mp.msg'

local options = {
    dir = "C:/Program Files/mpv/gifs",
    rez = 600,
    fps = 15,
}

read_options(options, "gif")


local fps

-- Check for invalid fps values
-- Can you believe Lua doesn't have a proper ternary operator in the year of our lord 2020?
if options.fps ~= nil and options.fps >= 1 and options.fps < 30 then
    fps = options.fps
else
    fps = 15
end

-- Check for max rez

-- Set this to the filters to pass into ffmpeg's -vf option.
-- filters="fps=24,scale=320:-1:flags=lanczos"
filters=string.format("fps=%s,scale=%s:-1:flags=lanczos", fps, options.rez)

-- Setup output directory
output_directory=options.dir

start_time = -1
end_time = -1
palette="%TEMP%palette.png"

function make_gif_with_subtitles()
    make_gif_internal(true)
end

function make_gif()
    make_gif_internal(false)
end

function make_gif_internal(burn_subtitles)
    local start_time_l = start_time
    local end_time_l = end_time
    if start_time_l == -1 or end_time_l == -1 or start_time_l >= end_time_l then
        mp.osd_message("Invalid start/end time.")
        return
    end

    mp.osd_message("Creating GIF.")

    -- shell escape
    function esc(s)
        return string.gsub(s, '"', '"\\""')
    end

    local pathname = mp.get_property("path", "")
    local trim_filters = esc(filters)
    if burn_subtitles then
        -- TODO: get current subtitle
        trim_filters = trim_filters .. string.format(",subtitles=%s", esc(pathname))
    end

    local position = start_time_l
    local duration = end_time_l - start_time_l

    -- first, create the palette
    args = string.format('ffmpeg -v warning -ss %s -t %s -i "%s" -vf "%s,palettegen" -y "%s"', position, duration, esc(pathname), esc(trim_filters), esc(palette))
    msg.debug(args)
    os.execute(args)

    -- then, make the gif
    local filename = mp.get_property("filename/no-ext")
    local file_path = output_directory .. filename

    -- increment filename
    for i=0,999 do
        local fn = string.format('%s_%03d.gif',file_path,i)
        if not file_exists(fn) then
            gifname = fn
            break
        end
    end
    if not gifname then
        mp.osd_message('No available filenames!')
        return
    end

    args = string.format('ffmpeg -v warning -ss %s -t %s -i "%s" -i "%s" -lavfi "%s [x]; [x][1:v] paletteuse" -y "%s"', position, duration, esc(pathname), esc(palette), esc(trim_filters), esc(gifname))
    os.execute(args)

    msg.info("GIF created.")
    mp.osd_message("GIF created.")
end

function set_gif_start()
    start_time = mp.get_property_number("time-pos", -1)
    mp.osd_message("GIF Start: " .. start_time)
end

function set_gif_end()
    end_time = mp.get_property_number("time-pos", -1)
    mp.osd_message("GIF End: " .. end_time)
end

function file_exists(name)
    local f=io.open(name,"r")
    if f~=nil then io.close(f) return true else return false end
end

mp.add_key_binding("g", "set_gif_start", set_gif_start)
mp.add_key_binding("G", "set_gif_end", set_gif_end)
mp.add_key_binding("Ctrl+g", "make_gif", make_gif)
mp.add_key_binding("Ctrl+G", "make_gif_with_subtitles", make_gif_with_subtitles)
