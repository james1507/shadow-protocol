# HƯỚNG DẪN TẢI ASSETS VÀ CHUẨN BỊ GODOT — SHADOW PROTOCOL

> Dành cho người sử dụng Codex trên **Mac M1, 16 GB RAM**. Hướng dẫn này đi kèm file `SHADOW_PROTOCOL_MASTER_SPEC.md`.
>
> **Lưu ý:** Các đường dẫn bên dưới là trang chính thức để tải. Không có file ZIP trực tiếp trong bộ tài liệu này. Không có game hay asset bản quyền được đóng gói sẵn. Sau khi tải assets, Codex sẽ dựa trên file thực tế để quyết định dùng những hình nào.

## 1. Cài Godot chuẩn (không cần .NET)

1. Vào trang chính thức: https://godotengine.org/download/archive/4.7.2-stable/
2. Tìm mục **macOS** → chọn **Standard — Universal**. Bản này tương thích Apple Silicon (M1). Không chọn bản `.NET` vì dự án dùng GDScript.
3. Tải, giải nén, kéo `Godot.app` vào thư mục `Applications` nếu muốn.
4. Khởi động Godot lần đầu và kiểm tra bản ghi **4.7.2 stable** trong giao diện. Nếu macOS cảnh báo vì ứng dụng tải từ Internet, chỉ cho phép chạy nếu bạn xác nhận đúng phần mềm từ trang chính thức; không tắt bảo mật macOS toàn hệ thống.
5. Nếu đặt đúng tên và vị trí `/Applications/Godot.app`, kiểm tra bằng Terminal:

```bash
/Applications/Godot.app/Contents/MacOS/Godot --version
```

Nếu không tìm thấy đường dẫn trên, dùng Finder để xác định tên và vị trí `.app` thực tế (ví dụ `Godot_4.7.2.app`) rồi thay vào lệnh.

## 2. Danh sách assets cần tải

### Nên tải trước (3 bộ ảnh chính)

| Gói | Link chính thức | Mục đích |
|---|---|---|
| **Kenney Top-down Shooter** | https://kenney.nl/assets/top-down-shooter | Ưu tiên nhân vật, vật thể top-down và tile/furniture phù hợp |
| **Kenney UI Pack — Sci-Fi** | https://kenney.nl/assets/ui-pack-sci-fi | Menu, nút bấm, khung HUD và panel sci-fi |
| **Kenney Sci-Fi RTS** | https://kenney.nl/assets/sci-fi-rts | Tìm vật thể máy móc/kiến trúc sci-fi, *chỉ sử dụng nếu cùng phối cảnh* |

### Nên tải tiếp (3 bộ âm thanh)

| Gói | Link | Mục đích |
|---|---|---|
| **Kenney Sci-Fi Sounds** | https://kenney.nl/assets/sci-fi-sounds | Máy móc, terminal, âm thanh khoa học viễn tưởng |
| **Kenney Interface Sounds** | https://kenney.nl/assets/interface-sounds | Click, xác nhận và menu |
| **Kenney Impact Sounds** | https://kenney.nl/assets/impact-sounds | Va chạm và combat |

### Có thể tải sau

- Kenney Game Icons: https://kenney.nl/assets/game-icons — icon HUD, pickup hoặc biểu tượng điều khiển.
- Kenney Music Jingles: https://kenney.nl/assets/music-jingles — nhạc ngắn ở menu / kết quả, không nhất thiết là nhạc nền vòng lặp.

**Bản quyền:** Các trang Kenney nêu trên hiện công bố giấy phép **Creative Commons CC0**. Hãy kiểm tra lại giấy phép đi kèm file tải về, giữ thông tin nguồn gốc trong project và tránh lấy assets từ mirror không rõ nguồn. Không dùng asset trên itch.io hoặc Google Images nếu chưa xác minh quyền đưa file lên GitHub công khai.

## 3. Cách tải MỖI bộ trên website Kenney

Ví dụ với **Top-down Shooter**:

1. Mở trang https://kenney.nl/assets/top-down-shooter.
2. Xác nhận tên pack và dòng **License — Creative Commons CC0**.
3. Nhấn **Download** trên trang.
4. Nếu website hiện bảng ủng hộ tác giả, có thể chọn **Continue without donating...**. Tránh chọn nhầm `Get All-in-1 bundle` (gói tổng hợp, không cần cho dự án).
5. Chờ trình duyệt lưu file ZIP, thường trong `Downloads`. **Tên file tải xuống có thể khác tên pack**, vì vậy không nên dự đoán tên ZIP.
6. Lặp lại với 5 pack còn lại.

