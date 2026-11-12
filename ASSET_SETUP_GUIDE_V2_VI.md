# SHADOW PROTOCOL V2 — HƯỚNG DẪN CHỌN/TẢI ASSETS NHÂN VẬT (MAC M1)

> Tài liệu cho người dùng, sử dụng cùng `SHADOW_PROTOCOL_MASTER_SPEC_V2.md`. **Đây là tài liệu hướng dẫn tải, không kèm sẵn asset có bản quyền.**

## 1. Mục tiêu nâng cấp

Bản v1 chủ yếu dựa vào Kenney và hình đơn giản. Bản v2 ưu tiên 1 bộ art có sẵn nhiều nhân vật, animation thực sự (4 hướng), môi trường, vật phẩm và hiệu ứng cùng phong cách. AI/gameplay/physics vẫn như v1: 3 levels, enemy patrol/chase/search, camera, EMP, save/load, F3 debug.

## 2. Chọn một trong hai đường đi

### A — Đẹp và đồng bộ nhất: Riclmbr, **có phí**

Trang chính thức: https://riclmbr.itch.io/pixel-cyberpunk-neon-city-300-top-down-cyberpunk-assets

- Tên pack: **Pixel Cyberpunk: Neon City - 300 Top-Down Cyberpunk Assets**.
- Trang nhà phát hành ghi **50 characters 32x32**, `idle/walk` bốn hướng, `attack` ba hướng, `hurt/death`, cùng tileset 16×16, effects/UI/props; license **CC0 1.0**.
- Giá kiểm tra **12/11/2026**: **$4.54 giá sale / $6.99 giá gốc**. Giá có thể thay đổi. Người dùng tự thanh toán; Codex không mua được.
- Đây là **lựa chọn mình đề xuất nếu muốn portfolio trông chuyên nghiệp**.

**Tải từng bước:**
1. Mở link ở trên.
2. Xem hình preview và thông số, xác nhận tên tác giả **Riclmbr** và dòng **License CC0**.
3. Nhấn **Buy Now**, thanh toán trên itch.io bằng cách bạn lựa chọn nếu quyết định mua.
4. Sau khi mua, mở phần download của đơn hàng, tải ZIP của đúng pack này. Trang đang liệt kê `PixelCyberpunkNeonCity.zip` (~2.9 MB); **tên file thực tế có thể thay đổi**.
5. Giữ nguyên ZIP. Không đổi tên file/sửa spritesheet hay tự cắt ảnh trước khi Codex scan.
6. Di chuyển file ZIP vào thư mục `incoming_assets` ở mục 4.

### B — Miễn phí, pháp lý rõ ràng, đủ cho stealth game: MurphysDad

Trang chính thức: https://murphysdad.itch.io/sci-fi-facility

- Tên pack: **Sci-Fi Facility Asset Pack**.
- Có nhân vật **Spy** và **Hazmat** chuyển động bốn hướng, floor/wall, lab computers, electric gates, noisemakers.
- License trên trang: **Creative Commons Zero 1.0**. Miễn phí hoặc ủng hộ tự chọn.
- Bộ này nhỏ hơn, animation chiến đấu có thể không có; Codex sẽ bổ sung bằng **hiệu ứng Godot** chứ không giả mạo file gốc.

**Tải từng bước:**
1. Mở link trên, nhấn **Download Now**.
2. Chọn hình thức tải miễn phí nếu có (tùy UI itch.io) hoặc ủng hộ tùy ý.
3. Lưu file ZIP về Downloads; trang giới thiệu `sci-fi-facility-asset-pack.zip` (~28 KB).
4. Di chuyển file ZIP vào `incoming_assets`.

### Nên tải bổ sung — UI và SFX (nếu cần)

- Kenney UI Pack Sci-Fi: https://kenney.nl/assets/ui-pack-sci-fi
- Kenney Sci-Fi Sounds: https://kenney.nl/assets/sci-fi-sounds
- Kenney Interface Sounds: https://kenney.nl/assets/interface-sounds
- Kenney Impact Sounds: https://kenney.nl/assets/impact-sounds

Các trang Kenney này ghi CC0. Dùng UI/SFX nếu cùng style, không cần dùng lính/zombie Kenney làm nhân vật chính.

## 3. Một số bộ khác vì sao KHÔNG được chọn mặc định

- **Sova Digital Footsoldier / Drone** đẹp (8 hướng, Godot-ready) nhưng **license cấm chia sẻ sprites dưới dạng assets và cấm dùng trong datasets**. Do bạn đang chuẩn bị portfolio cho vai trò liên quan huấn luyện/đánh giá AI, không nên đưa vào baseline công khai.
- **Danwolfe sci-fi** có animation chiến đấu đẹp nhưng ghi **không dùng cho Training/Generative AI**, nên không chọn cho repo có thể tái sử dụng như task/evaluation.
- **CHROME DISTRICT** có 20 nhân vật đi 8 hướng, tuy nhiên trang viết CC0 trong nội dung **nhưng metadata itch.io lại ghi CC BY 4.0**; chưa giải quyết mâu thuẫn nên không chọn làm mặc định.
- **DKZeus** có sprite astronaut miễn phí và đẹp; trang cho phép dùng trong game thương mại nhưng chưa xác nhận quyền phân phối lại *file raw* trong GitHub. Chỉ chọn sau khi kiểm tra license trong archive.

