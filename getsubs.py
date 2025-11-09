#!/usr/bin/env python3

import argparse
import os
import shutil
import sys
import tempfile
from pathlib import Path

import webvtt  # type: ignore
import yt_dlp  # type: ignore


def get_vtt(url: str, autogen_subs: bool, language: str = "en") -> str | None:
    """Download VTT subtitles using yt-dlp.

    Args:
        url: Video URL to download subtitles from
        autogen_subs: If True, download auto-generated subtitles; if False, manual subs
        language: Language code for subtitles (default: "en")

    Returns:
        VTT content as string, or None if not found
    """
    temp_dir = tempfile.mkdtemp()

    try:
        ydl_opts = {
            "skip_download": True,
            "writesubtitles": not autogen_subs,
            "writeautomaticsub": autogen_subs,
            "subtitleslangs": [language],
            "subtitlesformat": "vtt",
            "outtmpl": os.path.join(temp_dir, "%(id)s.%(ext)s"),
            "quiet": True,
            "no_warnings": True,
        }

        with yt_dlp.YoutubeDL(ydl_opts) as ydl:
            try:
                ydl.download([url])
            except Exception:
                return None

        # Find and read the VTT file
        for entry in Path(temp_dir).iterdir():
            if entry.suffix == ".vtt":
                return entry.read_text(encoding="utf-8")

        return None
    finally:
        shutil.rmtree(temp_dir, ignore_errors=True)


def print_vtt_lines(vtt_content: str) -> None:
    """Extract and print cleaned text lines from VTT subtitle content.

    Parses VTT format, extracts caption text, splits multi-line captions,
    removes trailing semicolons, filters empty lines, and removes consecutive
    duplicates. This handles common quirks in YouTube's subtitle formatting.

    Args:
        vtt_content: VTT file content as string
    """
    # Parse VTT content
    with tempfile.NamedTemporaryFile(
        mode="w", suffix=".vtt", encoding="utf-8"
    ) as temp_file:
        temp_file.write(vtt_content)
        temp_file.flush()

        raw_result: list[str] = []
        for caption in webvtt.read(temp_file.name):
            text: str = caption.text.strip()
            if text:
                raw_result.append(text)

    # Process lines: split by newlines, trim, remove empty, remove trailing semicolons
    # and remove consecutive duplicates before printing
    previous: str | None = None
    for line in raw_result:
        for subline in line.split("\n"):
            cleaned = subline.strip().rstrip(";").strip()
            if cleaned and cleaned != previous:
                print(cleaned)
                previous = cleaned


def main() -> None:
    """Main entry point for getsubs."""
    parser = argparse.ArgumentParser(
        description="Download and display subtitles from video URLs"
    )
    parser.add_argument("url", help="Video URL to download subtitles from")
    parser.add_argument(
        "-l",
        "--language",
        default="en",
        help="Language code for subtitles (default: en)",
    )

    args = parser.parse_args()

    # Try manual subtitles first, then auto-generated
    vtt_content = get_vtt(
        args.url, autogen_subs=False, language=args.language
    ) or get_vtt(args.url, autogen_subs=True, language=args.language)

    if not vtt_content:
        print("no subs found", file=sys.stderr)
        sys.exit(1)

    print_vtt_lines(vtt_content)


if __name__ == "__main__":
    main()
