#!/usr/bin/env python3
"""Copy only exact explicitly reviewed CC0 mappings; never modify intake."""
import hashlib
import json
from pathlib import Path
import shutil
from asset_inventory import ROOT


def contained(base, relative):
    path = (base / relative).resolve()
    if not path.is_relative_to(base.resolve()):
        raise ValueError(f"Path escapes allowed folder: {relative}")
    return path


def prepare():
    mapping = json.loads((ROOT / "config/asset_mapping.json").read_text())
    for entry in mapping["assets"]:
        if entry.get("license_id") != "CC0-1.0" or entry.get("reviewed") is not True:
            raise ValueError("Asset requires explicit human-reviewed CC0 mapping")
        source = contained(ROOT / "incoming_assets/extracted", entry["source_pack"] + "/" + entry["source_relative_path"])
        dest = contained(ROOT / "assets", entry["destination"])
        if not source.is_file():
            print(f"WARNING: {source.name} missing; original native fallback retained")
            continue
        digest = hashlib.sha256(source.read_bytes()).hexdigest()
        if digest != entry.get("sha256"):
            raise ValueError(f"Reviewed hash mismatch: {source.name}")
        dest.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(source, dest)
        print(f"Copied {source.name} to {dest.relative_to(ROOT)}")
    print("Preparation complete; absent mappings use original procedural art.")


if __name__ == "__main__":
    prepare()