## 4. Chuẩn bị trên Mac M1

Cài Godot Standard 4.7.2 stable (Mac Universal), không cần .NET: https://godotengine.org/download/archive/4.7.2-stable/

Mở Terminal:

```bash
mkdir -p "$HOME/Projects/shadow-protocol/incoming_assets"
open "$HOME/Projects/shadow-protocol/incoming_assets"
open "$HOME/Downloads"
```

Dùng Finder để kéo các ZIP tải về từ Downloads sang thư mục `incoming_assets`. **Không nhét ZIP vào `assets/`**; folder `incoming_assets/` sẽ được Git bỏ qua.

Kiểm tra file thật:

```bash
cd "$HOME/Projects/shadow-protocol"
find incoming_assets -maxdepth 1 -type f -print
```

Nếu đã có project v1 thì **copy các file V2 spec/prompt vào chính root project v1**, không tạo thư mục project/game mới và không xóa gameplay cũ. Nếu chưa có project, thư mục có thể chỉ gồm spec/prompt và ZIP assets.

## 5. Mở Codex và bắt đầu

1. Mở Codex trên folder `~/Projects/shadow-protocol`.
2. Đặt `SHADOW_PROTOCOL_MASTER_SPEC_V2.md` và `CODEX_START_V2_PROMPT.md` ở root.
3. Gửi cho Codex toàn bộ prompt trong `CODEX_START_V2_PROMPT.md` hoặc bảo Codex đọc file này.
4. Codex cần **đọc spec v2 trước**; sau đó scan ZIP thực tế, đọc license, xem ảnh previews, phân tích `assets.json` hoặc sprite strip rồi mới tạo `SpriteFrames`.
5. Nếu Codex đang sửa project v1, nó chỉ thay phần render/animation và tối ưu UI; **không viết lại gameplay đã ổn định**.
6. Xem báo cáo trong `IMPLEMENTATION_STATUS.md` để biết Codex thực sự chạy được bao nhiêu stage.

Nếu Codex đòi thanh toán/tự download nội dung trả phí hoặc nói đã có pack nhưng `incoming_assets` trống: yêu cầu nó **ngừng giả định**, dùng free pack hoặc art fallback và tiếp tục code.

## 6. Kiểm tra Godot thật và xem nhân vật

1. Mở Godot 4.7.2 → Import/Open project `project.godot` → chờ import xong.
2. Mở scene `scenes/dev/character_showcase.tscn` (do Codex phải tạo) và chạy **F6** để xem từng nhân vật: hướng up/down/left/right, idle/walk/attack/hurt/KO, feet pivot và scale.
3. Nhấn **F5** chạy game → New Game → hoàn thành level 1→2→3. Nhấn F3 kiểm tra AI state, vision cone, debug VFX.
4. Đi sát tường, ra/vào cửa, đổi hướng nhanh, crouch/sprint, attack, EMP. Kiểm tra sprite không biến mất, chớp frame sai, bị mờ, chân rung hoặc lọt tường.
5. Vào `docs/ART_QA_REPORT.md` và báo lỗi cho Codex nếu status vẫn FAIL/BLOCKED. Đừng chấp nhận ảnh quảng cáo pack thay cho screenshot từ game.

Lệnh test sau khi Codex tạo code:

```bash
cd "$HOME/Projects/shadow-protocol"
GODOT="/Applications/Godot.app/Contents/MacOS/Godot"
"$GODOT" --version
"$GODOT" --headless --path . --editor --import
"$GODOT" --headless --path . --script res://tests/run_tests.gd
```

Nếu tên Godot.app hoặc test runner thực tế khác, sửa theo project hiện có.

## 7. Yêu cầu cuối cùng trước khi đưa GitHub/micro1

- Player / guard / heavy / drone thống nhất phong cách, khác silhouette/màu dễ phân biệt.
- Di chuyển được 4 hướng, attack/stun đúng trạng thái, không blank frame.
- Có ít nhất 3 màn hoàn chỉnh, main menu, HUD, save/load, AI, F3 debug overlay và một character showcase riêng.
- Screenshot/video là **quay từ game thật**, không phải mockup hay ảnh giới thiệu pack.
- Repo có README English + license audit + art bible + tests + asset mapping.
- Asset đem commit có quyền công bố công khai, tuyệt đối không có kho dữ liệu art bị cấm tái phân phối.
- Nếu chưa mua bộ premium, README và báo cáo phải ghi rõ `FREE_VERIFIED` hoặc `ORIGINAL_FALLBACK`, không quảng cáo là đã dùng Riclmbr.

---

**Ghi chú:** Đây là đặc tả để Codex thực hiện. File này **không tự chứa asset ZIP và không phải game đã hoàn thành**. Sau khi game code được sinh ra, vẫn cần test runtime và xem sprites thực tế.
