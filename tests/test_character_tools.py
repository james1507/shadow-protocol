#!/usr/bin/env python3
"""Executable ART-02..06 license/intake gates with synthetic fixtures, not vendor claims."""
import hashlib
from pathlib import Path
import struct
import sys
import tempfile
import zipfile
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'tools'))
from inspect_character_pack import inspect, select_mode

with tempfile.TemporaryDirectory() as folder:
    root = Path(folder)
    intake = root / 'incoming_assets'
    intake.mkdir()
    archive = intake / 'fixture.zip'
    png = b'\x89PNG\r\n\x1a\n' + b'\0'*8 + struct.pack('>II', 128, 352)
    with zipfile.ZipFile(archive, 'w') as z:
        z.writestr('exact-name.png', png)
        z.writestr('LICENSE.txt', 'CC0; contradictory fixture: do not redistribute')
        z.writestr('assets.json', '{}')
    reports = inspect(intake, root / 'inventory.csv')
    assert reports[0]['files'][2]['width'] == 128
    assert reports[0]['file_count'] == 3
    assert reports[0]['license_status'] == 'LICENSE_REVIEW_REQUIRED'
    print('PASS ART-02 real paths, headers and archive hash fixture')
    for member in ['../escape', '/absolute', 'C:/drive', 'a\\b']:
        with zipfile.ZipFile(archive, 'w') as z: z.writestr(member, 'bad')
        try: inspect(intake, root / 'inventory.csv')
        except ValueError: pass
        else: raise AssertionError(member)
    info = zipfile.ZipInfo('symlink')
    info.create_system = 3
    info.external_attr = 0o120777 << 16
    with zipfile.ZipFile(archive, 'w') as z: z.writestr(info, 'outside')
    try: inspect(intake, root / 'inventory.csv')
    except ValueError: pass
    else: raise AssertionError('symlink')
    print('PASS ART-03 traversal and symlink archives blocked')
    registry = {'packs': {'riclmbr_neon_city': {'archive_available': True, 'license_verified': False}}}
    assert select_mode(registry, root) == 'ORIGINAL_FALLBACK'
    assert select_mode({'packs':{}},root) == 'ORIGINAL_FALLBACK'
    print('PASS ART-04 unverified/missing license fails closed')
    evidence = root / 'license.txt'
    evidence.write_text('Synthetic gate fixture; not evidence of any vendor license')
    record = {'archive_available': True, 'license_verified': True, 'raw_redistribution_allowed': True,
              'evidence': ['license.txt'], 'archive_path': 'incoming_assets/fixture.zip',
              'source_archive_sha256': hashlib.sha256(archive.read_bytes()).hexdigest()}
    registry['packs']['riclmbr_neon_city'] = record
    assert select_mode(registry,root) == 'PREMIUM_VERIFIED'
    record['source_archive_sha256'] = 'invalid'
    assert select_mode(registry,root) == 'ORIGINAL_FALLBACK'
    print('PASS ART-05 synthetic premium selection and hash rejection (real pack absent)')
    registry['packs'] = {'murphysdad_scifi_facility': dict(record, source_archive_sha256=hashlib.sha256(archive.read_bytes()).hexdigest())}
    assert select_mode(registry,root) == 'FREE_VERIFIED'
    print('PASS ART-06 synthetic free selection (real pack absent)')
print('Character intake checks: 5 passed')
