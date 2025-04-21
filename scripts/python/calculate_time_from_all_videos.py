#!/usr/bin/env python3
import sys
import subprocess
from pathlib import Path
from shutil import which

# Ensure to install ffmpeg
# Chocolate (Windows): https://community.chocolatey.org/packages/ffmpeg
# Mac: https://formulae.brew.sh/formula/ffmpeg
# Linux: https://www.ffmpeg.org/download.html#build-linux

def find_ffprobe():
    fp = which("ffprobe")
    if fp is None:
        sys.exit("Error: ffprobe not found.")
    return fp

def get_duration_seconds(ffprobe_cmd: str, path: Path) -> float:
    cmd = [
        ffprobe_cmd,
        "-v", "error",
        "-show_entries", "format=duration",
        "-of", "default=noprint_wrappers=1:nokey=1",
        str(path)
    ]
    result = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    if result.returncode != 0:
        print(f"Warning: ffprobe failed on '{path.name}': {result.stderr.strip()}", file=sys.stderr)
        return 0.0
    try:
        return float(result.stdout.strip())
    except ValueError:
        print(f"Warning: could not parse duration for '{path.name}'.", file=sys.stderr)
        return 0.0

def format_ms(total_seconds: float) -> str:
    secs = int(round(total_seconds))
    m, s = divmod(secs, 60)
    return f"{m}m {s}s"

def main():
    ffprobe_cmd = find_ffprobe()
    files = sorted(Path.cwd().glob("*.mkv"))
    if not files:
        print("No .mkv files found in the current directory.")
        sys.exit(0)

    total = 0.0
    for path in files:
        dur = get_duration_seconds(ffprobe_cmd, path)
        total += dur
        print(f"{path.name:30} → {format_ms(dur)}")

    print("-" * 40)
    print(f"Grand total: {format_ms(total)}")

if __name__ == "__main__":
    main()
