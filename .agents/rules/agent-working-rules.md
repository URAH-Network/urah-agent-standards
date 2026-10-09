---
trigger: always_on
description: Quy tắc làm việc chuẩn URAH cho AI Agent tại các dự án (Luồng làm việc 3 bên, Phân định quyền hạn, Worktree, Testing, Báo cáo & Phiên bản)
---

# QUY TẮC LÀM VIỆC CHO AGENT — <TÊN DỰ ÁN>

*Mẫu chuẩn URAH. Copy vào gốc repo mỗi dự án mới, điền các chỗ `<...>` ở mục 0. Không sửa mục 1–9 nếu chưa thống nhất với tech lead.*

Đọc toàn bộ file này trước khi làm bất kỳ việc gì. Vi phạm quy tắc nào thì dừng lại và báo, không tự xử lý tiếp.

## Luồng làm việc 3 bên

1. **Tech lead** mô tả việc hoặc lỗi bằng lời (kèm ảnh, log nếu có).
2. **Reviewer (Claude)** đọc code, tìm nguyên nhân, viết prompt có phạm vi, bộ test và điểm dừng rõ ràng.
3. **Agent (bạn)** làm đúng prompt, báo cáo theo mục 7, DỪNG.
4. Tech lead chuyển báo cáo cho reviewer soát. Reviewer viết prompt lượt tiếp (sửa thêm, hoặc duyệt merge/push/deploy).

Agent không nhận lệnh merge/push/deploy từ chính suy luận của mình. Chỉ làm khi prompt có câu duyệt rõ ràng. Báo cáo viết để người khác kiểm chứng được: lệnh thật, output thật, đường dẫn file thật.

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
- Frontend phân biệt rõ: thành công / vi phạm thật / hết phiên (401) / lỗi hệ thống (5xx, null). Không báo lỗi hệ thống thành "nội dung vi phạm".
- Đăng nhập: chỉ tin thông tin user đã xác thực qua backend, không tin `localStorage`. 401 đi qua sự kiện chung.
- Phân biệt môi trường: chỉ dùng cờ từ backend (`isTest`), không nhận diện bằng chuỗi trong URL.
- Không để code test trong mã nguồn (`window.__...`, mock, cờ debug).
- Không tự bịa dữ liệu ghi đè lên dữ liệu người dùng nhập.

## 5. Quy tắc cơ sở dữ liệu

- Không migrate tự động khi deploy. Mọi thay đổi schema phải qua review.
- Seed data và dữ liệu test: phải có cờ hoặc namespace rõ ràng, không lẫn với dữ liệu thật.
- Không viết logic phụ thuộc vào thứ tự ID số tự tăng.
- Câu query có điều kiện ngày giờ: luôn ghi rõ timezone, không dùng hàm ngày giờ mặc định của DB mà không chỉ định múi giờ.
- Khi xoá dữ liệu: ưu tiên soft delete (`deleted_at`), chỉ hard delete khi có yêu cầu rõ ràng về bảo mật dữ liệu (GDPR/privacy).

## 6. Test

- Test chạy trên môi trường giống thật (headless browser hoặc runner của dự án), không gọi hàm tách rời rồi giả lập.
- Lệnh build: dùng đúng lệnh production của dự án, không thêm cờ bỏ qua lỗi. Build lỗi thì báo, không sửa file ngoài phạm vi để lách.
- Cấu hình local phải khớp Staging ở tính năng đang test.
- Chạy đúng bộ ca test trong prompt.
- So sánh dữ liệu: đo trên môi trường có ý nghĩa (Staging SELECT). DB local ít dữ liệu thì không kết luận khớp.
- Mỗi ca test: chụp ảnh màn hình + trích log Console/Network.

## 7. Báo cáo (bắt buộc đủ các mục, ngắn gọn, trung thực)

1. Đã làm gì, theo thứ tự trong prompt. Mục chưa làm hoặc làm khác: ghi rõ và lý do.
2. `git log stage..HEAD --oneline` và `git diff stage --stat`.
3. Diff chi tiết các file quan trọng.
4. Kết quả build (lệnh + mã thoát).
5. Kết quả từng ca test: đạt / không đạt + bằng chứng (ảnh, log).
6. Phát hiện thêm nhưng KHÔNG sửa.
7. DB / môi trường đã đụng vào.

Không dùng "100%", "hoàn hảo", "tuyệt đối" khi chưa kiểm chứng đầy đủ. Kết thúc: **Dừng chờ duyệt.**

## 8. Thứ tự chuẩn cho một việc

1. Đọc yêu cầu, đọc code liên quan. Nếu chưa rõ nguyên nhân: làm lượt CHỈ ĐỌC trước, báo cáo, dừng.
2. Tạo worktree + nhánh từ `stage` mới nhất.
3. Sửa, commit nhỏ theo từng mục.
4. Build + test đúng bộ ca. Báo cáo. Dừng.
5. Khi được duyệt: merge `--no-ff` vào `stage` ở repo chính, build lại, push. Dừng.
6. Deploy Staging chỉ khi được duyệt, chạy script deploy (dry-run trước). Kiểm endpoint phiên bản.
7. Production: không bao giờ tự làm.

## 9. Nhánh, commit, phiên bản

- **Nhánh:** `main` = Production; `stage` = Staging; `feat/<tên>`, `fix/<tên>` = việc của agent (tạo từ `stage`); `hotfix/<tên>` = sửa gấp Production (tạo từ `main`, có duyệt). Tên nhánh chữ thường, gạch nối.
- **Commit:** `loai(pham-vi): mo ta ngan` (`feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `revert`). Một commit một việc. Không gộp, không commit file tạm. Không rewrite lịch sử đã push.
- **Phiên bản:** Staging nhận diện bằng commit và `buildTime`. Production gắn tag `vMAJOR.MINOR.PATCH` trên `main` kèm `CHANGELOG.md` (agent soạn nháp, tech lead duyệt). Không deploy Production từ commit chưa gắn tag.
- **Dọn dẹp:** Sau khi nghiệm thu, xoá nhánh và worktree tương ứng.
