#!/usr/bin/env python3
"""Inventory real ZIPs without executing contents or guessing animation semantics."""
import argparse
import csv
import hashlib
import json
from pathlib import Path
import tempfile
from asset_inventory import ROOT, safe_extract, dimensions


def select_mode(registry, root=ROOT):
    for key, mode in [('riclmbr_neon_city', 'PREMIUM_VERIFIED'),
                      ('murphysdad_scifi_facility', 'FREE_VERIFIED')]:
        pack = registry.get('packs', {}).get(key, {})
        if not (pack.get('archive_available') and pack.get('license_verified')
                and pack.get('raw_redistribution_allowed') and pack.get('evidence')):
            continue
        archive = (root / pack.get('archive_path', '')).resolve()
        evidence = [(root / p).resolve() for p in pack['evidence']]
        if (not archive.is_relative_to((root / 'incoming_assets').resolve())
                or not archive.is_file() or any(not p.is_relative_to(root.resolve()) or not p.is_file() for p in evidence)):
            continue
        if hashlib.sha256(archive.read_bytes()).hexdigest() == pack.get('source_archive_sha256'):
            return mode
    return 'ORIGINAL_FALLBACK'


def inspect(input_dir, output):
    reports, rows = [], []
    for archive in sorted(input_dir.glob('*.zip')):
        with tempfile.TemporaryDirectory(prefix='shadow-art-') as folder:
            target = Path(folder)
            safe_extract(archive, target)
            report = {'archive': archive.name, 'sha256': hashlib.sha256(archive.read_bytes()).hexdigest(),
                      'license_status': 'LICENSE_REVIEW_REQUIRED', 'files': [], 'documents': [], 'metadata': []}
            for path in sorted(target.rglob('*')):
                if not path.is_file():
                    continue
                data = path.read_bytes()
                width, height = dimensions(data)
                relative = path.relative_to(target).as_posix()
                digest = hashlib.sha256(data).hexdigest()
                report['files'].append({'path': relative, 'bytes': len(data), 'sha256': digest,
                                        'width': width, 'height': height})
                if any(word in path.name.lower() for word in ('license', 'readme', 'copying')):
                    # Evidence only; CC0 substring never grants automatic adoption.
                    report['documents'].append({'path': relative, 'text': data[:100_000].decode('utf8', errors='replace')})
                if path.suffix.lower() in ('.json', '.aseprite', '.ase'):
                    report['metadata'].append(relative)
                rows.append([archive.stem, '', report['license_status'], relative, '', digest, width, height, '', len(data)])
            report['file_count'] = len(report['files'])
            reports.append(report)
    output.parent.mkdir(parents=True, exist_ok=True)
    with output.open('w', newline='') as stream:
        writer = csv.writer(stream)
        writer.writerow(['source_pack', 'source_url', 'license_status', 'original_path', 'destination_path',
                         'sha256', 'width', 'height', 'used_in_scene', 'bytes'])
        writer.writerows(rows)
    output.with_suffix('.json').write_text(json.dumps(reports, indent=2) + '\n')
    print(json.dumps({'archives': len(reports), 'files': len(rows), 'mode': 'ORIGINAL_FALLBACK' if not reports else 'REVIEW_REQUIRED'}))
    return reports


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--inventory', action='store_true')
    parser.add_argument('--input', type=Path, default=ROOT / 'incoming_assets')
    parser.add_argument('--output', type=Path, default=ROOT / 'docs/CHARACTER_PACK_INVENTORY.csv')
    args = parser.parse_args()
    inspect(args.input, args.output)
