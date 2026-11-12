# Measured performance

Measured 2026-11-12 on available **Apple M2 Pro, 16 GB RAM**, macOS, Godot 4.7.2.stable.official.ed1daf0bf Standard debug runtime, OpenGL Compatibility (Metal-backed driver), 1280x720 window / 640x360 reference canvas. This is not an M1 measurement.

Method: `godot --path . --script res://tools/benchmark.gd`. Real graphical arena, active AI, all guard instances continue processing, debug cones off, VSync enabled. One second warm-up plus three seconds measured per count. Script records wall-clock process-frame intervals; JSON saved in benchmark.json. Patrol stress agents primarily occupy right arena room; this is not a worst-case full-screen combat or F3 rendering benchmark. Other user applications were open.

| Active guards | Samples | Mean FPS | Mean frame ms | p95 ms | Max ms |
|---:|---:|---:|---:|---:|---:|
| 10 | 354 | 117.42 | 8.52 | 15.64 | 21.63 |
| 20 | 360 | 119.41 | 8.37 | 14.79 | 19.82 |
| 40 | 361 | 119.95 | 8.34 | 14.53 | 15.88 |

VSync caps throughput near 120Hz; small differences between rows are scheduling noise and do not prove 40 guards is cheaper than 10. No before/after optimization baseline was measured. No memory-growth/leak or transition-hitch benchmark has been completed. Required 60 FPS target was exceeded in this particular short arena sample; M1 performance remains unmeasured.

Implementation avoids per-frame path rebuilding (0.25-second repath), bounds debug events to 50, emits sprint noise at 0.6-second intervals, limits EMP lifetime, expires projectiles after two seconds, and frees audio one-shots on finish. These are code facts, not measured optimization deltas.

For meaningful follow-up: run target M1 at normal play, enable F3 separately (13 cone rays per agent per redraw), sample each full level with effects and camera movement, collect longer percentile distributions and transition latency. Use Godot Profiler as described in REPRODUCE_WORKFLOWS.md.


## V2 original character migration

Actual new graphical samples: [v2-benchmark.json](v2-benchmark.json). Apple M2 Pro, macOS Compatibility renderer, 1280x720 window / 640x360 viewport, F3 off, VSync requested, 10/20/40 active guards. One-second warmup, three-second process-frame sample per count. Report mean/p95/max intervals as measured; derived FPS is engine cadence and not an external display-refresh measurement. No controlled before/after gain claimed. M1 and long-session behavior remain unmeasured.