Nếu nút download thay đổi, trình duyệt yêu cầu thao tác hoặc website chặn tự động: tải thủ công, không yêu cầu Codex bypass.

## 4. Tạo thư mục dự án và chép ZIP

Tạo thư mục bằng Terminal:

```bash
mkdir -p "$HOME/Projects/shadow-protocol/incoming_assets"
open "$HOME/Projects/shadow-protocol/incoming_assets"
open "$HOME/Downloads"
```

Một cửa sổ `incoming_assets` và một cửa sổ `Downloads` sẽ mở ra. Kéo các **file ZIP vừa tải** từ Downloads sang `incoming_assets`.

Kiểm tra:

```bash
cd "$HOME/Projects/shadow-protocol"
find incoming_assets -maxdepth 1 -type f -iname '*.zip' -print
```

Mong muốn nhìn thấy khoảng 3–8 file ZIP, tùy số pack đã tải. Không cần tự đổi tên hoặc sắp xếp bên trong archive. **Không cần giải nén trước** nếu bạn muốn Codex chạy script inventory để xử lý và xác minh giấy phép.

Nếu bạn đã giải nén trước, hãy để đúng cấu trúc `incoming_assets/extracted/<ten-pack>/` và không sửa nội dung gốc.

## 5. Đưa spec và prompt vào thư mục project

Giải nén bộ tài liệu `SHADOW_PROTOCOL_CODEX_PACKAGE.zip` vào thư mục gốc dự án. Kết quả nên là:

```text
~/Projects/shadow-protocol/
├── SHADOW_PROTOCOL_MASTER_SPEC.md
├── ASSET_SETUP_GUIDE_VI.md
├── CODEX_START_PROMPT.md
├── CODEX_RESUME_PROMPT.md
├── README_START_HERE.md
└── incoming_assets/
    ├── <actual-kenney-download-1>.zip
    ├── <actual-kenney-download-2>.zip
    └── ...
```

Các file trong tài liệu chỉ là **đầu vào cho Codex**. `project.godot` và các scene/scripts sẽ do Codex tạo sau khi đọc prompt và spec. Không cần tạo project rỗng trong Godot trước.

## 6. Ra lệnh cho Codex bắt đầu

1. Mở **Codex** ở chế độ làm việc trên thư mục `~/Projects/shadow-protocol`.
2. Đảm bảo Codex có quyền đọc/ghi file trong thư mục và có thể gọi terminal ở môi trường bạn cho phép.
3. Mở nội dung `CODEX_START_PROMPT.md`, copy toàn bộ và gửi cho Codex; hoặc yêu cầu Codex **đọc chính file prompt đó** (khi nó đã nằm trong workspace).
4. Codex phải đọc toàn bộ `SHADOW_PROTOCOL_MASTER_SPEC.md` và các ZIP assets thực tế trước khi code.
5. Hãy yêu cầu Codex chạy **từng Stage 0–11**, lưu trạng thái sau mỗi Stage. Nếu Codex hỏi về tên file khác với thực tế, yêu cầu nó **tự kiểm tra bằng `find`, `unzip -l`, `file`** thay vì đoán.
6. Codex cần tạo file `IMPLEMENTATION_STATUS.md` ghi rõ stage nào thực sự chạy và test nào thực sự pass.

**Không thể đảm bảo một lần prompt duy nhất sẽ hoàn thành trọn game.** Một nhiệm vụ lớn như vậy thường cần tiếp tục theo stage, sửa lỗi và thực tế chơi thử. File `CODEX_RESUME_PROMPT.md` dùng để yêu cầu Codex kiểm tra trạng thái đã có và tiếp tục, không làm lại từ đầu.

## 7. Sau khi Codex tạo game: import vào Godot

