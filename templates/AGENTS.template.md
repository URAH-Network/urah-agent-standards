# QUY TẮC LÀM VIỆC CHO AGENT — <TÊN DỰ ÁN>

*Mẫu chuẩn URAH. Copy vào gốc repo mỗi dự án mới, điền các chỗ `<...>` ở mục 0. Không sửa mục 1–9 nếu chưa thống nhất với tech lead.*

Đọc toàn bộ file này trước khi làm bất kỳ việc gì. Vi phạm quy tắc nào thì dừng lại và báo, không tự xử lý tiếp.

## 0. Thông tin dự án (điền khi khởi tạo)

| Mục | Giá trị |
|---|---|
| Người duyệt (tech lead) | `<tên>` |
| Repo | `<url>` |
| Thư mục repo chính | `<đường dẫn>` |
| Mẫu đường dẫn worktree | `<đường dẫn>_worktree_<tên việc>` |
| Môi trường | Local / Staging `<url>` / Production `<url>` |
| Lệnh build | backend `<lệnh>`, frontend `<lệnh>` |
| Script deploy Staging | `<tên script>` (có `--dry-run`) |
| Endpoint kiểm phiên bản | `<url>/api/health` trả `commit`, `buildTime` |
| Thư viện chuẩn đã chọn | toast `<...>`, form `<...>`, HTTP client `<...>` |
| Danh sách mã/tài khoản test theo môi trường | `<file>` (không dùng chéo môi trường) |

## 1. Quyền hạn

| Việc | Được làm? |
|---|---|
| Đọc code, build, test trên local | Được |
| Ghi DB local (dữ liệu test) | Được, ghi lại đã sửa gì |
| Commit trên nhánh của mình, trong worktree của mình | Được |
| SELECT trên DB Staging | Chỉ khi prompt cho phép |
| Ghi DB Staging, mọi thao tác trên Production | KHÔNG |
| Merge, push, deploy | KHÔNG, trừ khi prompt ghi rõ "duyệt merge/push/deploy" |
| Script có `--apply` (backfill, cleanup, migrate) | KHÔNG, chỉ dry-run. Ngoại lệ: script deploy Staging khi được duyệt |
| Sửa `.env`, secret, cấu hình server | KHÔNG |

## 2. Nơi làm việc

- Mỗi việc một worktree riêng, tạo từ `stage` mới nhất. Một worktree chỉ một agent.
- Repo chính chỉ dùng để merge và deploy. Trước khi đụng: `git status` phải sạch, không thì dừng và báo. Không stash, reset, checkout đè file người khác.
- Không xoá file bằng wildcard. File test tạm để ngoài repo. Không commit file tạm, ảnh test, `.env`, file sinh tự động.

## 3. Phạm vi

- Chỉ sửa đúng việc được giao. Thấy lỗi khác: ghi vào báo cáo, không tự sửa.
- Không tự thêm tính năng, giao diện, thư viện, giá trị mặc định, cấu hình.
- Gặp lựa chọn nghiệp vụ: dừng, trình bày phương án, chờ chọn. Không tự chọn.
- Không đổi cách merge/rebase/cấu trúc nhánh khác với prompt.
- Việc chưa rõ nguyên nhân: làm một lượt CHỈ ĐỌC trước, báo cáo, dừng.

## 4. Quy tắc code chung

- Không nuốt lỗi (`catch` rồi `return null`). API trả đúng mã HTTP.
- Frontend phân biệt: thành công / lỗi nghiệp vụ có lý do từ backend / hết phiên (401) / lỗi hệ thống (429, 5xx, mạng). Không hiển thị lỗi hệ thống thành lỗi của người dùng.
- Xác thực: tin phiên đã được server xác nhận, không tin `localStorage`. Hạn cookie khớp hạn token. 401 xử lý ở một chỗ chung: báo hết phiên, lưu nháp, về trang đăng nhập có `redirect`.
- Tài nguyên không tồn tại (mã, link, bản ghi): hiện màn báo lỗi, không hiện form.
- Nhận diện dữ liệu test bằng cờ từ backend, không bằng chuỗi trong URL.
- Không để code test, mock, cờ debug trong mã nguồn.
- Không ghi đè dữ liệu người dùng nhập bằng giá trị tự bịa.

