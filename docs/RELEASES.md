# Local release artifacts

Godot 4.7.2 Standard official matching export templates; local exports, no hosted download or notarization.

| File | Bytes | SHA-256 | Verification |
|---|---:|---|---|
| builds/macos/ShadowProtocol.zip | 61173078 | `0260599b5d57747398360d99c57ed838d87ad4b96cd6a43877ea35b1c7b0386e` | Native desktop 3-level campaign completed; final build New/Continue and release entry-menu smoke passed |
| builds/windows/ShadowProtocol.exe | 109658016 | `df3db07b86c1af56d1f2ce2f2caf83ee809d0fb556c81eea0f7185d6d2d9011c` | BUILT, NOT RUN-TESTED on matching OS |
| builds/linux/ShadowProtocol.x86_64 | 74023632 | `e55912b29eac5c18d7003b1a3612e351d177502cf633b298d612f01818bcb94d` | BUILT, NOT RUN-TESTED on matching OS |

The campaign playthrough harness is source-only and excluded from exports. An external --script attempt was not used as exported campaign evidence. Official release templates are compiled with scene/script path overrides disabled. Entry-menu CLI smoke passed (exit 0); a direct scene override was correctly rejected with an engine error even though engine exit code was 0. All three missions were verified through native UI and the source-only campaign harness, not claimed as release CLI scene tests.

macOS: unpack ZIP and open `Shadow Protocol- Blacksite Breach.app`. Local ad-hoc signature is not Developer ID notarization for public distribution. Windows: run EXE. Linux: `chmod +x ShadowProtocol.x86_64`, then run on x86_64 Linux with graphical desktop.

Source: import project.godot in Godot 4.7.2 Standard and F5. Optional assets require no download for current original fallback. `GODOT=/path/to/Godot tools/create_release.sh [macOS|Windows|Linux]` rebuilds a preset when matching templates are installed.

Git: local repository initialized; files remain uncommitted; no remote created.
