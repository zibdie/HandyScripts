# FFmpeg


### Strip Metadata
```
ffmpeg -i input.mkv -map_metadata -1 output.mp4
```

### Video Color Correction (MW2 2009)
```
ffmpeg -i output.mp4 -vf "eq=brightness=0.02:contrast=1.15:saturation=1.25:gamma=1.05" -c:a copy output2.mp4
```

### Audio from Video Only
```
ffmpeg -i input.mp4 -f lavfi -i "color=black" -filter_complex "[1:v][0:v]scale2ref[blk][ref];[blk]setsar=1[v];[ref]nullsink" -map "[v]" -map 0:a:0 -c:v libx264 -pix_fmt yuv420p -tune stillimage -c:a aac -b:a 192k -shortest -map_metadata -1 -map_chapters -1 output_black.mp4
```

### Fade In
```
ffmpeg -i output2.mp4 -vf "fade=t=in:st=0:d=2" -af "afade=t=in:st=0:d=2" output3.mp4
```
* `-i input.mp4` — your input video.
* `-vf "fade=t=in:st=0:d=2"` — applies a fade-in effect:
* `t=in` → type of fade (fade in)
* `st=0` → start time (in seconds)
* `d=2` → duration of the fade (in seconds)
* `-c:a copy` — copies the original audio without re-encoding.
* `output.mp4` — the resulting video.