1. Mở Godot.
2. Ở Project Manager, nhấn **Import** (nếu có) hoặc chọn mở project, trỏ tới `~/Projects/shadow-protocol/project.godot`.
3. Chờ editor quét và import assets vào hệ thống cache.
4. Ở màn hình editor, nhấn **F5** để chạy game (nếu macOS ưu tiên phím chức năng cho tính năng khác, dùng phím **Play** trong toolbar).
5. Kiểm tra Main Menu → New Game → Level 1; thử WASD, Shift, Ctrl, E, Q, click trái, Esc.
6. Nhấn F3 trong bản debug để xem AI overlay. Thử chạy quanh tường và quan sát guard có còn nhìn xuyên tường không.
7. Chạy lại từ menu, thua, checkpoint, Continue, hoàn thành Level 1→2→3.
8. Nếu phát hiện lỗi, copy log và mô tả **exact scene + hành động + kết quả kỳ vọng + kết quả thực tế** cho Codex sửa.

Kiểm tra tự động bằng Terminal, chạy từ thư mục có `project.godot`:

```bash
cd "$HOME/Projects/shadow-protocol"
/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --editor --import
/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script res://tests/run_tests.gd
```

Các lệnh trên chỉ hoạt động **sau khi Codex đã tạo** `project.godot` và test runner. Nếu đường dẫn Godot khác, hãy thay đường dẫn executable tương ứng.

## 8. Khi thiếu pack, game vẫn phải chạy

Theo Master Spec, Codex không được dừng vì thiếu ZIP. Nếu bạn tải chưa đủ:
- Player/guard/drone sử dụng art nguyên bản bằng các hình đa giác được vẽ trong Godot.
- Map dùng tiles/màu giả lập đủ rõ ràng.
- Menu dùng Control và StyleBoxFlat.
- Audio vắng mặt được xử lý an toàn, không crash.
- Sau này có thể tích hợp lại Kenney assets thông qua file mapping và inventory.

Đây là **fallback kỹ thuật**, không phải lý do bỏ qua bước nâng cấp visual khi assets đã có.

## 9. Những thứ tối thiểu phải có trước khi đưa GitHub cho nhà tuyển dụng

- Chơi thật được từ menu tới kết thúc ít nhất 3 màn, không cần Codex đang chạy.
- README tiếng Anh có hướng dẫn setup; không quảng cáo chức năng chưa hoàn thành.
- Một video gameplay **quay từ game thực tế**, hoặc ít nhất 3 screenshot thực tế (menu, level, F3 debug).
- Có `docs/ARCHITECTURE.md`, `docs/DEBUGGING_CASE_STUDIES.md`, `docs/PERFORMANCE.md` và source asset credits.
- Unit/integration tests chạy được, các lỗi chính được khắc phục.
- Không có asset bản quyền thiếu giấy phép; không commit file ZIP tải về nếu không cần thiết.
- Nếu Codex hỗ trợ code thì bạn nên tự chạy, hiểu, chỉnh sửa và có thể giải thích các phần FSM, line-of-sight, physics, navigation, save/load, test suite khi phỏng vấn. Không nhận đó là kinh nghiệm Godot chuyên nghiệp nếu mới làm một project cá nhân.

## 10. Khắc phục các lỗi thường gặp

**Game hiện ô trống hoặc sprite bị thiếu:** Kiểm tra mapping có đúng tên file trong ZIP và file đã được import không. Nếu không, dùng fallback; đừng để tham chiếu `res://` bị hỏng.

**Sprites bị mờ:** Tìm `CanvasItem` texture filter / default texture filter trong project settings, chọn **Nearest**, và tránh scale phân số đối với pixel art.

**Enemy đi xuyên tường / cửa:** Kiểm tra Collision Layer/Mask, NavigationRegion, điểm đến, trạng thái door blocking, rồi thử `test_arena.tscn`.

**Tests thất bại sau khi tải assets:** Xem đường dẫn thực tế, rescan import, lỗi parser và log trong `IMPLEMENTATION_STATUS.md`, không đơn thuần tắt test.

**Không có audio:** Không nên crash. Nếu không có pack, chấp nhận chế độ im lặng và tiếp tục triển khai gameplay.

**Godot không chạy bằng command line:** Đảm bảo đường dẫn `.app/Contents/MacOS/Godot` khớp vị trí thực tế. Có thể chạy trong editor bằng nút Play trước.

---

### Nguồn chính thức

- Godot 4.7.2: https://godotengine.org/download/archive/4.7.2-stable/
- Godot CLI: https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html
- Các Kenney pack: xem danh sách trong mục 2 và Master Spec, tất cả đều có URL nguồn.
