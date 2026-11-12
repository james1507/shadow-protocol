# SHADOW PROTOCOL: BLACKSITE BREACH — MASTER BUILD SPECIFICATION V2.0

> **Edition:** **2.0 — Character Art & Animation Upgrade (12 November 2026)**  
> **Audience:** Codex autonomous coding agent + developer owner.  
> **Engine:** Godot **4.7.2 stable**, GDScript, desktop 2D top-down stealth action.  
> **Deliverable:** a playable **three-level game**, with high-quality, visually consistent character sprites, independently validated asset licensing, properly mapped four-direction animations, and an inspectable character showcase + AI debug overlay.  
> **This is a full, stand-alone spec.** It incorporates gameplay/architecture/testing from V1 plus new and overriding V2 art requirements. Use this document alone as the primary source of truth.

### V2 high-level changes

1. **Primary cohesive art kit:** [Pixel Cyberpunk: Neon City](https://riclmbr.itch.io/pixel-cyberpunk-neon-city-300-top-down-cyberpunk-assets) (Riclmbr, **paid**, price seen 2026-11-12: USD $4.54 sale / $6.99 standard; check live price). The publisher advertises CC0. It includes **50 animated 32×32 characters, 16×16 tiles, props, VFX, item/UI art and animation metadata**. **Do not claim to own the paid pack until its archive is present.**
2. **Free cohesive alternative:** [Sci-Fi Facility Asset Pack](https://murphysdad.itch.io/sci-fi-facility) (MurphysDad, free/name your price, explicit CC0), including **Spy and Hazmat** four-direction characters and laboratory tiles/objects. This is a smaller, less animated style and should not be falsely presented as including the premium pack animations.
3. **Additional optional sources:** Kenney CC0 UI/SFX and [DKZeus Sci-Fi Tileset and Character](https://dkzeuss.itch.io/sci-fi-all-in-one-asset-pack) (free with commercial-use language but **not confirmed CC0**; do not commit raw art without reviewed license), plus own created fallback art.
4. **Character roster, state-to-animation mapping, cosmetic layering, team readability, foot pivots, 4-direction art and 8-way physics, impact feedback, asset validation, showcase/test scene and art QA gates** are formal release requirements.
5. Any **no-AI-training/no-dataset asset restrictions** exclude the affected assets from the baseline portfolio/recruiter-evaluation project. Do not confuse “allowed in a commercial game” with “allowed in an AI training dataset”.
6. **No asset from an online page is included in this specification package**; the user downloads files from official pages into `incoming_assets/`. Codex must never invent spritesheets, frame layouts, prices, direct-download URLs or claimed tests.

### V2 precedence

The original Sections 0–21 below continue to define product and engineering scope. **Section 3A (new V2 character art specification) and Section 14A (V2 migration/acceptance)** override any earlier wording that makes *Kenney Top-down Shooter* the default character source. **The V2 primary character source is Riclmbr when the purchased ZIP is provided; otherwise Sci-Fi Facility CC0; otherwise original/procedural fallback.** All audio/UI/environment assets can remain Kenney CC0 where they pass the cohesion test.

---


> **Audience:** An autonomous coding agent (Codex) responsible for implementing, validating, documenting and packaging a playable Godot game from an empty directory.
>
> **Baseline incorporated:** V1.0 — 12 November 2026. **Current authoritative edition: V2.0**
> **Target:** Godot **4.7.2 stable**, **GDScript**, 2D top-down desktop game, single-player, keyboard + mouse, suitable for a public GitHub portfolio and a technical Godot interview.
>
> **IMPORTANT:** This is a BUILD SPECIFICATION, not a description of an existing game. The agent must implement the game and prove it runs. Never report a milestone completed unless the corresponding scenes/scripts exist and the validation steps pass.

---

## 0. NON-NEGOTIABLE AGENT EXECUTION CONTRACT

You are building a **playable, finished small game**, not a scaffold, slide deck, screenshots of a concept, or pseudocode. Work sequentially from Stage 0 to Stage 11 below, running tests after each stage. Follow the instructions in this order:

1. Inspect the working directory, OS, existing files and available `godot` executable. Do not overwrite user files without a backup. If the folder is empty, initialize a Godot project.
2. Target Godot **4.7.2 stable**. Use the Godot standard (non-.NET) editor and GDScript. Do not silently migrate to beta or rely on Godot 3 APIs.
3. Look for assets in `incoming_assets/`. Inspect archive contents and license documents; DO NOT assume archive internal filenames, tile sizes, spritesheets or animation names. Follow **Sections 3, 3A, 14A**, and `ASSET_SETUP_GUIDE_V2_VI.md`.
4. Try to acquire only assets through their official page or a verifiable, publisher-provided download endpoint. If downloads require a browser click, paywall, anti-bot, account or consent, **do not bypass**. Use a generated CC0-safe original/procedural art fallback, keep the game playable and write down which downloads the human should perform.
5. NEVER use copyrighted game sprites, music, recognizable characters, scraped images, or license-ambiguous media. CC0 assets may be committed; still record their original source and author in `docs/ASSET_SOURCES.md`.
6. Do NOT create fake tests, fake gameplay captures, fake benchmark measurements, fake downloadable builds or fake completion claims. Never write “tested” unless execution produced a real pass result.
7. No runtime or test dependencies requiring proprietary cloud APIs. No external network needed after initial asset acquisition. No Unity, Unreal, Flutter, Electron, web frontend or Python runtime for gameplay.
8. Code quality: typed GDScript when practical, focused responsibilities, descriptive names, reusable scenes, configurable `Resource` data and signals for decoupling. Avoid huge singleton scripts or circular autoload dependencies.
9. Make the game launch with **F6/F5 in editor and `godot --path .`** after import, including when all optional asset downloads are absent. An asset pack must NEVER be a build-time blocker.
10. If the engine binary is unavailable in the agent environment, generate the complete source/project, perform available static checks, and state precisely which runtime checks are BLOCKED; never claim runtime verification without it.
11. Use English for in-game UI, README, architecture docs and interview case studies. The assets guide for the user is Vietnamese. Keep spelling and nomenclature consistent.
12. Do not stop at an unrelated error. Fix and re-run gates, make small commits only if repository/user permissions allow, and leave a clear `IMPLEMENTATION_STATUS.md` listing actual state and limitations.

**Definition of done:** 3 authored levels with a coherent start-to-finish loop; functional player, enemies, mission objectives, interactions, combat, save/load, UI, audio/fallback, debug overlay, tests, docs and a distributable build when export templates are available. See Section 20.

---

## 1. PRODUCT BRIEF & PLAYER EXPERIENCE

**Name:** Shadow Protocol: Blacksite Breach

**Pitch:** A stealth operative infiltrates a restricted research facility to recover classified research. Evade patrol guards, security cameras and drones. Use keycards, short EMP bursts, non-lethal stun tools and terminals to reach a data vault and escape before the security system locks down.

**Genre:** 2D top-down tactical stealth/action game with deliberate combat and lightweight puzzle elements.

**Reference mood (not license to copy):** industrial sci-fi, readable geometric silhouettes, dark navy base, cyan interactive objects, orange suspicious indicators, red danger alarms, simple character animations.

**Core loop:** scout corridor → observe patrol/vision cones → move silently or distract enemies → collect access card → interact with terminal → unlock secured route → acquire objective → extract → level result.

**Primary differentiator for technical portfolio:** inspectable Enemy AI with deterministic state transitions and an F3 Developer Overlay that visualizes sensing, navigation and performance. The source should be easy to convert into reproduce/debug/evaluate tasks.

**Audience:** Recruiters / developers reviewing a 5–12-minute gameplay demonstration and the underlying Godot project.

**Release scope:** Windows, macOS and Linux desktop source-first. Export desktop builds when possible. HTML5/web is optional after desktop quality gates, not an alternative to the native build.

**Display:** internal reference 640×360, integer-scaled viewport/window 1280×720; aspect 16:9; canvas items / Nearest filter for pixel art; letterbox to avoid distortions; 60 physics FPS. UI may use higher resolution fonts if readable.

**Game length:** 15–25 minutes for all three levels on Normal, with a 5–8-minute short path for video demonstration. No open-world, networking, microtransactions or online accounts.

---

## 2. USER STORY, CONTROLS, RULES AND BALANCE

### 2.1 Controls / Input Map

| Action ID | Keyboard / Mouse | Behavior |
|---|---|---|
| `move_up` / `move_down` / `move_left` / `move_right` | W/S/A/D + arrows | Normalized 8-way movement |
| `sprint` | Left Shift (hold) | Increased speed, consumes stamina, produces hearing event |
| `crouch` | Left Ctrl (hold) | Reduced speed, reduced enemy detection/noise |
| `interact` | E | Interaction target nearest within range and with line of sight |
| `attack` | Left mouse | Non-lethal stun baton swing/short shock projectile (configurable; see 6.5) |
| `gadget` | Q | EMP pulse if one is available |
| `reload_checkpoint` | R on Game Over only | Respawn at checkpoint; do not hijack R in normal play |
| `pause` | Esc | Pause, resume, settings, restart, quit to menu |
| `developer_overlay` | F3 | Debug stats / AI visuals in debug builds; disabled in release by default |
| `dev_spawn` | F4 | Optional debug-only test helper; never enabled in standard play |
| `ui_accept` | Enter/Space | Menus and confirmations |

Implement in `project.godot` InputMap. Mouse cursor used for aiming; the player's facing direction updates reliably while stationary. Keyboard-only interaction and menu support are mandatory.

### 2.2 Movement and health (initial tuning)

- Player walking speed **95 px/s**, sprint **145 px/s**, crouch **58 px/s**. Separate configurable player balance resource.
- Player max health **100**, max stamina **100**, sprint drain **24/s**, regen **18/s** after **0.6 s** without sprinting. No sprint if stamina below 10; resumes after recovery; clamp never negative.
- Interaction distance **40 px**, attack cooldown **0.55 s** and usable range **43 px**. Attack causes **1.5 s stun** and does not instantly kill ordinary guards. Consider adding upgrades only after base game is stable.
- Enemy attacks have clear wind-up of at least **0.35 s**, range limited by physics check, cooldown **1.25 s**, damage **15** from guard and **10** from drone pulse. No damage through walls.
- Health pickup restores **30** up to max; EMP charge max carry **3**, starts with **1** on Normal difficulty.
- Difficulty: Normal only required, Easy optional. No upgrade economy, crafting or experience levels in v1.

All numbers are defaults exposed via `.tres` Resources; values may be tuned from playtesting, with changes documented.

### 2.3 Win/fail conditions

- Win a level only when **all mandatory objectives are complete** AND the player enters/unlocks extraction while alive.
- Lose when `health <= 0`; show Game Over and offer retry from last checkpoint or main menu.
- Pause works in gameplay but does not progress timers or animations with wrong processing modes.
- A collected keycard/terminal should not trigger twice or duplicate rewards.
- If the player enters extraction early, show exactly which prerequisite is missing; do not soft-lock or advance.

---

## 3. ASSETS: VERIFIED SOURCES, EXACT DOWNLOAD STEPS, LICENSES AND ADOPTION POLICY

### 3.1 Download matrix (official product pages)

**V2 NOTICE:** The matrix below is retained as the V1 **supporting/fallback** asset catalog, NOT the final character-art priority. See Sections **3A.1–3A.4** for the authoritative V2 primary/free character kits. In particular, "Required preference" for a Kenney pack means a V1 suggestion only; it is **not a purchase/download requirement** and must not supersede V2 character selection.


**The source links are official product pages, not invented direct ZIP links.** User can click **Download**, then **Continue without donating...** if that modal appears, and save the resulting archive. Assets are not assumed to download automatically from terminal.

| Pack / exact official URL | Role | Priority | License shown on publisher's page |
|---|---|---|---|
| Kenney Top-down Shooter — https://kenney.nl/assets/top-down-shooter | Characters, top-down props, floor/furniture candidates, projectile art | **Required preference** | CC0 |
| Kenney Sci-Fi RTS — https://kenney.nl/assets/sci-fi-rts | Sci-fi structure/building/prop candidates; **do not assume compatible perspective** | Optional | CC0 |
| Kenney UI Pack — Sci-Fi — https://kenney.nl/assets/ui-pack-sci-fi | Menu panels, buttons, sci-fi widget skins | **Required preference** | CC0 |
| Kenney Sci-Fi Sounds — https://kenney.nl/assets/sci-fi-sounds | Terminal, security, drone, warning sound candidates | Recommended | CC0 |
| Kenney Interface Sounds — https://kenney.nl/assets/interface-sounds | UI clicks, hover, confirm, error | Recommended | CC0 |
| Kenney Impact Sounds — https://kenney.nl/assets/impact-sounds | Combat hits, collision impact | Recommended | CC0 |
| Kenney Game Icons — https://kenney.nl/assets/game-icons | HUD/input / item icon candidates | Optional | CC0 |
| Kenney Music Jingles — https://kenney.nl/assets/music-jingles | Optional menu/completion sting; **not a substitute for an appropriate ambient loop** | Optional | CC0 |
| Godot editor 4.7.2 stable — https://godotengine.org/download/archive/4.7.2-stable/ | Game engine, NOT a game asset | Required | Godot's own engine license |

**V1 asset verification note (2026-11-12):** Official Kenney page labels for these packs state CC0. Recheck each pack's actual downloaded license text. If a future download changes licensing, its license file controls; never assume a third-party mirror is equally licensed. Full URLs and validation policy belong in `docs/ASSET_SOURCES.md`.

**Warning:** Kenney *Top-down Shooter* contains zombie-themed/modern assets and Kenney *Sci-Fi RTS* may be RTS-perspective. They are **not guaranteed to be a ready-made cohesive cyberpunk stealth pack**. Adapt palettes/layouts carefully, and use procedurally drawn original guard/drone/security shapes where necessary. Never blindly claim “four-direction walking/attack sprites” exist before inspecting PNG dimensions and animations. An unanimated sprite is allowed initially; draw animated facing/motion via Godot if needed.

### 3.2 Human downloads — macOS

**V2 order:** first download **Riclmbr** (only after user buys) OR **MurphysDad free** (recommended to try), then optional Kenney CC0 UI/audio. Follow Section 3A.2/3A.3 before the older Kenney process below.


1. Open each official pack URL in a browser.
2. Check **License: Creative Commons CC0** on that pack's page.
3. Press **Download**. When a support/donation screen appears, click **Continue without donating...** if you want the free pack. Do not click a paid bundle by mistake.
4. Save archive in `~/Downloads/` (browser may rename archives; avoid guessing filenames).
5. Create `<repo>/incoming_assets/` and put the downloaded archives there. The original archives may remain **git-ignored** as intake artifacts.
6. In Terminal run `cd <repo>`; `mkdir -p incoming_assets`; `find incoming_assets -maxdepth 2 -type f` to confirm files.
7. For each ZIP, run `unzip -l "incoming_assets/<actual-file>.zip" | head -50` and extract it to `incoming_assets/extracted/<pack-id>/` (or have the agent perform these steps on actual downloaded archives).
8. Do NOT arbitrarily rename or move assets inside the source ZIP first. Record original source name, source license, actual dimensions and original filenames in the manifest.
9. Agent should copy only selected necessary CC0 assets into `assets/`, normalize their naming, and keep a mapping back to original paths. Avoid committing duplicate pack folders or unnecessary large preview images.
10. Open project in Godot and allow import to complete; assign Texture/CanvasItem filtering and atlas regions as verified by the pack's actual image geometry. If no download is available, continue with fallback assets.

### 3.3 Required project-side asset ingestion scripts

Implement `tools/asset_inventory.py` using **Python 3 standard library** (`zipfile`, `pathlib`, `hashlib`, `csv`, `struct`, `json`; optional Pillow only if already available). It must:
- Enumerate archives and extracted assets; reject unsafe paths when extracting (ZIP path traversal).
- Read PNG width/height from header; list extensions, sizes, SHA-256 and apparent folders.
- Detect and copy original license/readme files into `docs/licenses/` when found.
- Emit `docs/ASSET_INVENTORY.csv` and `docs/ASSET_SOURCES.md` with attribution/CC0 source links and sha hashes.
- Report any unknown/missing license or unsupported files; **do not label unverified packs CC0**.
- Output clearly: `source_pack,source_url,license_status,original_path,destination_path,sha256,width,height,used_in_scene`.
- Identify pixel atlas/spritesheets *only after* examining layout; no hard-coded slicing based on guessed tile sizes.

Implement `tools/prepare_assets.py` that reads a **human-reviewed** `config/asset_mapping.json` and copies exact vetted files to project folders. The mapping has `source_pack`, `source_relative_path`, `destination`, `license_id`, `usage`, `frame_width`, `frame_height` (frame fields optional). Missing source file should produce a **reported warning + placeholder fallback** rather than crashing the entire project. Do not download from arbitrary URL or mutate original source ZIPs.

### 3.4 Placeholder / original fallback (must ship)

The game must play with **zero external downloads**, by using original engine-native visuals:
- Draw floor/wall/door grids with simple shapes, gradient-free flat colors or original generated pixel textures.
- Draw player and guards with clearly differentiated colored polygon/Polygon2D bodies, arrow facing indicator and simple `AnimationPlayer` bob/rotate/flash effects.
- Draw security cameras, terminal, keycard, health pack, EMP and extraction marker using original polygonal silhouettes; ensure each is identifiable at 640×360.
- Use Godot UI controls with original simple StyleBoxFlat and Font resources if Kenney UI not installed.
- Use silent fallback AudioStream logic if no sound files. Never access missing audio `res://` paths.

**Important:** Temporary fallback is not an excuse to ship an ugly final result if the requested packs are available. The final game should have consistent visual treatment and a documented asset mapping; fallback is for reliability.

### 3.5 Final asset folder contract

```
assets/
  characters/player/         # actual used sprites, if licensed/available
  characters/enemies/
  environment/floors/
  environment/walls/
  environment/doors/
  environment/props/
  items/
  effects/
  ui/
  audio/sfx/
  audio/music/
  fonts/
  generated/                # original fallback art
incoming_assets/            # git-ignored incoming ZIPs
config/asset_mapping.json   # exact mapping for selected source files
docs/ASSET_INVENTORY.csv
docs/ASSET_SOURCES.md
docs/licenses/
```

Any original assets created by the project must be clearly distinguished from third-party ones. Do not depend on a font without permission to redistribute it; built-in Godot fonts are acceptable.

---


## 3A. V2 MANDATORY CHARACTER VISUALS & ASSET PRODUCTION PIPELINE

> **This section is new in V2 and overrides V1 priority and assumptions.** It is mandatory, including when only free assets are available. Work on this section after the game first boots, not in place of building gameplay.

### 3A.1 Final art direction and quality bar

**Style:** restrained dark cyberpunk / industrial research facility, readable 32×32 pixel-art humanoids, cool cyan for player/interactions, warm amber guards, crimson alarm/heavy threats, violet android/EMP effects. Quality comes from coherent silhouettes, motion, lighting and spatial staging rather than randomly adding large artwork. All colors below are **design suggestions**, not promises about colors inside purchased art:

| Semantic | Suggested palette | Usage |
|---|---|---|
| Main background | `#0D1524`, `#172338` | Floors, empty floor, shadowed background |
| Player identity | `#54D8E8` | Agent/team outline/optional accessory |
| Regular guards | `#F4B860` | Detection alert/status, distinguish from player |
| Heavy guard | `#F16D70` | Danger and armor details |
| Drone/robot | `#B29BFF` | Electronics/EMP stun visibility |
| Positive interaction | `#47DBB4` | Hack completed / collectible |
| Failure/alarm | `#F45C69` | Damage, lockdown, warning |
| Light neutral UI | `#DFE7F1` | Labels, mission text and numbers |

**Hard pass requirements:** characters do not blur, have transparent backgrounds, have a stable foot anchor, face correct direction, do not visibly teleport between idle/walk/attack animations, are distinguishable at 640×360 and do not look like unrelated art styles. A hero at 32×32 pixels should be readable in a still screenshot and a 5-second play clip. Show nearest-neighbor scaled 2x/4x views in the character showcase. Keep UI text readable; avoid full-screen postprocessing that hides pixel detail.

### 3A.2 Primary preferred kit — Riclmbr Pixel Cyberpunk: Neon City (paid, coherent)

**Publisher page:** https://riclmbr.itch.io/pixel-cyberpunk-neon-city-300-top-down-cyberpunk-assets  
**Publisher:** Riclmbr  
**Price checked 2026-11-12:** USD **$4.54** displayed sale, **$6.99** list; price can change. **No payment is made by Codex.**  
**License claim on page:** **CC0 1.0**, personal and commercial reuse, attribution not required. **Confirm downloaded license README/metadata, preserve its content.**  
**Downloads after purchase:** page advertises `PixelCyberpunkNeonCity.zip` (~2.9 MB); exact ZIP filename, internal paths, file count and metadata schema must still be inspected after user downloads it.  
**Page-advertised contents:** ~50 animated characters (32×32 cells), each idle + walk 4 dirs, attack 3 dirs, hurt, death; 11 animations / 36 frames per character; 16×16 tiles, items, props, FX, UI; `assets.json`, strips and sheets, GIF previews, instructions. The page says a **128×352** character sheet is one provided format (4 columns × 11 rows of 32×32 *slots*). **36 filled frames over 44 grid slots does not imply every slot is populated or imply a row ordering. The importer MUST read `assets.json`/README/animation strips and validate all frame/row mappings; never assume row 0 is `idle_down` or each row has four valid frames.**

**Recommended casting; select these by actual names when the ZIP confirms them:**

| Gameplay actor | Candidate in same source pack | Readability role | Animation states to prioritize |
|---|---|---|---|
| Player `AGENT-07` | **Netrunner** or **Mercenary** | Cyan signature, stealth operative | idle, walk, attack, hurt, KO, interact overlay |
| Alternate player skin (optional) | **Hacker Girl** or **Street Samurai** | Showcase variation, not new gameplay | idle, walk, attack, KO |
| Guard | **Security Guard** | Standard patrol silhouette | walk, idle, attack, hurt, KO |
| Guard alternate | **Police Officer** or **Corp Agent** | Visual variation with same AI logic | idle, walk, attack, hurt |
| Heavy Guard | **SWAT** or **Riot Cop** | Armored / stronger hit telegraph | idle, walk, attack, hurt, KO |
| Drone | **Security Bot** or **Combat Android** | Mechanical enemy with EMP reaction | idle/walk attack + EMP VFX |
| Special security sentry | **Holo Guard** or **Mech Trooper** | Accent for Level 3 | idle/walk, attack, KO |
| Neutral scientist NPC | **Scientist** | Non-hostile / narrative cue | idle, walk |
| Neutral engineer NPC (optional) | **Techie** | Hacking / maintenance cue | idle, walk |
| Corp officer (optional) | **Corp Executive** | Mission intro/profile | idle only |

**Do NOT instantiate 50 NPCs because 50 are available.** Ship 1 player, 2 guard visuals, 1 heavy, 1 drone, 1 story NPC, optionally 1 alternate hero + 1 sentry. More art increases quality only if justified by game logic. **NPCs must not contain extra AI behavior merely to show sprites**.

**Use corresponding assets from same kit when confirmed:** lab/server metal floor, wall, grate, hazard stripe, security door/airlock analog, server rack, console/terminal, data core, keycard, EMP, stun baton effect, surveillance drone/camera, health icon, hologram. Avoid using street billboards/cars in restricted indoor laboratory simply because they are available. Keep the original three indoor levels' geography and mechanics intact.

**Purchase/download steps (manual; do not fabricate programmatic paid URLs):**
1. Open the official publisher page above, confirm author/product, latest license/price and `Buy Now`.
2. Complete checkout personally if the user wants premium art; Codex must never purchase, request payment details, or access the account.
3. On the purchase/download page, select the archive for this specific pack, save to `~/Downloads/`; open Finder if necessary to locate the actual downloaded filename.
4. Create `<repo>/incoming_assets/` and move the **original ZIP** there unchanged. Keep it ignored by Git; do not rename internal files yet.
5. Tell Codex: `Use V2 premium pack from incoming_assets; run full inventory, inspect the animation metadata, license, preview and class roster before importing.`
6. After inspecting the actual files, save only selected, needed CC0 PNG/metadata to `assets/vendor/riclmbr/` or asset-normalized counterparts. Keep asset-source manifest and SHA-256; retain original license/readme in `docs/licenses/` where redistribution allowed. Commit only necessary final game art, not raw ZIP or unused huge bundles.
7. If the purchase ZIP is not found, **activate free kit without blocking** and mark `PREMIUM_PACK_ABSENT` in `IMPLEMENTATION_STATUS.md`. Do **not** tell the user it has been installed.

### 3A.3 Coherent free kit — MurphysDad Sci-Fi Facility Asset Pack (CC0)

**Publisher page:** https://murphysdad.itch.io/sci-fi-facility  
**Publisher:** MurphysDad. **Cost:** free/name your own price. **Advertised license:** CC0 1.0.  
**Advertised content:** Spy 4-direction movement and confusion sprites; Hazmat 4-direction movement and confusion sprites; stationary NPCs, sci-fi facility wall/floor tiles, animated computers/noisemakers/electric gates, UI overlays and props. Exact animation frame counts are NOT listed publicly; inspect archive instead of making them up.

**Free mapping:**
- Spy = player; Hazmat = guard; second guard/heavy = original recolor or original silhouette drawn in Godot with distinct armor overlay; security drone = CC0 custom original geometric sprite if pack lacks one.
- Map = included facility floor/wall/interactive props. UI = original Godot Control or Kenney Sci-Fi UI if it stylistically matches.
- If combat/hurt/death frames do not exist, preserve the character sprite, display direction-appropriate idle during attacks, and add **engine-driven** secondary FX (baton arc, red/white hit flash, brief knockback animation, fall/stun ring). **Do not present synthesized effects as original frames supplied by the pack.**
- Show slower understated stealth game motion if the free pack's sprites are sparse. Never force a fake 8-direction animation from 4-direction art.

**Manual download:** open page → `Download Now` → choose download / skip payment if offered → save ZIP → move unchanged to `incoming_assets/`. Keep the license proof in docs. Do not assume the archive name even though the page advertises `sci-fi-facility-asset-pack.zip` (~28 KB).

### 3A.4 Other sources: eligible extras vs deliberate exclusions

| Source | Page | Use policy | Why |
|---|---|---|---|
| **Kenney UI Pack — Sci-Fi** | https://kenney.nl/assets/ui-pack-sci-fi | Supporting UI only, after CC0 verification | Clean menus, not primary hero sprites |
| **Kenney Sci-Fi / Interface / Impact Sounds** | https://kenney.nl/assets/sci-fi-sounds ; https://kenney.nl/assets/interface-sounds ; https://kenney.nl/assets/impact-sounds | Supporting SFX, after CC0 verification | Avoid mixing disparate character styles |
| **DKZeus Sci-Fi Tileset and Character** | https://dkzeuss.itch.io/sci-fi-all-in-one-asset-pack | Optional **local-use candidate**; license permits game use, but CC0/redistribution of raw art is not established | Animated 4-direction astronaut + 16×16 tiles. For public repository, require clear license evidence or don't commit raw sprites |
| **TheDinoSet Free Sci-Fi Pixel Art Pack** | https://thedinoset.itch.io/free-sci-fi-pixel-art-asset-pack-100-16x16-sprites-space-characters-aliens-ite | Optional **local-use candidate** only, pending distribution rights | Many coordinated 16×16 art sprites, but public page says games/recolor allowed, not explicit CC0; avoid raw distribution without verification |
| **CHROME DISTRICT (booliebuilds)** | https://booliebuilds.itch.io/chrome-district | **License conflict: NOT baseline without resolution** | Prose says CC0 while itch.io structured metadata lists **CC BY 4.0**. Resolve actual `LICENSE` and attribution before use; 8-dir walk only, no attack/KO |
| **Sova Digital Footsoldier / Drone and premium roster** | https://sovdigital.itch.io/free-footsoldier ; https://sovdigital.itch.io/free-combat-drone | **EXCLUDED from this baseline** | Page disallows re-sharing sprites as assets **and use in datasets**; awkward fit for open-source recruiter/AI-training evaluation artifacts |
| **Danwolfe sci-fi characters** | https://danwolfe.itch.io/sci-fi-character-sprites | **EXCLUDED from this baseline** | Separate paid asset, attribution, no resale, explicit **no Training/Generative AI**. Do not pull into this portfolio's benchmark-ready repository |

**Critical license gate:** CC0 is the strongest uncomplicated fit for a public source repository and potential benchmark re-use. A commercial-game license can still disallow redistribution of sprites as files or use within ML datasets. When in doubt, fail closed for commit/export/AI dataset and preserve original fallback. Do not assume an asset is safe for model training just because it is displayed on a public webpage. If user intends to submit the *game itself* as benchmark/training data, verify the customer's terms independently; keep licensing evidence and source credits.

### 3A.5 Versioned character roster config + asset registry

**Required files:**

```
config/asset_pack_registry.json        # license/status, source URL, archive hashes, allowed use
config/character_roster.json           # actor -> pack -> character key -> animations -> scale/pivot
assets/vendor/riclmbr/                # used assets only after confirmed legal purchase+license
assets/vendor/murphysdad/              # used assets only after confirmed CC0 license
assets/characters/generated/           # original fallback characters/overlays
scenes/characters/character_visual.tscn
scripts/characters/character_visual.gd
scripts/characters/character_visual_registry.gd
resources/character_visual_profile.gd
scenes/dev/character_showcase.tscn
scripts/dev/character_showcase.gd
tools/inspect_character_pack.py
tools/build_spriteframes.gd
docs/CHARACTER_ART_BIBLE.md
docs/CHARACTER_ANIMATION_MATRIX.csv
docs/ASSET_LICENSE_AUDIT.md
docs/screenshots/character_showcase/    # screenshots only if truly captured
```

The game MUST reference **semantic keys** (`player_agent`, `guard_standard`, `guard_heavy`, `drone_security`, `npc_scientist`) and NOT fixed ZIP filenames inside gameplay scripts. The visual registry resolves each actor key to a verified playable `SpriteFrames` resource or fallback.

`config/asset_pack_registry.json` conceptual records:

```json
{
  "schema_version": 2,
  "packs": {
    "riclmbr_neon_city": {
      "url": "https://riclmbr.itch.io/pixel-cyberpunk-neon-city-300-top-down-cyberpunk-assets",
      "priority": 1,
      "expected_license": "CC0-1.0",
      "archive_available": false,
      "license_verified": false,
      "source_archive_sha256": null,
      "status": "PENDING_USER_DOWNLOAD"
    },
    "murphysdad_scifi_facility": {
      "url": "https://murphysdad.itch.io/sci-fi-facility",
      "priority": 2,
      "expected_license": "CC0-1.0",
      "archive_available": false,
      "license_verified": false,
      "source_archive_sha256": null,
      "status": "PENDING_USER_DOWNLOAD"
    }
  }
}
```

**These boolean values must be set from actual observations**, not inferred from the online description. Do not convert pending to verified without archived evidence.

`config/character_roster.json` conceptual semantic keys (must populate actual animation paths after inspection):

```json
{
  "schema_version": 2,
  "selection_policy": "premium_if_verified_else_free_if_verified_else_original",
  "characters": {
    "player_agent": {
      "premium_candidate": "Netrunner",
      "free_candidate": "Spy",
      "semantic_palette": "cyan",
      "visual_frame_size": [32, 32],
      "required_directions": ["down", "up", "left", "right"],
      "runtime_resource": null
    },
    "guard_standard": {
      "premium_candidate": "Security Guard",
      "free_candidate": "Hazmat",
      "semantic_palette": "amber",
      "visual_frame_size": [32, 32],
      "required_directions": ["down", "up", "left", "right"],
      "runtime_resource": null
    },
    "guard_heavy": {
      "premium_candidate": "SWAT",
      "free_candidate": "generated_armored_guard",
      "semantic_palette": "red",
      "visual_frame_size": [32, 32],
      "required_directions": ["down", "up", "left", "right"],
      "runtime_resource": null
    },
    "drone_security": {
      "premium_candidate": "Security Bot",
      "free_candidate": "generated_drone",
      "semantic_palette": "violet",
      "visual_frame_size": [32, 32],
      "required_directions": ["down", "up", "left", "right"],
      "runtime_resource": null
    }
  }
}
```

**These are schemas/examples, not assertions about exact paths, frame sizes or file contents in the downloaded ZIP.** The source pack's native dimensions control geometry; normalize only after inspection. Record differences in `docs/CHARACTER_ART_BIBLE.md`.

### 3A.6 Animation vocabulary and strict fallback hierarchy

Support **4 rendered facing directions** for 8-way movement; do NOT synthesize true diagonal source frames unless a different pack explicitly supplies them.

**Required semantic animation names** (actual resources may use differently named source strips):

- `idle_down`, `idle_up`, `idle_left`, `idle_right`
- `walk_down`, `walk_up`, `walk_left`, `walk_right`
- `attack_down`, `attack_up`, `attack_left`, `attack_right` — only 3 source directions are advertised in paid kit; **resolve the missing direction with a verified mirrored symmetric pose or a Godot-generated FX overlay, never an invalid source frame**
- `hurt_down`, `hurt_up`, `hurt_left`, `hurt_right` — may map to a common source hurt frame + direction-preserving flash where source lacks direction variants
- `ko_down`, `ko_up`, `ko_left`, `ko_right` — source says `death`, but gameplay is **nonlethal**; show KO/fall as incapacitation and label code/UI accordingly
- `crouch_*` — preferentially use source frames if present; otherwise hold frame + slight lowered **visual-only** posture and a crouch shadow. Do not deform pixel art with non-integer scaling
- `sprint_*` — use walk animation with 1.35–1.65x playback speed and footstep FX (if no run frames)
- `interact_*` — idle + controlled arm/glow/terminal overlay when no valid interact frames
- `stunned_*` — idle + electric spark/outline overlay, with visible disabled feedback

Each semantic state resolves in order: **real exact animation → real reasonable sibling + no invalid flipping → safe custom overlay preserving facing → original fallback animation**. Record resolution type in `CHARACTER_ANIMATION_MATRIX.csv` as `native`, `mirrored`, `sibling+fx`, `generated` or `missing`; release gates forbid `missing` for idle/walk four directions.

**Suggested FPS (tune after inspecting source previews and metadata):** idle 3–5, walk 7–10, sprint 11–15, attack 10–14, hurt short pulse, KO non-looping; source `assets.json` timings override these *only if they are sane and confirmed*. Avoid restarting walk animation every `_physics_process` frame.

### 3A.7 Import algorithm: inspect, normalize, generate SpriteFrames

Codex must implement a reproducible, idempotent pipeline:

1. **Discover:** inspect only actual `.zip` archives under `incoming_assets/`. `tools/inspect_character_pack.py --inventory` writes list of exact paths, zip SHA256, PNG dimensions, metadata filenames, file count, potential source license files. Never execute code embedded in a ZIP; never extract to unsafe paths; reject symlinks and traversal paths.
2. **Select:** prefer verified premium CC0; otherwise verified free CC0; otherwise generated. If `LICENSE` missing or ambiguous, mark `LICENSE_REVIEW_REQUIRED`, continue with fallback and tell the developer exactly which pack needs manual review.
3. **Map source frames:** use actual `assets.json` and README when provided, or manually inspect strips/atlases. For source sheet `128x352` with `32x32` cells, source geometry allows 4×11 slots — but there may be 36 filled frames, blank slots and undocumented row ordering; **do not infer frame-to-state from geometry alone**.
4. **Build mapping:** create `docs/CHARACTER_ANIMATION_MATRIX.csv` columns `actor_key,semantic_animation,source_pack,source_png,source_region_px,source_frame_indices,duration_or_fps,loop,pivot_px,flip_h,provenance,verified_preview`.
5. **Normalize copies:** copy or crop only selected source frames under `assets/characters/normalized/<actor>/` without changing original ZIP. If Pillow is available, use Pillow nearest-neighbor only; if absent, use Godot Image API or Godot AtlasTexture region to avoid introducing a heavyweight dependency. Do not bake rotated/scaled blurry images. **PNG alpha must remain intact.**
6. **Create `.tres` SpriteFrames:** an editor-side Godot script `tools/build_spriteframes.gd` generates/updates deterministic resources using `SpriteFrames`, `AtlasTexture` or imported individual PNG frames, sets animation loop/FPS, saves via `ResourceSaver`. The script must be runnable in the actual installed Godot 4.7.2 environment; use correct engine API signatures rather than assumptions.
7. **Validate:** load each generated `SpriteFrames`, check every mandatory animation has at least one valid frame, no region lies outside atlas boundaries, loop flags are correct, direction mapping matches previews and runtime scene has no missing texture warnings.
8. **Showcase:** instantiate all selected visuals in `scenes/dev/character_showcase.tscn` with a select/action control to manually preview idle/walk/attack/hurt/KO, all 4 directions, pivots, collision circle overlay, effective displayed size, transparent edges, and label `native / generated FX`.
9. **Smoke test:** open actual gameplay scene with the selected pack enabled; move in all directions, crouch/sprint, attack/stun, chase/KO enemy, reload checkpoint, switch scene, verify no stale resource references or visual flicker.
10. **Idempotency:** running the build pipeline twice with identical source ZIPs must not churn unrelated files or duplicate `.tres` or class names. In the absence of downloads, fallback remains bootable.

**Explicitly report whether animation mapping was visually reviewed**. A parsing/smoke test does NOT imply the animation looks correct.

### 3A.8 CharacterVisual component: appearance is separate from game logic

Required scene pattern (adapt to existing V1 path without breaking any game data):

```text
Player / Guard / HeavyGuard / Drone (CharacterBody2D)
├── CollisionShape2D                 # physics position/size, NEVER animated by art changes
├── CharacterVisual (Node2D)         # new reusable scene
│   ├── AnimatedSprite2D             # SpriteFrames from verified roster
│   ├── Shadow (Sprite2D/Polygon2D)  # under feet; independent art
│   ├── TeamAccent (Line2D/Polygon2D)  # optional subtle identity marker
│   ├── EquipmentAnchor (Marker2D)   # gadget/weapon FX attach point
│   ├── HitFlash (optional node/shader/tween)
│   └── StatusVFX (Node2D)           # stunned/alert/EMP/hack
├── NavigationAgent2D (enemies only)
├── Sensing/AttackAreas (as defined by V1)
└── ... all gameplay components from V1
```

`CharacterVisual` public API contract:

```gdscript
# Interface contract — Codex must implement, not necessarily these exact internals.
func set_profile(profile: CharacterVisualProfile) -> void
func set_facing(direction: Vector2) -> void
func set_motion(moving: bool, sprinting: bool, crouching: bool) -> void
func play_attack() -> void
func play_hurt() -> void
func play_ko() -> void
func set_status(status: StringName, enabled: bool) -> void
func reset_visuals() -> void
signal visual_animation_completed(action: StringName)
```

The visual controller receives authoritative gameplay state through stable events/signals; it **does not own health, target acquisition, enemy FSM or combat damage**. `CharacterVisualProfile` is a reusable `Resource` holding spriteframes/fallbacks, animation table, scale, pivot, equipment anchor offsets, shadow size, accent palette and hit reaction settings. Attack timing is owned by the combat component (consistent with cooldown and collision), not inferred from GIF playback duration. At most one primary body animation plays at a time; effects layer on top.

**Animation priority:** KO > stun > hurt > attack/interact > locomotion > idle; lower-priority state must not interrupt a non-looping high-priority animation until its interrupt window, but gameplay may override when necessary. Carefully avoid a persistent KO animation retriggering each tick.

### 3A.9 Facing and animation state rules

- The player moves **8 directions** but renders **four source facings**. Choose the dominant axis of input; for diagonals, keep previous facing when equal magnitude or use the most recent nonzero axis. Document this rule and test exact diagonal cases.
- For player aim, update facing from `(global_mouse_position - player.global_position)` only when beyond a small deadzone; allow keyboard movement while aiming. On no movement/no aim change, preserve last direction.
- Guard facing follows the next motion/patrol waypoint in PATROL/SEARCH, and target vector in ATTACK/CHASE when visible. Don't spin during idle because NavigationAgent recomputes waypoints.
- `AnimatedSprite2D.flip_h` allowed only for genuinely symmetric left/right sprites that have no orientation-specific gun, shoulder pad, insignia or shadows. Otherwise use verified left/right art.
- Direction-specific attack art is optional if absent, but facing must remain coherent even in mid-attack. No horizontally flipping a diagonal view into a false orthographic view.
- Never call `animated_sprite.play("walk_down")` each physics tick if already playing same animation. Switch only on actual visual state/direction transition.
- On KO or scene transition, cancel hit flash and special status tweens; restore default `modulate` and FX nodes before reuse/spawn. Don't keep enemy visual objects after enemy freed.

### 3A.10 Perspective, tiles, scaling and actor pivots

**V2 native art constraints:** primary cast character cell **32×32**, preferred tileset **16×16**. **V1 logical level grid remains 32×32 world pixels.** Normalize by **either** (A) nearest-neighbor upscale source 16×16 tiles to 32×32 output tile images, **or** (B) set the `TileMapLayer` source atlas to 16×16 with a `Vector2(2, 2)` visual+collision layer scale and verify world collision/navigation. **Choose exactly one strategy globally** for primary levels, document it, and run collision/door/navigation tests on that choice. Do not scale the player body collider with the sprite.

- 32×32 character textures should normally render at `Vector2(1,1)` world scale; tune relative to the 32px logical tile. Some source art may have empty transparent padding; align **feet**, not geometric center, and document pivot per character.
- Use consistent contact shadows beneath feet and Y-sort only on the actors/foreground props that benefit. Ground layers remain below. Walls must occlude actor appropriately where possible; test walking behind a tall prop.
- Foot pivot/padding: inspect actual opaque pixel bounds across frames; choose stable vertical anchor and set Sprite2D offset / parent visual position. **Do not move CharacterBody2D to compensate for wobbling sprite frames.**
- Body collision is independent of pixel-art outline. Design collision roughly around feet/torso; ensure stairs, terminal, and narrow doors remain passable; test player and guards at the smallest doorway.
- Render 640×360 reference viewport in a 1280×720 window with stretch **viewport/keep/integer** and default Nearest filtering. If user runs a different display resolution, preserve 16:9 and integer scaling instead of blurring.
- Use subtle engine lighting/shaders only if it preserves readability. Neon accent cannot replace collision or mission affordances. Limit screen shake to very small amplitude/duration and allow reduced effects in Settings.

### 3A.11 Roster and gameplay locations, tied to V1 levels

**Level 1 — Facility Access:** agent vs regular guard + security camera; scientist NPC or readable silhouette near server room; choose the clearest contrast for tutorial. Use one pool of guards reusing a single SpriteFrames resource.

**Level 2 — Research Vault:** armored heavy guard, one robot security unit, keycard/terminal and server rack. Differentiate heavy guard not just by tint but by silhouette/helmet or outline; show EMP disable visual on mechanical enemies.

**Level 3 — Extraction:** mixed guards, one special visual variant, escalating alarm. Never add untested bosses or new combat mechanics solely because premium pack has extra characters.

**UI portraits** can be cropped from available art ONLY if license and source permit; a scene screenshot of the selected character is preferable to AI-rendered concept art falsely labeled as a runtime sprite.

### 3A.12 Premium/free presentation standards

The game must **look intentional** in both modes:

| Quality axis | Premium with Riclmbr ZIP | Free with Sci-Fi Facility ZIP | No ZIP fallback |
|---|---|---|---|
| Cast | 32×32 coherent roster | Spy/Hazmat + purpose-built extra silhouettes | Distinct original procedural cast |
| Directions | Native idle/walk four ways, checked | Native four-way movement, checked | Four-way shaped/facing visuals |
| Attack | Native 3-direction frames + exact missing-dir fallback | Engine FX overlay + idle/held frames if lacking | Engine FX overlay |
| Damage/KO | Native if valid, plus flash/spark | Engine visual feedback if source lacks | Engine visual feedback |
| Environment | Same-kit lab/server tiles/props | Same-kit laboratory tiles/props | Cohesive originally drawn laboratory |
| UI | Same-kit UI plus scalable Godot labels | Kenney CC0 or custom Godot theme | Custom Godot controls |
| Acceptance | Pixel quality + four-direction review | Honest free style + four-direction review | Usable gameplay + honest fallback label |

The README must disclose actual asset mode used for recorded/screenshots. **Never show a paid-pack promo preview as if it were a screenshot of the playable project.** Do not promise premium quality if the pack was never supplied.

### 3A.13 Art QA case list (mandatory when pack available)

Add runnable tests and manual protocol entries with these exact IDs:

| ID | Test | Expected result |
|---|---|---|
| ART-01 | Start without `incoming_assets/` | No missing-asset crash; generated/selected committed art works |
| ART-02 | Inventory user ZIP, read PNG headers | Real path+dimensions+SHA256, no guessed paths |
| ART-03 | Malicious ZIP traversal path | Extraction blocked and reason reported |
| ART-04 | Missing/contradictory license | Pack not committed; fallback activated; explicit warning |
| ART-05 | Premium present and verified | Same-pack selected 4+ semantic actors in scenes |
| ART-06 | Premium absent, free verified | Free mode selected; no fictitious premium textures |
| ART-07 | Character faces down/up/left/right | Correct front/back/side sprite shown for each |
| ART-08 | Walk and stop | Walk cycles run and stop in last facing; no animation reset each tick |
| ART-09 | Diagonal movement | Player speed normalized, facing stable, no fake diagonal frames |
| ART-10 | Aim 360 degrees | Four-facing quantization agrees with input, no jitter near origin |
| ART-11 | Attack four directions | Correct native or documented fallback, no wrong frame/blank cell |
| ART-12 | Crouch and sprint | Readable effect; speed/UI unchanged; pixel outline not deformed |
| ART-13 | Hurt + KO on guard | KO persists, no attacking after incapacitation, visuals stop |
| ART-14 | EMP and alert | Drone stunned FX, guard alert visual, VFX removed on reset |
| ART-15 | Sprite pivots across clips | Feet do not jump/displace between animation states |
| ART-16 | Doors and foreground occlusion | Actors pass correctly and render behind foreground when needed |
| ART-17 | Nearest-neighbor and integer scale | 640×360 and 1280×720 pixel art sharp and consistent |
| ART-18 | Performance of 10/20/40 agents | Real measured profiling, no invented pass target |
| ART-19 | Restart/reload 20 times | No duplicate sprites, signal leaks, stale effects |
| ART-20 | Clean Git clone | All committed used assets have redistribution grant and load |
| ART-21 | Asset rebuild twice | Deterministic roster mapping, no duplicated file resources |
| ART-22 | Source labels & screenshot provenance | Credits accurate; screenshot is actual running game |

Use automated Godot checks for resource loading, manifest/roster integrity, stage-state transitions and asset region bounds; use a manual **visual review checklist** for aesthetics, pivot/tiling, flicker and legibility. No automated test can assert that an unviewed sprite *looks good*.

### 3A.14 Required v2 handoff materials and truth reporting

- `docs/CHARACTER_ART_BIBLE.md`: reference art style, exact source pack, native size, color/team logic, actor roster, feet pivot, scaling, visual states, every known fallback.
- `docs/CHARACTER_ANIMATION_MATRIX.csv`: all mandatory actor x motion state x direction rows, source regions and provenance.
- `docs/ASSET_LICENSE_AUDIT.md`: verified source URL and proof, archive SHA256, restrictions, used files, redistributability/public repo compatibility. Name conflict explicitly if one exists.
- `docs/ART_QA_REPORT.md`: ART-01..ART-22 with `PASS`, `FAIL`, `BLOCKED`, evidence, commands and where manual visual review was/wasn't performed.
- `docs/screenshots/character_showcase/`: genuine editor/game captures only; never download vendor marketing images and label them gameplay.
- `docs/VIDEO_CAPTURE_GUIDE.md`: add 60–90 second clip showing all 4 player directions, one guard alert/chase, heavy guard, drone EMP, HUD and F3 art/AI diagnostics.
- `IMPLEMENTATION_STATUS.md`: report `VISUAL_MODE=PREMIUM_VERIFIED|FREE_VERIFIED|ORIGINAL_FALLBACK`, actual ZIP found, spriteframes built, Godot version, headless passes, human-playtest blockers and release status.

**V2 art definition of done:** the selected pack is genuinely present and verified OR the free/original mode is honest and visually coherent; at least the player/guard/heavy/drone have correct nonempty four-direction animations/fallbacks; complete 3-level gameplay from V1 remains working; tests, debug overlay and packaging are not regressed; source provenance is public and lawful.

---

## 4. ARCHITECTURE AND REPOSITORY LAYOUT

Required top-level layout (expand sensibly; do not create empty placeholder files):

```
shadow-protocol/
  project.godot
  icon.svg                        # own simple vector mark
  LICENSE                         # game/source code license (MIT or chosen permissive license)
  README.md
  IMPLEMENTATION_STATUS.md
  CHANGELOG.md
  .gitignore
  .gitattributes
  .github/workflows/godot-ci.yml
  assets/ ...
  incoming_assets/ ...
  config/
    asset_mapping.json
    balance/player.tres
    balance/guard.tres
    balance/heavy_guard.tres
    balance/drone.tres
  scenes/
    bootstrap/main.tscn
    menus/main_menu.tscn
    menus/pause_menu.tscn
    menus/settings_menu.tscn
    menus/game_over.tscn
    menus/results.tscn
    player/player.tscn
    enemies/guard.tscn
    enemies/heavy_guard.tscn
    enemies/drone.tscn
    interactables/door.tscn
    interactables/terminal.tscn
    interactables/keycard.tscn
    interactables/health_pickup.tscn
    interactables/extraction_zone.tscn
    interactables/checkpoint.tscn
    gadgets/emp_pulse.tscn
    combat/stun_hitbox.tscn
    ui/game_hud.tscn
    ui/developer_overlay.tscn
    levels/level_01_access.tscn
    levels/level_02_vault.tscn
    levels/level_03_escape.tscn
    levels/test_arena.tscn
  scripts/
    autoload/game_manager.gd
    autoload/event_bus.gd
    autoload/save_manager.gd
    autoload/audio_manager.gd
    autoload/settings_manager.gd
    components/health_component.gd
    components/stamina_component.gd
    components/interaction_component.gd
    components/hitbox_component.gd
    components/hurtbox_component.gd
    player/player_controller.gd
    enemies/enemy_controller.gd
    enemies/vision_sensor.gd
    enemies/hearing_sensor.gd
    enemies/state_machine.gd
    enemies/states/*.gd
    combat/attack_service.gd
    missions/mission_manager.gd
    missions/objective.gd
    world/level_controller.gd
    world/navigation_sync.gd
    ui/hud_controller.gd
    ui/developer_overlay.gd
  resources/
    actor_stats.gd
    enemy_config.gd
    mission_definition.gd
    settings_data.gd
  data/
    missions/level_01.json
    missions/level_02.json
    missions/level_03.json
  tests/
    run_tests.gd
    test_health.gd
    test_stamina.gd
    test_enemy_fsm.gd
    test_vision.gd
    test_mission.gd
    test_inventory.gd
    test_save_manager.gd
    test_level_integrity.gd
    test_integration.gd
  tools/
    asset_inventory.py
    prepare_assets.py
    validate_project.sh
    create_release.sh
  docs/
    ASSET_SOURCES.md
    ASSET_INVENTORY.csv
    ARCHITECTURE.md
    GAMEPLAY_SYSTEMS.md
    LEVEL_DESIGN.md
    TEST_PLAN.md
    DEBUGGING_CASE_STUDIES.md
    PERFORMANCE.md
    REPRODUCE_WORKFLOWS.md
    VIDEO_CAPTURE_GUIDE.md
    screenshots/                    # real captures only
```

### 4.1 Design principles

- **Godot scenes own spatial/visual state**; components encapsulate health, collisions and stamina; resources hold balance settings.
- **Autoloads only for cross-scene services** (game flow, saves, settings, audio, signals). UI must not directly mutate enemy state through global singleton properties.
- Use **signals**: `health_changed`, `died`, `objective_completed`, `alarm_changed`, `inventory_changed`, `door_unlocked`, `level_completed`, `noise_emitted`.
- No permanent reference cycles between player/UI/level; connect signals on spawn and disconnect on disposal when relevant.
- All actions affecting health, inventory or score must be **single-authority** (one method updates authoritative value and emits signal once).
- Avoid opaque dynamically generated scene text if Godot scripts can build them consistently. `.tscn` should be valid and editor-inspectable; handcrafted `.tscn` needs parser validation.
- Store critical gameplay parameters in Resources, not duplicated constants in multiple scripts.

### 4.2 Collision & navigation layers (document exact bit values)

- Layer 1 `WORLD_SOLID`: walls, solid props, closed blocking doors.
- Layer 2 `PLAYER`: player CharacterBody2D.
- Layer 3 `ENEMY`: guards, drones.
- Layer 4 `PLAYER_ATTACK`: player nonlethal attack / EMP hitboxes.
- Layer 5 `ENEMY_ATTACK`: hostile attack areas.
- Layer 6 `INTERACTABLE`: interaction areas and pickups (non-solid).
- Layer 7 `SENSOR`: sensor areas; keep trigger filtering focused.
- Layer 8 `PROJECTILE`: if used.

Set masks deliberately. Document matrix in `docs/ARCHITECTURE.md` and test: wall blocks player/guard/projectiles; attack doesn't damage owner; pickup trigger doesn't block movement; camera line of sight is blocked by solid obstacles.

---

## 5. SCENE TREES AND GODOT NODE CONTRACTS

### 5.1 Player scene

```
Player (CharacterBody2D) [player_controller.gd]
  VisualRoot (Node2D)
    Sprite2D or AnimatedSprite2D (fallback Polygon2D)
    FacingMarker (Node2D)
  CollisionShape2D
  InteractionArea (Area2D)
    CollisionShape2D
  AttackOrigin (Marker2D)
  HealthComponent (Node)
  StaminaComponent (Node)
  AnimationPlayer
  Camera2D
  AudioStreamPlayer2D
```

Player uses `move_and_slide()` from `_physics_process()`. Normalize diagonal movement; clamp position via collision not screen coordinate hacks. Camera follows smoothly but must not show outside level bounds; update bounds per level.

### 5.2 Guard / Heavy Guard scene

```
Guard (CharacterBody2D) [enemy_controller.gd]
  VisualRoot (Node2D)
    Sprite2D / Polygon2D
    StateIcon
  CollisionShape2D
  NavigationAgent2D
  VisionRay (RayCast2D) OR direct physics ray query
  DetectionArea (Area2D)        # broadphase only
    CollisionShape2D
  AttackArea (Area2D)
    CollisionShape2D
  HealthComponent (Node)        # includes incapacitation/stun if desired
  StateMachine (Node)
    Patrol (Node)
    Suspicious (Node)
    Investigate (Node)
    Search (Node)
    Chase (Node)
    Attack (Node)
    Stunned (Node)
    ReturnToPatrol (Node)
  AnimationPlayer
  AudioStreamPlayer2D
```

An enemy can occupy **exactly one logical state** at any time, maintain its own blackboard (last seen player position, alert level, current target), and never continue moving/attacking while stunned. Avoid spawning alert animations every physics frame.

### 5.3 World / level scene

```
LevelRoot (Node2D) [level_controller.gd]
  Ground (TileMapLayer)
  Decoration (TileMapLayer)
  Walls (TileMapLayer)           # configured collision
  NavigationRegion2D            # traversable surface; deterministic nav mesh
  Props (Node2D)
  Interactables (Node2D)
  Enemies (Node2D)
  PatrolWaypoints (Node2D)
  PlayerSpawn (Marker2D)
  Extraction (Area2D)
  LevelTriggers (Node2D)
  CameraBounds (Node2D)
```

Use TileMapLayer not deprecated Godot 3 TileMap APIs. If external sprites don't provide a correctly sized atlas, original grid-drawn floor and a smaller configured TileMapLayer are acceptable, but the final level must actually use TileMapLayer and its collision feature. All three levels must be authored and testable.

### 5.4 HUD and overlay

```
GameHUD (CanvasLayer)
  Root (Control)
    TopLeft (VBoxContainer)
      HealthBar (ProgressBar)
      StaminaBar (ProgressBar)
    TopRight (VBoxContainer)
      MissionTitle (Label)
      ObjectiveList (VBoxContainer)
      AlarmStatus (Label)
    BottomCenter (Label)         # interaction prompt
    BottomRight (HBoxContainer) # keycards / EMP charge / gadget
    Notifications (VBoxContainer)
    Crosshair (optional Control)
DeveloperOverlay (CanvasLayer)
  DebugPanel (PanelContainer)
    Stats (RichTextLabel or Labels)
```

Ensure HUD scales/anchors sensibly and does not obscure the player's position at 640×360.

---

## 6. CORE SYSTEMS — REQUIRED IMPLEMENTATION DETAILS

### 6.1 Player movement and animation

- Four or eight directional facing; animation state `idle`, `walk`, `sprint`, `crouch`, `attack`, `hurt`, `down`.
- If no spritesheets exist, implement readable procedural character silhouettes and action animations with AnimationPlayer/Tweens. Do not reference `res://assets/characters/player/walk.png` until file exists.
- Sprint makes a noise event at most once every configurable **0.6 s** rather than every frame; crouch significantly reduces it. Stamina logic must be frame-rate-independent.
- Collision should prevent tunneling through corners at normal movement speeds. Mouse aiming uses global mouse position, transformed properly with Camera2D.

### 6.2 Interaction system

- Reusable `IInteractable`-like convention in GDScript: `can_interact(actor) -> bool`, `get_interaction_label() -> String`, `interact(actor) -> void` (GDScript duck typing is acceptable).
- Find nearest eligible candidate within 40 px and line of sight, stable selection if two overlap; E triggers exactly once per key press.
- Prompt: `E — Pick up Blue Keycard`, `E — Hack Security Terminal`, `E — Open Secured Door`, `E — Extract`.
- Interaction can't occur when player is dead, paused or too far. Terminal should support canceled interaction if player moves away or is damaged.

### 6.3 Health / damage / collisions

- Health component exposes `apply_damage(amount, source_id)`, `heal(amount)`, `die()`. Clamp to `[0, max]`, ignore nonpositive damage, no double-death signals.
- Player receives **0.6 s** post-hit invulnerability against repeated overlapping hurtboxes (configurable); visible flash and clear hit feedback.
- A nonlethal stun attack has one target application per swing (`hit_id`/visited set), even when a hitbox overlaps across several physics frames.
- Impact VFX and SFX are emitted on actual hit, not on speculative animation frame.

### 6.4 Enemy perception and alert system

- Detection has **two checks**: broadphase distance/Area2D and actual **angle + raycast** line-of-sight. A wall must block detection.
- Guard visual detection radius default **150 px**, total FOV **90 degrees**; heavy **165 px / 100 deg**; drone **190 px / 110 deg**. Detection accumulation is gradual (e.g. 0.9 seconds fully visible on Normal), decreases slowly while hidden; avoid instant impossible-to-avoid spotting.
- Stance modifiers: crouch reduces effective detection range by roughly 30%; sprint makes detection accumulation faster if visible. Do not ignore walls.
- Hearing: player emits noise events with position, radius, type; guards in range move to last heard location, not directly to the player unless visually confirmed.
- On sighting, publish one cooldown-limited global/nearby alert. Neighbor guards investigate when within **220 px**, with max one propagation per `alert_id` to prevent alert storms.
- Search lasts **6 s**; guard scans plausible last-seen position before returning to patrol. Alert indicator HUD responds to state.
- Cameras rotate/sweep on a bounded arc, can raise alarms, can be disabled by EMP for **5 s** and must correctly resume afterward.

### 6.5 FSM — exact states and transitions

| State | Entry | Update | Exit criteria |
|---|---|---|---|
| PATROL | Set current waypoint | Walk waypoints, scan | Noise→INVESTIGATE; partial detection→SUSPICIOUS; full sight→CHASE |
| SUSPICIOUS | Stop/slow, show `?` | Investigate sightline and accumulate confidence | Full visual→CHASE; confidence cleared→PATROL; noise→INVESTIGATE |
| INVESTIGATE | Store sound source | Path to event, scan | Visual→CHASE; arrived→SEARCH |
| CHASE | Store player location | Pursue updated target with repath throttling | In attack range + LOS→ATTACK; lost LOS for 1.5 s→SEARCH |
| ATTACK | Stop if needed | Wind-up; hit check; cooldown | Target moved out of range→CHASE; lost LOS→SEARCH |
| SEARCH | Store last seen position | Move to location, sweep for 6 s | Reacquire→CHASE; timeout→RETURN |
| STUNNED | Stop and cancel attack | Play feedback, no attack or movement | 1.5 s elapsed→SEARCH/RETURN |
| RETURN | Set nearest waypoint | Resume route smoothly | Arrived→PATROL; sight/noise can interrupt |

Mandatory transition precedence: death/incapacitation > stunned > visibility/attack > investigation > patrol. Include tests for state changes and invalid transition requests.

### 6.6 Enemy navigation and dynamic doors

- `NavigationAgent2D` moves guard by reading `get_next_path_position()` in physics updates until `is_navigation_finished()`; do not assign player global_position directly as a shortcut.
- Define traversable navigation mesh that does not overlap solid walls. For level maps, use explicit NavigationRegion2D polygons or properly configured navigation tile shapes. Verify in editor and through a manual route test.
- Avoid recalculating paths each frame: throttle dynamic target updates to e.g. 0.2–0.3 s or meaningful distance changes. Prevent jitter by appropriate path/target distance tolerances.
- **Dynamic door problem:** Opening/closing a door must update reachable route logic. Use documented navigation map update/door obstacle strategy; if using navigation obstacles only for avoidance is insufficient for pathfinding, rebake or swap navigation regions / dynamic links deliberately. Do not claim dynamic door pathfinding works until tested.
- If Godot navigation mesh setup is blocked by inconsistent downloaded tiles or engine API differences, a **documented AStarGrid2D fallback for dynamic doors** is acceptable for a working level while keeping a real `NavigationAgent2D` demonstration/test scene. This is an explicit fallback, not a reason to skip navigation tests.
- Guards should not jitter at final waypoint, walk through a closed door, or get stuck indefinitely in a corridor. Use stuck timeout with one planned recovery to last valid waypoint; never teleport enemies visibly.

### 6.7 Combat and gadgets

- Default player non-lethal combat: stun baton, attack telegraph 0.15 s, active window 0.1 s, recovery, 0.55 s total cooldown, enemies stunned 1.5 s.
- Gadget `EMP` on Q: one charge consumed on valid activation, 110 px radius, camera/drone disabled **5 s**, human enemies stunned **2 s**, distinct visual circle/pulse. Cannot activate when charges=0; display feedback.
- Heavy guards resist EMP: only 1 s stun. Enemy ranged pulse only if a safe clear line of sight, no wall penetration, projectile lifetime and collision cleanup enforced.
- Optional escape route always exists; combat should be useful but not mandatory for standard completion. Prevent permanent kill-locking of mission-required NPCs.

### 6.8 Inventory and pickups

- Inventory data model: `keycards: Set[String]` or Dictionary, `emp_charges: int`, `data_chip_collected: bool`, optional medkits as immediate use.
- Collectible identity via unique `pickup_id` stored in checkpoint/save; pickup not recollected after save/load.
- Blue/Red Keycards unlock matching doors; opening a door persists for current level and across saves.
- Items are visible and distinct by color and label, never hidden behind inaccessible decorative collision.

### 6.9 Missions and progression

- Mission manager reads author-validated definitions; objectives express dependencies and completion predicates, not UI-only boolean flags.
- Objective types: `pickup`, `interact_terminal`, `unlock_door`, `reach_zone`, `evade_alarm_for_seconds` (last optional).
- Objective events are idempotent; repeating trigger does not add score or complete twice.
- Mission HUD lists next objective and optional subgoals; game provides on-screen instructional prompt in first level.
- An extraction zone only finishes when objective graph satisfied. Unlock next level in `GameManager`.

### 6.10 Alarm and scoring

- Alarm state `CALM`, `SUSPICIOUS`, `ALERT`, `LOCKDOWN`; alarm increases from detections/camera and decays when hidden after specified delay.
- Lockdown is dangerous but **not a permanent impossible state**: doors critical to completing the level can be reopened via a terminal or timer; define contingency path.
- At level completion calculate: elapsed time, detections, damage taken, alerts raised, EMP used, guards stunned; award Bronze/Silver/Gold based on documented deterministic conditions. Never use unverified online leaderboard.
- Present a short results screen with `Retry`, `Next Mission`, `Main Menu`.

### 6.11 Save/load, checkpoint, settings

- `SaveManager` writes versioned JSON to `user://save_v1.json` through a temp file + rename/replace pattern, with error handling. Store version, current level, checkpoint, health, stamina, inventory, completed objectives, picked item IDs, opened door IDs, options and per-level results. Avoid serializing nodes/Vector2 directly; encode as JSON-safe primitives.
- Validate payload shape/types/coordinate bounds; reject unsupported future schema safely and preserve a backup/invalid file when appropriate. Provide **New Game** and **Continue**. Continue disabled if no valid save.
- Save on checkpoint + level completion; optional manual save from pause. Loading must not duplicate pickups or unlock future levels incorrectly.
- Settings: master/SFX/music sliders, fullscreen/windowed, toggle camera shake, UI scale option if practical. Persist separately from mission saves.
- Pausing must pause simulation while allowing Pause UI to process.

### 6.12 Audio / FX / camera feedback

- SFX categories: footsteps, stun, hit, drone, alarm, keycard, terminal, door, button accept/cancel, mission success.
- `AudioManager` manages buses `Master`, `Music`, `SFX`, supports absent sound files with no errors, avoids playing same SFX dozens of times per second.
- Minimal animation: player move / crouch / stun flash, guard alert, doors slide open, terminal hacking progress, EMP radius burst, health damage response.
- Subtle camera shake on hit/EMP with accessibility toggle; don't make UI unreadable.

### 6.13 Menus and onboarding

- Main Menu: New Game, Continue (when available), Settings, Credits, Quit.
- Pause Menu: Resume, Retry Checkpoint, Settings, Main Menu.
- Credits page: original project, code license, Kenney CC0 source pack list and links, appropriate attribution note (CC0 doesn't require attribution but keep it for transparency).
- Level 1 contains short contextual overlay teaching Move, Crouch, Interact, Stun, EMP, Extraction; overlays dismiss on action and don't block progress forever.
- Game Over offers Retry Checkpoint; repeated death/reload must not duplicate autoloads or leave enemies alive from previous scene.

---

## 7. LEVEL DESIGN — AUTHOR THREE REAL LEVELS

Use an authored tile grid (recommend 32×32 logical cell) plus modular props, not purely random procedural maps. Each `.tscn` scene must be visibly distinct and have a viable route. Suggested level sizes and content are tunable but must retain intended logic. Include a layout diagram and objective graph in `docs/LEVEL_DESIGN.md`.

### Level 01 — ACCESS WING / Tutorial Breach

- Grid approximately **40×24** cells, 2 branching corridors, office, storage room, server lobby and extraction bay.
- Player spawn `(3, 19)` grid. Blue keycard room in NW section. Security terminal mid-center. Exit NE.
- Threats: **2 Patrol Guards**, **1 rotating security camera**; 1 guarded corridor with avoidable path.
- Objectives (strict dependency): `Find Blue Keycard` → `Disable North Security Terminal` → `Reach Extraction`.
- Mechanics: patrol, vision cones, crouch, interaction; optional EMP charge placed in storage.
- Checkpoint: after terminal, before exit. At least two ways to approach terminal (stealth route and direct route).
- Player must see start and a clear first objective. Tutorial instructions must be contextual rather than long modal exposition.

### Level 02 — RESEARCH VAULT / Retrieval

- Grid approximately **48×30**, hub with 3 branches, access-locked lab, drone shaft, research vault.
- Threats: **3 Patrol Guards**, **1 Heavy Guard**, **2 cameras**, **1 drone**.
- Objectives: `Get Red Keycard` → `Hack Vault Terminal (3 seconds with cancel)` → `Collect Data Chip` → `Unlock Escape Corridor` → `Extract`.
- Introduce noise lure/interruption and one EMP pickup. Alarm can temporarily seal optional shortcut but cannot permanently block route.
- Checkpoint after chip; saved opened door and pickup state persist.
- Make patrol routes and line-of-sight obstacles intentionally designed for different strategies.

### Level 03 — BLACKOUT ESCAPE / Finale

- Grid approximately **52×30**, industrial floor, maintenance tunnel, power control, final checkpoint, exit airlock.
- Threats: **3 Guards**, **2 Heavy Guards**, **2 Drones**, **2 cameras**. Don't spawn more than performance target without design purpose.
- Objectives: `Restore Auxiliary Power` → `Override Lockdown` → `Reach Exit Airlock`.
- Introduce a timed pressure sequence (e.g. 90 seconds after override) but allow an alternate retry/checkpoint. No unwinnable save made at 1 second left; time resets appropriately on checkpoint retry.
- Optional finale branch: escaped undetected result message vs detected result message, both count as completion. No need for cinematic asset.
- End with a `MISSION COMPLETE` results screen, total run summary and credits.

### Test Arena — DEV ONLY

- A rectangular map with 1 guard, 1 heavy, 1 drone, obstacles, a closed/openable door, test pickup, projectile wall, checkpoint, terminal and detection debug visualization.
- Access via `--scene res://scenes/levels/test_arena.tscn` or editor, NOT visible from release menu.
- Include a stress toggle to activate 10/20/40 agent instances for profiling; log actual conditions when collecting measurements. Debug/test arena must not alter production mission saves.

### Level design acceptance checks

- Walkable routes valid from spawn to every mandatory objective and extraction under normal conditions.
- Keycard and terminal always reachable; relevant doors initially locked/unlocked as intended.
- Player cannot walk outside map or through walls. Guards cannot see through walls. Camera can't spot someone behind walls.
- Closed door affects physics and AI navigation; opened door changes both.
- Checkpoints reload into a valid state; alarms may continue according to saved design, but never trap a checkpoint permanently.

---

## 8. ART DIRECTION & UI SPECIFICATION

### 8.1 Palette / visual design

Use hex palette consistently: background `#0B1421`, wall `#243444`, floor `#162635`, primary cyan `#43D9E8`, secondary teal `#1DBFAF`, warning amber `#FFB454`, alarm red `#F56B73`, text `#E7F0F5`, muted `#96A8B8`. Respect silhouette readability over ornamental detail.

- Distinguish interactables visually using outline/indicator; the E prompt must appear within reach.
- Guard cones translucent amber in debug; only optionally show an in-world simplified alert marker during normal game to avoid giving perfect enemy info.
- Text minimum readable at 1280×720; avoid tiny 6-pixel lettering in critical prompts.
- Text and icons should not look out of place beside pixel art; if art styles conflict, fall back to uniformly styled procedural art until coherent.

### 8.2 UI states

- Main Menu active/hover/disabled/focus state; controller support optional.
- HUD: Health, Stamina, EMP charges, keycards, objective text, Alarm state, interaction prompt.
- Hack progress displays 0–100%, cancels if hurt/out of range, never silently completes while paused.
- Settings have visible audio values, apply/reset, and Back navigation.
- End screen displays stats and optional grade with consistent thresholds.
- Responsive window resizing: maintain 16:9 aspect with bars and anchor HUD to edges.

### 8.3 Animation budget

Required (procedural counts if missing sprite sheet): player idle/walk/attack/hurt, guard patrol/alert/attack/stun, door open, terminal hack, drone scan, camera sweep, EMP burst, pickups hover. These are specific visible state changes, not just variable names.

---

## 9. DEVELOPER OVERLAY — ESSENTIAL FOR INTERVIEW

Toggle with F3 on development builds. Ensure debug draw/overlay is disabled in export release unless explicitly enabled with a config flag.

Required overlay fields:
- FPS (`Engine.get_frames_per_second()`), physics frame count or time, level ID, player position/velocity, health/stamina.
- Enemy count per state; currently nearest enemy's `state`, `detection_progress`, `last_seen_position`, `current_path_length`.
- Active projectile count; pickup count; alarm state; audio sources playing (optional).
- Render guard FOV edges/cones, LOS rays that stop on world collision, navigation paths/waypoints, patrol markers, noise event radius, door collision state. On-screen display must reflect true underlying values, not hard-coded visuals.
- Fixed-size ring buffer of 50 debug events (`timestamp, actor_id, from_state, to_state, reason`) viewable in a simple panel and printable to logs.
- Optional separate `docs/debug_session_samples/` logs only if actually generated; avoid committing personal filesystem paths.

Include clearly documented reproducible debug scenarios:
1. Enemy should not detect through a wall.
2. Enemy should not be stuck after closed door opens.
3. Attack overlap causes at most one hit per swing.
4. Repeated pause/resume and reload does not create duplicate alerts or entities.
5. Detection goes CHASE→SEARCH→RETURN→PATROL after LOS is lost.

These scenarios must be **tested**, not intentionally shipped as existing bugs. `docs/DEBUGGING_CASE_STUDIES.md` must separate **hypothesized failure modes**, **actual reproduced issues**, **fix**, **before/after evidence**.

---

## 10. TESTING STRATEGY — AUTOMATED + MANUAL

### 10.1 Zero-dependency test harness

Implement a runnable `tests/run_tests.gd` extending `SceneTree`. Each test method validates state with explicit assertions and returns structured success/failure counts. Exit the process with **0 on success** and **non-zero on failure**. Avoid using only `assert()` if release/dev settings may bypass it; make explicit checks. Automated tests should not require a graphical display or sound. Use mock scene/test doubles where necessary, but also include real scene integration tests.

Required command (after import):

```bash
godot --headless --path . --script res://tests/run_tests.gd
```

Project import/parser smoke:

```bash
godot --headless --path . --editor --import
godot --headless --path . --quit-after 120
```

On Mac when `godot` isn't in PATH, use the actual downloaded `.app/Contents/MacOS/Godot` executable. Do not say these commands passed unless executed.

### 10.2 Automated test cases (minimum)

| Test ID | Scenario / expected |
|---|---|
| T01 | Walking diagonal normalization matches straight movement speed |
| T02 | Sprint drain stops at zero, regen bounded and delay obeyed |
| T03 | Crouch speed lower, hearing noise not equal to sprint |
| T04 | `apply_damage(-1)` ignored; zero HP emits exactly one death |
| T05 | Invulnerability prevents repeated rapid player damage |
| T06 | An attack hitbox damages/stuns one target at most once per swing |
| T07 | Enemy idle patrol transitions on noise to investigate |
| T08 | Enemy LOS blocked by wall, even within radius/FOV |
| T09 | Enemy LOS outside FOV cannot detect player |
| T10 | Chase loses target → search → return → patrol after timeout |
| T11 | Stun cancels attack and releases control after timer |
| T12 | Alert event propagation deduplicated by event ID |
| T13 | Keycard cannot be collected twice |
| T14 | Locked door rejects missing keycard and opens with matching keycard |
| T15 | Terminal interaction cancels when player leaves range |
| T16 | Mission objective rejects missing prerequisites, complete once |
| T17 | Extraction blocked before mandatory objectives completed |
| T18 | Save JSON roundtrip preserves inventory / checkpoint / doors / pickups |
| T19 | Invalid/corrupt/unsupported future-version save fails safely |
| T20 | Level 1, 2, 3 required paths and references are valid |
| T21 | Restart level doesn't spawn duplicate player / autoload listeners |
| T22 | Pause stops simulation timers, pause UI still works |
| T23 | EMP consumes one charge, stuns valid entities once, ignores invalid target |
| T24 | Enemy projectile/attack blocked by solid wall |
| T25 | Reaching finale with required objectives triggers results once |

Recommended additional tests: JSON migration handling, all game menus instantiate in headless mode, active enemy count doesn't leak after scene change, collision layer matrix matching docs, interaction priority. Some physics and navigation behavior requires scene integration or manual tests: document which mode executed.

### 10.3 Manual playtest checklist

- Play from main menu through all 3 levels using keyboard and mouse.
- Retry after death; load checkpoint; close/relaunch; Continue resumes at expected state.
- Collect multiple keycards; open door; walk through; enemy follows only where it should.
- Let guard see player → escape behind wall → observe search and return.
- Test camera detection behind a wall; EMP-disable/re-enable.
- Test high-stress scene; reduce shadows/visual debug and compare FPS.
- Test window resize, settings, focus, alt-tab/back-to-game, audio volume persist.
- Ensure no red errors in Godot debugger during a full level playthrough.

### 10.4 CI

Create `.github/workflows/godot-ci.yml` pinned to an actual verifiable Godot 4.7.2 executable/artifact and running on PR/push. Avoid pointing to a nonexistent container image. CI must:
1. Checkout repository.
2. Install/download editor in a verified way (e.g. official 4.7.2 release URL resolved/checked, not a guessed host).
3. Verify `godot --version` is correct.
4. Run import.
5. Run `tests/run_tests.gd`, fail on non-zero exit.
6. Perform parser/game smoke headless and capture logs.

If installing an exact engine version in CI is blocked, do not add a broken pretended-success workflow. Provide setup steps and clearly mark CI as blocked.

---

## 11. PERFORMANCE & RELIABILITY

Test on the user's reasonable target: **Apple Silicon Mac M1 with 16 GB RAM**. Do not fabricate FPS. Engineering targets:
- Target 60 FPS at reference view for default levels on M1; measure if hardware is accessible.
- Target no visible 1-second hitch on level transitions after initial load; count hitches using real profiling data.
- 10 simultaneously active guards and a handful of projectiles should not cause sustained frame drops in ordinary scenes; stress scene explores 10/20/40 agents and records results, not a pass assumption.
- Avoid per-frame expensive raycasts against every scene entity: only scan near candidates, time-slice high-cost perception for offscreen actors where reasonable.
- Pool or limit common effects/projectiles; dispose animations/tweens and audio nodes as needed.
- Keep navigation target updates throttled and guard against recalc storms.
- Avoid background processes in paused scenes and repeated signal connections across reloads.
- Keep initial repository/assets under a pragmatic size (prefer <150 MB before any release binaries); do not bundle archives + duplicates.

`docs/PERFORMANCE.md` must include test platform, build/version, number of enemies, resolution, data collection method, measured before/after FPS or frame time, observed bottlenecks, actual changes. If no run, document `NOT MEASURED`.

---

## 12. AUDIO, ART AND LICENSE ACCEPTANCE

- Every third-party file committed to repo appears in `docs/ASSET_INVENTORY.csv` with source, license, original file path and SHA-256; generated original shapes/PNG listed as own work.
- All direct third-party audio/tiles/UI must be legal to redistribute. The selected Kenney pack pages show CC0; preserve source and license docs.
- Asset normalization must not silently rescale pixel art with blurry linear filtering.
- Missing optional audio, image or shader must not crash the project. No hard references to absent external packs.
- `docs/ASSET_SOURCES.md` must contain exact upstream product page URLs, asset license and whether the asset has been included; do not claim a pack was used if it was not.
- No recognizable logos, characters or UI stolen from commercial games. All fictional brand labels within Shadow Protocol are original.
- Preview screenshots and GIFs must be produced from actual Godot output, not image mockups or AI-generated screenshots presented as gameplay.

---

## 13. IMPLEMENTATION ROADMAP — MANDATORY SEQUENCE, NO SKIPPED STAGES

For each stage, create relevant code, run applicable headless checks, record verification and any blockers in `IMPLEMENTATION_STATUS.md` and proceed if the stage's blocking conditions are resolved. On technical failure, fix rather than declaring victory.

### Stage 0 — Prerequisite audit

**Deliver:** current repo inventory; `godot --version` (or actual executable path); documented engine availability; source asset inventory; git repo; `.gitignore`; directory skeleton and status log.

**Pass:** correct engine detected or accurately flagged as unavailable; no destructive modifications; initial project and planned stages recorded.

### Stage 1 — Bootable Godot app with safe visual fallback

**Build:** project settings/input map, autoload services, main menu (functional New Game / Settings / Quit), first level, pixel grid/collisions/player basic movement, camera, a clean UI theme. Use original procedural art until verified downloads are prepared.

**Pass:** Godot editor imports without parse errors; game shows main menu; New Game enters level; WASD moves with solid-wall collision; Quit and menu work; no missing-resource errors.

### Stage 2 — Asset validation and art integration

**Build:** `tools/asset_inventory.py`, asset mapping JSON, **V2 character roster + animation registry & `CharacterVisual` (Section 3A)**, licensed selection/normalization, character/enemy/environment and UI renderers that use assets when mapped and fallback otherwise. Set filtering and proper region/atlas rects only after actual inspection.

**Pass:** no unsupported license files included; all resources resolve; documented asset map points to real files; game still launches without `incoming_assets/` present; **ART-01..ART-07** pass or accurately blocked; every mandatory actor can render a verified/fallback facing.

### Stage 3 — Player systems, interaction and UI

**Build:** movement, sprint/crouch/stamina, health, attack, pickups/keycards, doors and terminal, HUD prompts, hit feedback, animations, audio fallback.

**Pass:** scenario tests T01–T06, T13–T15 and keyboard/manual smoke pass; one sample objective functions end-to-end.

### Stage 4 — Enemy FSM and sensing

**Build:** guard with PATROL, SUSPICIOUS, INVESTIGATE, SEARCH, CHASE, ATTACK, STUNNED, RETURN; directional vision; hearing; simple guard navigation; alarm events.

**Pass:** scenarios T07–T12; debug display shows actual FSM transitions; enemy stops at walls and respects LOS. Run patrol/vision/LOS scenes manually.

### Stage 5 — Combat, EMP, heavy guard, drone/camera

**Build:** nonlethal combat, enemy attacks, heavy variant, drone perception, camera sweep/EMP disable, projectile collision, object cleanup and audio/VFX.

**Pass:** T23–T24, repeat attack hitbox, wall safety; repeated EMP doesn't leave camera permanently offline; no immortal enemies.

### Stage 6 — Three missions and progression

**Build:** all three levels, objective graphs, scripted interactions, checkpoints, alarm/lockdown and extraction. Provide reproducible testing path for each.

**Pass:** all mandatory objectives can be reached and completed. Finish all 3 levels from New Game without developer teleport. Results screens advance correctly and persist progress.

### Stage 7 — Save, load, settings, menus

**Build:** versioned save and corrupt-file handling, pause/settings/new/continue/game over/results, mission stats, complete credits and source information.

**Pass:** T18–T22, save restore, forced corrupt save and relaunch, retry and scene reload don't duplicate actors.

### Stage 8 — Debug overlay and reproducible scenarios

**Build:** F3 panel + drawing for LOS, detection, paths, noise radii, collision, enemy states; dev arena with stress toggles; bounded event log.

**Pass:** debug values correlate with real runtime; overlay toggle doesn't alter AI logic; test arena is separately launchable.

### Stage 9 — Automated testing, CI and stabilization

**Build:** complete 25+ tests, `tools/validate_project.sh`, GitHub Actions workflow (only if source is verified), crash/error fix pass; benchmark report.

**Pass:** all executable automated tests pass locally; regular gameplay runtime observed; all untested items clearly labeled. No fabricated results. When Godot is unavailable, mark this stage blocked rather than green.

### Stage 10 — Portfolio polish

**Build:** stronger visual identity using V2 selected consistent cast and matching environment, `character_showcase.tscn`, `CHARACTER_ART_BIBLE.md`, ART-01..22 checks, UX polish, tooltips/tutorial, README with real screenshots, video guide, architecture diagrams, debug write-up, short recruiter pitch.

**Pass:** a new developer can clone and run using README; screenshots are real; 5–8-minute interview path works.

### Stage 11 — Packaging and handoff

**Build:** release export presets, packaged desktop builds (only for platforms that can be exported), final `IMPLEMENTATION_STATUS.md`, asset licenses, changelog, clean git repo.

**Pass:** clean clone imports and launches; export path works if templates available; report exact generated build paths and checksums. Explicitly list not completed/blocked areas.

---

## 14. EXACT ASSET-TO-GAME ADAPTATION RULES

When actual licensed pack images are available, construct the following mapping by VISUAL/AUTOMATED INSPECTION, not guesses. Use the manifest to preserve origin:

| Logical asset key | Preferred source | Fallback if source lacks suitable art | Required function |
|---|---|---|---|
| `player_body` | Riclmbr 32×32 cast (or MurphysDad spy), per Section 3A | Original cyan body + heading wedge | Visible player + direction |
| `guard_body` | Riclmbr Security Guard or MurphysDad Hazmat (Section 3A) | Original orange uniform body | Guard visible / independent from player |
| `heavy_body` | Riclmbr armored/security cast (or free recolored hazmat), per Section 3A | Larger plated orange/red silhouette | Visibly armored |
| `drone_body` | Riclmbr drone/security bot (or original polygon), per Section 3A | Original polygonal hover robot | Patrol/drone recognition |
| `floor_tile` | Riclmbr 16×16 floor tile adapted to logical 32px grid; or CC0 alternative | Original 32×32 grid patterned tile | Readable walkable floor |
| `wall_tile` | Riclmbr wall tile or CC0 alternative | Original solid wall/block | Clear obstruction + collision |
| `door_open/closed` | Riclmbr door or free laboratory pack | Original animated rectangular door | Visible lock state / collision |
| `terminal` | Riclmbr terminal/server rack or free laboratory pack | Original cyan console + glow | Hack/disable target |
| `keycard_blue/red` | Riclmbr keycard (or Kenney Game Icons CC0) | Original keycard polygons/icons | Clear colored pickup |
| `data_chip` | Riclmbr data chip (or Kenney Game Icons CC0) | Original diamond microchip | Mandatory mission item |
| `emp` | Riclmbr EMP item/VFX (or Kenney Game Icons CC0) | Original circular electric icon | Charge count and effect |
| `ui_button/panel` | Riclmbr same-kit UI or Kenney UI Pack Sci-Fi | Native Control + StyleBoxFlat | Working menus / HUD |
| `sfx_hack/alert/door` | Sci-Fi Sounds | silent / synthesized original pulse | Audio feedback when installed |
| `sfx_click/confirm` | Interface Sounds | native click feedback only | UI navigation |
| `sfx_hit` | Impact Sounds | flashing/hit VFX without sound | Combat response |
| `menu_sting/victory_sting` | Music Jingles (select suitable clip) | silent | Optional short transition |

**Slicing requirements:** The preferred premium page advertises 32×32 character cells, but never hardcode actual file/row layout before seeing the ZIP. Do not hardcode `32x32` source texture if the source sheet uses different dimensions. Compute actual PNG dimensions and manually confirm the region layouts. Use **game tile size 32×32** as a logical map unit, not as an assertion about art file dimensions. When scaling low-resolution sprites, use integer scale and nearest filtering if appropriate.

**Cohesion check:** all characters should appear correctly top-down and sized similarly relative to doors; don't mix side-on soldiers with isometric buildings. If a pack fails the cohesion check, don't use that pack in gameplay simply to satisfy a download checklist.

---


## 14A. V2 ART MIGRATION ROADMAP AND EXECUTABLE WORK CONTRACT

> New V2-only section. Never delete tested V1 gameplay while upgrading visuals. Use small commits and maintain a playable main branch.

### 14A.1 V2 implementation stages — relative to original stages 0–11

| Stage | Concrete tasks | Gate |
|---|---|---|
| **V2-0: Audit** | Read full V1-compatible spec, current project, Godot version, archive inventory; create `docs/ART_MIGRATION_PLAN.md` | No actual project content overwritten; data gathered |
| **V2-1: Acquire / verify** | User downloads premium or free ZIP; agent scans ZIP, LICENSE, `assets.json`, previews; catalog only real files | One verified pack or marked fallback; no unsafe extraction |
| **V2-2: Character data** | Build roster/config, per-character profile, four-way animations from exact supplied frames/regions | ART-02/04/07/11; all frame resources load |
| **V2-3: Visual component** | Introduce `CharacterVisual` into Player/Guard/Heavy/Drone, keep gameplay FSM/physics unchanged | Existing V1 tests pass; KO/attack faces correct direction |
| **V2-4: World cohesion** | Same-kit tiles, HUD/icons, foreground ordering, lights, contact shadows, optional audio polish | Collision/nav unchanged; art accepted at 640×360 |
| **V2-5: Character showcase** | Build `character_showcase.tscn`, selectors, state preview, coordinates, scale and pivots | Every selected semantic actor previewable in all states |
| **V2-6: QA and performance** | Run original 25+ tests plus ART-01–ART-22, play through 3 levels, record actual frame timings | No regression, all failures documented/fixed |
| **V2-7: Portfolio** | Update README, runtime screenshots, art credits, tech write-up, 3–6 minute video guide; create valid GitHub-ready commit | No promotional images described as game capture; no unlicensed art |

### 14A.2 What Codex MUST DO with actual game files

1. Ensure `project.godot` works before asset import; do not re-create repo from scratch if the V1 source already exists.
2. Perform character art ingestion using only the exact ZIPs found; emit an asset inventory table (archive, path, width, height, source, license verdict).
3. Choose one cast style across the gameplay roster; do not mix Riclmbr pixel art characters with high-resolution Sova sprites or side-scrollers.
4. Implement complete scene/scripts/resources and **actually wire** CharacterVisual nodes for all four actor classes. An unused `character_visual.gd` does NOT satisfy this stage.
5. Validate the sprite atlas cells and export one preview/test scene for each character. If image tools cannot inspect art, create preview scene and mark human inspection `NOT VERIFIED`.
6. Keep player/guard combat cooldown, KO, EMP, F3 debugging and AI perception orthogonal to sprite animation transitions.
7. Preserve progress save compatibility; new art profile selection must not break old checkpoint loads. Make visual-only changes backwards compatible.
8. Update actual README with truthful mode and credits; write commands for local Godot 4.7.2 on Mac M1.
9. All stages include `IMPLEMENTATION_STATUS.md` evidence, exact commands actually executed and test result summaries. Don't make up 60FPS, clean clone, playable release ZIP or runtime screenshots.

### 14A.3 Terminal + Godot verification recipes

After source assets have been manually downloaded (example, adjust to actual paths and installed executable):

```bash
cd "$HOME/Projects/shadow-protocol"
mkdir -p incoming_assets
find incoming_assets -maxdepth 1 -type f -print
unzip -l "incoming_assets/ACTUAL_DOWNLOADED_NAME.zip" | sed -n '1,60p'

# Codex must IMPLEMENT these scripts before running them; these are expected interfaces,
# not a claim they currently exist.
python3 tools/inspect_character_pack.py --inventory --input incoming_assets --output docs/ASSET_INVENTORY.csv
python3 tools/prepare_assets.py --mapping config/asset_mapping.json

GODOT_BIN="/Applications/Godot.app/Contents/MacOS/Godot"
"$GODOT_BIN" --version
"$GODOT_BIN" --headless --path . --editor --import
# Generate SpriteFrames only after imports succeed; implement tool for valid CLI invocation.
"$GODOT_BIN" --headless --path . --script res://tools/build_spriteframes.gd
"$GODOT_BIN" --headless --path . --script res://tests/run_tests.gd
```

If Godot executable has a different installed name or tests require arguments, discover correct command and update `docs/SETUP.md`. If no Godot is available, run static checks and accurately mark engine tests blocked.

### 14A.4 Specific criteria for making visuals look professional

1. **Contrast:** gameplay readability comes first. Every enemy must remain visible on dark flooring and player silhouette must not disappear beneath terminal glow.
2. **Composition:** each mission has a distinct room palette (Access cyan, Vault violet, Escape red warning), but all use same art source/type and consistent exposure.
3. **Animation cadence:** no rapid toggling between idle/walk, or repeating hurt animation per frame; non-looping KO does not reset during stun.
4. **Environmental feedback:** interaction outline, terminal progress, small sparks on hacks, warning lights during alarm, shadow under actor, coherent VFX lifetime.
5. **UI:** not more than a few screens of symbols. Consistent panels/margins, keyboard prompts, context actions and stamina/health bars.
6. **Performance:** cap nonessential particles and local lights; profile with actually measured numbers, note platform/resolution/guards count.
7. **Scale:** use one global pixel density strategy, never arbitrary `Vector2(1.37, 1.37)` scaling of pixel sprites to fix size errors.
8. **Provenance:** CC0 proof/credits, no trademarked character sprites, no restricted AI dataset pack in repository.

### 14A.5 File-level review checklist (GitHub PR style)

- [ ] `config/character_roster.json` links semantic actor keys to real profiles or fallback.
- [ ] `config/asset_pack_registry.json` reflects measured archive/license status.
- [ ] `scripts/characters/character_visual.gd` has typed, state-safe animation API.
- [ ] SpriteFrames resources exist and contain valid source frames for all mandatory directions.
- [ ] `player.tscn`, `guard.tscn`, `heavy_guard.tscn`, `drone.tscn` instantiate CharacterVisual.
- [ ] `character_showcase.tscn` is playable/debuggable (not a blank scene).
- [ ] Environment and actor scale match world collision/nav grid.
- [ ] F3 overlay can show visual state + AI state per actor without replacing normal gameplay.
- [ ] `docs/ART_QA_REPORT.md` has honest pass/fail/blocked for ART-01..22.
- [ ] README uses real screenshots or clearly labeled art preview references.
- [ ] `docs/ASSET_LICENSE_AUDIT.md` and `ASSET_SOURCES.md` list exact used packages and CC0 evidence.
- [ ] `GODOT --headless ... --editor --import` and test runner pass in a real engine environment (or accurately blocked).
- [ ] All original main menu, 3 missions, save/load, EMP, AI tests and gameplay tests still work.
- [ ] A clean clone can run with committed assets (not requiring `incoming_assets` at runtime).

---

## 15. GODOT TOOL COMMANDS, SMOKE VALIDATION AND EXPORTS

### 15.1 Local prerequisites (macOS Apple Silicon)

1. Download **Godot 4.7.2 stable / macOS Universal / Standard** from https://godotengine.org/download/archive/4.7.2-stable/. Do **not** select .NET unless using C# (this spec is GDScript only).
2. Unzip and move `Godot.app` to `/Applications/` if desired. On macOS, allow the application through OS security settings if prompted by a legitimate downloaded/signed app. Do not disable system security globally.
3. Find the engine command executable. If installed at the conventional path:

```bash
/Applications/Godot.app/Contents/MacOS/Godot --version
```

4. Optional terminal alias for the current shell: `alias godot='/Applications/Godot.app/Contents/MacOS/Godot'`. Confirm with `godot --version` after alias assignment. If actual `.app` name differs, use actual location.
5. In GitHub project root, open the folder in Godot Project Manager using **Import** and choose `project.godot`; let it finish resources import.

### 15.2 Validation workflow

```bash
# From repository root. Replace `godot` with the full macOS executable path if needed.
godot --version
godot --headless --path . --editor --import
godot --headless --path . --script res://tests/run_tests.gd
godot --headless --path . --quit-after 120
# Visual verification (mandatory when an interactive desktop is available):
godot --path .
```

`--quit-after` is a smoke startup test, **not** proof the level is playable. To validate Godot script parsing more explicitly, use editor import and the Godot stdout/stderr with exit codes. Tests must run in a mode that lets failures return non-zero.

### 15.3 Export settings

- Project → Export → install official export templates matching **4.7.2** → Add presets for macOS, Windows Desktop and Linux (subject to actual platform tooling). Export scene/resource dependencies as needed.
- Commit `export_presets.cfg` when it contains no sensitive info. **Never** commit `.godot/export_credentials.cfg` or signing passwords.
- Recommended output locations `builds/macos/`, `builds/windows/`, `builds/linux/` in ignored build folder. Source repository always includes `project.godot`.
- Test launch of an actual built executable if generated; if you cannot run an OS-specific build, label that export `BUILT, NOT RUN-TESTED`.
- Release artifacts and screenshots require a separate real generation step; do not create a README download link until the file exists.

### 15.4 Suggested `.gitignore`

```gitignore
.godot/
*.tmp
*.log
.DS_Store
incoming_assets/
builds/
dist/
.cache/
__pycache__/
.pytest_cache/
```

Note: `.godot/` contains editor import/cache data; keep `project.godot`, `.tscn`, `.tres`, project scripts and relevant source resources version controlled. Do not ignore actual `assets/` content used by scenes.

---

## 16. ENGINEERING QUALITY AND EDGE CASES

### Code robustness

- Avoid long methods: separate movement/perception/state transitions/attack handling and UI binding. Prefer no file above ~400 lines without architectural reason.
- All asynchronously finishing interactions/tweens must verify actor and scene still exist (`is_instance_valid`) and cancel safely on scene switch.
- Handle no enemy player reference on scene teardown; handle detection when target dead.
- Avoid repeated signal connections during checkpoint reloads and double instantiation of global services.
- Limit tweens/timers created per frame; schedule rechecks intentionally.
- Input handling must use event vs held-input appropriately (E once vs WASD held).
- Save manager validates fields and unexpected values before applying game state.
- Enemies cannot attack through a wall even if their navigation status says near target.

### Balance and fairness

- Always show readable security camera sweep and red alarm warning.
- Player is never placed in unavoidable instant detection during respawn; grant short grace window when spawning if needed.
- Mandatory mission pickups do not spawn inside inaccessible collision or under HUD-only modal.
- Every locked path has a real obtainable keycard/terminal unlock or alternate route.
- On final timer failure, retry available without corrupting checkpoint.

### Scope guardrails

Do not overbuild network/multiplayer, procedural generation, 3D open world, microtransaction systems, account login, online leaderboard, mobile control overlays or marketplace integrations. Finish the polished 2D game first.

Optional **3D expertise demonstration after all required gates:** a tiny separate `scenes/3d_demo/` playable room using `CharacterBody3D`, `NavigationAgent3D`, `AnimationPlayer`, `Control`, debug camera and primitive meshes. Explicitly label it `EXPERIMENTAL 3D TECH DEMO`. It must not be a substitute for required levels or degrade the 2D game. Do not claim professional 3D experience from one toy scene.

---

## 17. GITHUB RECRUITER EXPERIENCE & DOCUMENTATION

### README.md (English; in this exact rough order)

1. Project name + short hook and **real** hero gameplay screenshot (if available).
2. A clear 1-paragraph feature pitch, 15–25-min gameplay length and key controls.
3. `Watch Demo` link only if a real recording exists; real GIF/screenshots stored in `docs/screenshots/`.
4. `Play` section with real build links only if verified; no dead links.
5. `Run from source` with Godot **4.7.2 stable** and Mac/Windows/Linux import steps.
6. Tech stack: GDScript, CharacterBody2D, TileMapLayer, NavigationAgent2D (if truly used in core), finite-state machines, RayCast2D, Area2D, Resources, FileAccess, audio buses.
7. Systems architecture diagram or simple Mermaid (no proprietary images necessary).
8. `Debugging & Performance` with reproducible scenarios and factual measured data, if obtained.
9. Testing commands and CI badge only if CI runs successfully.
10. Project directory map and license/asset credits (explicit actual source links (Riclmbr/MurphysDad/Kenney as used)).
11. Honest development notes: role of AI-assisted coding if used, features fully implemented, known gaps and learning outcomes.

### `docs/REPRODUCE_WORKFLOWS.md`

Prepare 5 short human-executable workflow scripts suitable for a technical interview. For EACH workflow include `Goal`, `Starting state`, `Actions in Godot Editor` (click paths and file names), `Reason`, `Expected observation`, `How to verify`, and `Reset`. Scenarios:

1. Create/modify Patrol to Chase to Search transitions.
2. Debug a guard spotting the player through a wall using collision mask and LOS ray.
3. Change wall/door collision and regenerate/verify navigation route.
4. Profile stress arena with 10/20/40 guards and compare actual frame times.
5. Add a new hack terminal interaction, UI label and mission objective using reusable components.

Make instructions accurate for the implemented scene tree; don't write generic tutorial steps that can't be followed in this project.

### `docs/DEBUGGING_CASE_STUDIES.md`

Use real issue records when available, with `symptoms → reproduce → root cause → evidence → fix → regression test`. Do not invent incidents or before/after measurements. If no real defect observed, provide `POTENTIAL DEBUGGING CHALLENGE (not a production bug)` with a prepared test sandbox and expected correct behavior.

### `docs/VIDEO_CAPTURE_GUIDE.md`

3–6 minute technical demo runbook:
- 0:00–0:30 menu + mission premise and controls.
- 0:30–1:15 player movement / crouch / interaction.
- 1:15–2:00 enemy patrol + vision/LOS + alarm.
- 2:00–2:45 stun + EMP + locked door + objective.
- 2:45–3:45 F3 AI state/path visualization and test arena bug scenario.
- 3:45–5:00 save/load + tests & architecture overview.
- 5:00–6:00 results + repo/docs summary if recording duration allows.

Only use this guide for a **real capture**. Don't create a fake gameplay demo using unrelated footage.

### Candidate profile line (only after implementation)

`Built Shadow Protocol, a modular stealth-action Godot game with GDScript-based enemy state machines, raycast perception, physics interactions, save/load, debug visualization and automated scene tests.`

---

## 18. RELEASE QA / OBSERVABILITY MATRIX

| ID | User-facing behavior | Functional proof | Required status |
|---|---|---|---|
| A01 | New Game launches level 1 and teaches controls | Real gameplay capture / smoke | PASS |
| A02 | 8-way motion, sprint, crouch, wall collision | Tests + manual play | PASS |
| A03 | Enemy patrol/pathing works around walls | Debug overlay + manual | PASS |
| A04 | Enemy vision blocked by walls, FOV and range | Tests + visual LOS | PASS |
| A05 | Hearing investigate + Chase/Search/Return transitions | FSM tests + debug event log | PASS |
| A06 | Attack / stun / EMP functional and non-duplicating | Combat tests + visual | PASS |
| A07 | Security camera sweeps, alarm, temporary disable | Manual + integration | PASS |
| A08 | Keycard/door/terminal/pickup interactions | Interaction tests + manual | PASS |
| A09 | Level 1–3 playable from start to extract | Manual full completion | PASS |
| A10 | Extraction refuses premature entry | Mission test | PASS |
| A11 | Save/load/checkpoint including corrupt-file behavior | Tests + relaunch | PASS |
| A12 | Menu, Pause, Settings, Results, Credits | Scene smoke/manual | PASS |
| A13 | HUD and Developer Overlay show true runtime state | Manual inspection | PASS |
| A14 | Sound fallback does not crash when absent | No-asset headless smoke | PASS |
| A15 | Asset inventory/license provenance complete | Inventory audit | PASS |
| A16 | 25+ automated tests (or explicit blocked cases) | CLI process exit | PASS for final accepted game |
| A17 | Clean `godot --editor --import` + game startup | CLI process exit/log | PASS |
| A18 | README and real screenshots + working steps | Clone/install audit | PASS |
| A19 | Release export when compatible templates exist | Verify export files | CONDITIONAL |
| A20 | Measured perf numbers, never guessed | Actual logs on available hardware | CONDITIONAL |

**Release blockers:** A01–A18 are mandatory. A19–A20 can be labeled BLOCKED only with exact reason and alternative verification; user can decide whether to publish before solving those issues. A developer should not silently lower quality gates.

---

## 19. AGENT REPORTING / HANDOFF FORMAT

After each stage, update `IMPLEMENTATION_STATUS.md` using:

```markdown
## Stage N — [Title]
Status: PASS | FAIL | BLOCKED | PARTIAL
Implemented files: [actual paths]
Validation commands: [commands actually run]
Results: [real exit code, observed outcome, relevant log path]
Manual checks: [performed / not performed and reason]
Known issues: [real unresolved issues]
Next stage: [specific]
```

In the final reply to the user, provide:
- What is **actually playable** and how many levels are actually completed.
- Exact path to `project.godot` and command to run.
- How to set up/update assets using the separately provided Vietnamese guide.
- Tests actually executed, pass/fail counts, and commands.
- Optional export build paths only if the files exist.
- Explicit limitations/human verification tasks (e.g. manual Godot review of navigation, asset downloads, real gameplay capture).
- Git changes and the next sensible improvement.

**Do not claim game is finished solely because source files were written.** Import, run and playtest are essential.

---

## 20. FINAL CODING AGENT PRIORITY / DECISION TREE

1. **Can Godot run?** Yes → set version + import / tests. No → attempt safe documented installation or flag inability and continue generating legitimate sources.
2. **Are Kenney downloads present?** Yes → inventory, license, visually verify mapping, integrate. No → original procedural assets and an actionable user download checklist; never block gameplay.
3. **Is first level playable?** No → stop adding features and fix basics. Yes → next system.
4. **Are AI perception/pathing correct?** No → fix before adding more enemy types.
5. **Can every level be completed from spawn?** No → fix objective/nav route, do not add polish.
6. **Does saving/reloading preserve consistent mission state?** No → fix before demo.
7. **Does headless test suite exit 0?** No → fix or list exact unblocked failures; do not call complete.
8. **Are README screenshots from actual game?** No → take real screenshots or omit them; no mockup impersonation.
9. **Does a public repository carry only legally reusable assets?** No → remove/rework unlicensed content.
10. **Do final quality gates A01–A18 pass?** Yes → prepare releases/documentation. No → report partial completion.

**Agent instruction:** Implement the complete game according to this spec. Use iterative edit → Godot import → test → manual evaluation → fix cycles. Prefer real working mechanics and honest checks over large quantities of untested code.

---

## 21. VERIFIED REFERENCE LINKS (official sources)

**Godot**
- Godot 4.7.2 official archive (macOS Universal Standard included): https://godotengine.org/download/archive/4.7.2-stable/
- Godot official command-line guide: https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html
- Godot TileSets/TileMapLayer documentation: https://docs.godotengine.org/en/stable/tutorials/2d/using_tilesets.html
- Godot exporting projects: https://docs.godotengine.org/en/stable/tutorials/export/exporting_projects.html
- Godot NavigationAgent2D reference: https://docs.godotengine.org/en/stable/classes/class_navigationagent2d.html

**Kenney / CC0**
- https://kenney.nl/assets/top-down-shooter
- https://kenney.nl/assets/sci-fi-rts
- https://kenney.nl/assets/ui-pack-sci-fi
- https://kenney.nl/assets/sci-fi-sounds
- https://kenney.nl/assets/interface-sounds
- https://kenney.nl/assets/impact-sounds
- https://kenney.nl/assets/game-icons
- https://kenney.nl/assets/music-jingles

**License context**
- CC0 legal summary: https://creativecommons.org/publicdomain/zero/1.0/
- Godot demo projects (reference only; do not blindly copy assets): https://github.com/godotengine/godot-demo-projects

**Note:** External URLs are source pages verified when spec was prepared; download button endpoints and archive internal filenames can change. Validate at actual download time. Never invent a direct ZIP URL or import missing assets by name alone.


## 22. V2 SOURCE REGISTER AND RESEARCH LIMITATIONS

These publisher links were checked against their public pages on **12 November 2026**. The project does not contain downloaded asset packs yet; current asset file contents, true license files, frame region mapping and gameplay visuals have **not** been verified. Prices are snapshots. Read actual ZIP/README/LICENSE at build time.

| Source | URL | Key verified publisher claim | Status for Codex |
|---|---|---|---|
| Riclmbr Neon City | https://riclmbr.itch.io/pixel-cyberpunk-neon-city-300-top-down-cyberpunk-assets | 50 animated 32×32 characters, 16×16 tiles, 11 animations per character, CC0, paid | Preferred if purchased ZIP present and license confirmed |
| MurphysDad Sci-Fi Facility | https://murphysdad.itch.io/sci-fi-facility | Spy/Hazmat four-direction sprites + facility, CC0, free | Safe visual alternative once actual ZIP verified |
| DKZeus Sci-Fi All-in-One | https://dkzeuss.itch.io/sci-fi-all-in-one-asset-pack | Animated 4-direction astronaut and 16×16 tiles, free game use | No raw public commitment without redistribution verification |
| Chrome District | https://booliebuilds.itch.io/chrome-district | 20 eight-direction walk characters; page prose CC0 but metadata CC BY 4.0 | Blocked pending license clarification |
| TheDinoSet Sci-Fi | https://thedinoset.itch.io/free-sci-fi-pixel-art-asset-pack-100-16x16-sprites-space-characters-aliens-ite | 10 characters + 12 enemy robots/aliens, game-use license | Optional local, no raw commit without grant |
| Sova Free Footsoldier / Combat Drone | https://sovdigital.itch.io/free-footsoldier and https://sovdigital.itch.io/free-combat-drone | Eight-direction HD sprite animations; license bans dataset use and raw sharing | Excluded baseline |
| Danwolfe Sci-fi Characters | https://danwolfe.itch.io/sci-fi-character-sprites | Beautiful themed characters but 'no Training/Generative AI' | Excluded baseline |
| Godot 4.7.2 stable | https://godotengine.org/download/archive/4.7.2-stable/ | 4.7.2 stable, macOS universal | Required |
| Godot sprite animation docs | https://docs.godotengine.org/en/stable/tutorials/2d/2d_sprite_animation.html | AnimatedSprite2D handles frame images or sheets | Implementation reference |
| Godot pixel art scaling docs | https://docs.godotengine.org/en/stable/tutorials/rendering/multiple_resolutions.html | For pixel-art use 640×360, viewport + keep + integer scaling | Implementation reference |

**Important:** Never train any model on restricted art. An open source project consumed by an AI coding agent is not automatically equivalent to a licensed training dataset. If the final project is later included in an AI evaluation/training workflow, re-check all upstream third-party permissions before that separate reuse. CC0-released art is the safest default for that possibility.
