# V2.0.0 release — 2026-11-12

Mode: **ORIGINAL_FALLBACK**. V1 artifacts are preserved. Release target: [v2.0.0](https://github.com/james1507/shadow-protocol/releases/tag/v2.0.0). Attachments: macOS ZIP, Windows EXE, Linux executable, source ZIP and SHA256SUMS.

| Artifact | Validation |
|---|---|
| builds/v2/macos/ShadowProtocol-v2.zip | exported; entry-menu CLI smoke; native New Operation, new sprites, movement, EMP, pause and return to menu viewed; production save restored |
| builds/v2/windows/ShadowProtocol-v2.exe | exported x86_64, NOT RUN on Windows |
| builds/v2/linux/ShadowProtocol-v2.x86_64 | exported x86_64, NOT RUN on Linux |
| builds/v2/ShadowProtocol-v2-source.zip | git archive of v2.0.0: editable source, original assets and docs; excludes untracked files, caches, intake, binaries and logs |

macOS app is ad-hoc signed, not notarized. Verified extraction: builds/v2/macos/verified/Shadow Protocol- Blacksite Breach.app. Kept at main menu after native smoke. Source project includes debug CHARACTER LAB; release omits developer scenes and F3.

Official release binaries disable command-line scene/script path overrides. Only normal entry-menu CLI smoke is claimed; scene/campaign test harnesses run in source Godot. V2 complete campaign evidence is automated normal input with AI; no new full human-input V2 playthrough claim.

Binary SHA-256:

```text
0a309baaa875c2428526095b7a97d503f6328ba63f8811e17894e128e4b8b271  builds/v2/macos/ShadowProtocol-v2.zip
8b88b2c080775e3ac7cf1e7bd443683b9eb6fec88b713d20f0bc38995afb1308  builds/v2/windows/ShadowProtocol-v2.exe
e8261d290abccdb306126a0c3d152f03fde4be427b974cd586708f1e03aecdc2  builds/v2/linux/ShadowProtocol-v2.x86_64
```

Full checksums, including source ZIP, live outside source archive in builds/v2/SHA256SUMS. Export command: GODOT=/path/to/Godot tools/create_release.sh macOS (Windows/Linux likewise). V1 save schema remains compatible.

---

# V1 historical release report

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
