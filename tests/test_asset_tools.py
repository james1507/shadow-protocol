#!/usr/bin/env python3
"""Stdlib regression checks for untrusted archive/mapping paths."""
from pathlib import Path
import struct
import sys
import tempfile
import zipfile
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'tools'))
from asset_inventory import safe_extract, dimensions
from prepare_assets import contained

with tempfile.TemporaryDirectory() as folder:
    base = Path(folder)
    archive = base / 'test.zip'
    for bad in ['../escape.txt', '/absolute.txt', 'C:/drive.txt', 'a\\b.txt']:
        with zipfile.ZipFile(archive, 'w') as z:
            z.writestr(bad, 'unsafe')
        try:
            safe_extract(archive, base / 'out')
        except ValueError:
            pass
        else:
            raise AssertionError(bad)
    outside = base / 'outside'
    outside.mkdir()
    target = base / 'out'
    target.mkdir()
    (target / 'link').symlink_to(outside, target_is_directory=True)
    with zipfile.ZipFile(archive, 'w') as z:
        z.writestr('link/escape.txt', 'unsafe')
    try:
        safe_extract(archive, target)
    except ValueError:
        pass
    else:
        raise AssertionError('Existing symlink escape')
    with zipfile.ZipFile(archive, 'w') as z:
        z.writestr('folder/safe.txt', 'safe')
    safe_extract(archive, target)
    assert (target / 'folder/safe.txt').read_text() == 'safe'
    try:
        contained(base, '../escape')
    except ValueError:
        pass
    else:
        raise AssertionError('Mapping traversal')
    assert dimensions(b'\x89PNG\r\n\x1a\n' + b'\0'*8 + struct.pack('>II', 31, 47)) == (31, 47)
    assert dimensions(b'bad') == ('', '')
print('Asset tool checks: 9 passed')
