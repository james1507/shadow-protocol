#!/usr/bin/env python3
"""Inventory local intake. No downloading, guessing licenses, or automatic adoption."""
import csv
import hashlib
import json
from pathlib import Path, PurePosixPath
import shutil
import struct
import zipfile

ROOT = Path(__file__).resolve().parents[1]
SOURCES = {name: f"https://kenney.nl/assets/{name}" for name in (
    "top-down-shooter", "sci-fi-rts", "ui-pack-sci-fi", "sci-fi-sounds",
    "interface-sounds", "impact-sounds", "game-icons", "music-jingles")}

SOURCES.update({
    "riclmbr_neon_city": "https://riclmbr.itch.io/pixel-cyberpunk-neon-city-300-top-down-cyberpunk-assets",
    "murphysdad_scifi_facility": "https://murphysdad.itch.io/sci-fi-facility",
})


def safe_extract(archive, target):
    """Reject traversal, symlinks, bombs, and nonportable member names before writes."""
    with zipfile.ZipFile(archive) as z:
        members = z.infolist()
        if sum(i.file_size for i in members) > 500_000_000:
            raise ValueError("Archive exceeds 500 MB intake limit")
        for item in members:
            path = PurePosixPath(item.filename)
            if (path.is_absolute() or ".." in path.parts or "\\" in item.filename
                    or ":" in item.filename or (item.external_attr >> 16) & 0o170000 == 0o120000):
                raise ValueError(f"Unsafe ZIP member: {item.filename}")
            if target.is_symlink() or not (target / item.filename).resolve().is_relative_to(target.resolve()):
                raise ValueError(f"ZIP member escapes through existing symlink: {item.filename}")
        z.extractall(target)


def dimensions(data):
    if data[:8] == b"\x89PNG\r\n\x1a\n" and len(data) >= 24:
        return struct.unpack(">II", data[16:24])
    return "", ""


def inventory():
    intake = ROOT / "incoming_assets"
    extracted = intake / "extracted"
    extracted.mkdir(parents=True, exist_ok=True)
    for archive in sorted(intake.glob("*.zip")):
        safe_extract(archive, extracted / archive.stem)
    rows, notes = [], []
    for pack in sorted(extracted.iterdir()):
        if not pack.is_dir():
            continue
        licenses = [p for p in pack.rglob("*") if p.is_file() and
                    ("license" in p.name.lower() or "readme" in p.name.lower())]
        text = "\n".join(p.read_text(errors="replace") for p in licenses)
        status = "CC0_TEXT_FOUND_REVIEW_REQUIRED" if "CC0" in text else "UNVERIFIED"
        source = SOURCES.get(pack.name, "UNKNOWN: review publisher URL")
        notes.append(f"- {pack.name}: {status}; {source}")
        for document in licenses:
            dest = ROOT / "docs/licenses" / pack.name / document.relative_to(pack)
            dest.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(document, dest)
        for path in sorted(pack.rglob("*")):
            if not path.is_file():
                continue
            data = path.read_bytes()
            width, height = dimensions(data)
            rows.append([pack.name, source, status, path.relative_to(intake).as_posix(),
                         "", hashlib.sha256(data).hexdigest(), width, height, "", len(data), path.suffix])
    output = ROOT / "docs/ASSET_INVENTORY.csv"
    output.parent.mkdir(parents=True, exist_ok=True)
    with output.open("w", newline="") as f:
        writer = csv.writer(f)
        writer.writerow(["source_pack", "source_url", "license_status", "original_path",
                         "destination_path", "sha256", "width", "height", "used_in_scene", "bytes", "extension"])
        writer.writerows(rows)
    lines = ["# Asset sources", "", "## Included original work", "",
             "All current visuals are original engine-native geometry, runtime-generated tiles,",
             "original pixel sprites (tools/build_spriteframes.gd), and icon.svg. Audio uses original synthesized PCM tones. Source code and original",
             "art are MIT licensed (LICENSE). Godot built-in font remains under engine licenses.",
             "No third-party packs currently adopted. No external runtime downloads.", "",
             "## Optional publisher pages (not included; archive license must be reviewed)", ""]
    lines += [f"- {name}: {url}" for name, url in SOURCES.items()]
    lines += ["", "## Intake audit", ""] + (notes or ["No archives supplied. Native original fallback active."])
    (ROOT / "docs/ASSET_SOURCES.md").write_text("\n".join(lines) + "\n")
    print(json.dumps({"files": len(rows), "packs": notes, "fallback": not rows}))


if __name__ == "__main__":
    inventory()
