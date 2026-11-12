# V2 art migration

Baseline: local commit `ab11d7b` (V1). Existing origin points at james1507/shadow-protocol. No push or remote change performed during V2. Backup before edits: `../shadow-protocol-v1-backup.zip`.

Mode: **ORIGINAL_FALLBACK**. No ZIP in incoming_assets. PREMIUM_PACK_ABSENT; free pack absent. No purchase or checkout attempted. Original MIT sprites avoid any third-party license assumptions.

1. Preserve three missions, balance, eight-state AI, attacks, checkpoints and save schema.
2. Generate a cohesive 32px roster, explicit four-facing regions and reusable SpriteFrames/profiles.
3. Wire CharacterVisual into player, guard, heavy and drone; add a decorative scientist and Level 3 guard variant.
4. Fix feet at (16,27), keep colliders unchanged; integer viewport scaling, Y-sorted original server foregrounds.
5. Add interactive 2x/4x lab; test state priorities, resource geometry, signals and 20 reloads.
6. Run V1 regression/campaign, measure actual graphical performance, capture runtime scenes, export V2 separately.

External upgrade ceiling: importer inventories exact ZIP contents, but never guesses vendor animation rows. A reviewed mapping and explicit license evidence are required before replacing original profiles. No pack integration can be claimed until a real archive is supplied.