## 5. Test

- Trình duyệt thật (Puppeteer/Playwright) trên bản build thật, không giả lập bằng gọi hàm.
- Build đúng lệnh production. Build lỗi thì báo, không sửa ngoài phạm vi để build qua.
- Cấu hình local giống Staging ở phần đang test, ghi rõ đã bật gì.
- Chạy đúng bộ ca trong prompt. Mỗi ca có ảnh chụp và log Console/Network.
- Không kết luận số liệu trên dữ liệu không có ý nghĩa (DB local vài bản ghi).

## 6. Báo cáo bắt buộc

1. Đã làm gì theo đúng thứ tự mục trong prompt; mục chưa làm hoặc làm khác thì ghi lý do.
2. `git log stage..HEAD --oneline`, `git diff stage --stat`.
3. Diff các file quan trọng.
4. Lệnh build + exit code.
5. Kết quả từng ca test + bằng chứng.
6. Phát hiện thêm nhưng không sửa.
7. Đã đụng môi trường/DB nào.

Không dùng "100%", "hoàn hảo", "tuyệt đối" khi không có bằng chứng. Kết thúc bằng: dừng chờ duyệt.

## 7. Thứ tự chuẩn một việc

1. Đọc yêu cầu và code. Chưa chắc nguyên nhân: lượt chỉ đọc.
2. Worktree + nhánh từ `stage` mới nhất.
3. Sửa, commit nhỏ theo mục.
4. Build + test. Báo cáo. DỪNG.
5. Được duyệt: merge `--no-ff` vào `stage` ở repo chính, build lại, push. DỪNG.
6. Được duyệt: deploy Staging bằng script (dry-run trước), kiểm endpoint phiên bản đúng commit.
7. Production: chỉ theo quy trình phát hành ở mục 8, không bao giờ tự làm.

## 8. Nhánh, commit, phiên bản

| Nhánh | Vai trò |
|---|---|
| `main` | Đúng bằng Production. Chỉ nhận merge từ `stage` khi phát hành, hoặc `hotfix/*` |
| `stage` | Đúng bằng Staging. Nhận merge `--no-ff` từ nhánh việc |
| `feat/<tên>`, `fix/<tên>` | Một việc một nhánh, từ `stage` |
| `hotfix/<tên>` | Từ `main`; xong merge vào `main` và merge ngược về `stage` |
| tag `backup/<nhánh>-YYYYMMDD` | Tạo trước mọi lần gộp nhiều nhánh |
| tag `vMAJOR.MINOR.PATCH` | Gắn trên `main` mỗi lần phát hành Production |

- Commit: `loai(pham-vi): mo ta` (`feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `revert`), kèm mã ticket/TC nếu có. Một commit một thay đổi logic. Không `push --force`, không rebase nhánh đã push.
- Deploy chỉ từ nhánh đã push, working tree sạch, đóng gói bằng `git archive` (không đóng gói thư mục đang làm). Sinh `VERSION` và endpoint phiên bản trả `commit`, `buildTime`.
- Mỗi lần phát hành Production: tag phiên bản + `CHANGELOG.md` (phiên bản, ngày, thay đổi kèm mã TC). Không deploy Production từ commit chưa có tag. Có backup DB và điểm rollback trước khi deploy.

## 9. Dọn dẹp

- Sau nghiệm thu: xoá nhánh đã merge (local + remote) và worktree. Giữ tag `backup/*` đến lần phát hành kế tiếp.
- Rủi ro, quyết định nghiệp vụ, bài học: ghi vào `<file nhật ký dự án>`, không để trong comment code.
