# URAH NETWORK — AI AGENT ENGINEERING STANDARDS & SECURITY AUDIT TOOLKIT
### Khung Chuẩn Kỹ Thuật, Quy Trình Kiểm Thử An Ninh Mã Nguồn & Bộ Kỹ Năng AI Agent

[![Version](https://img.shields.io/badge/Version-2026.1-gold.svg)](https://github.com/URAH-Network)
[![Security Standard](https://img.shields.io/badge/Security-OWASP%20ASVS%20Level%202-blue.svg)](https://owasp.org)
[![API Security](https://img.shields.io/badge/API-OWASP%20Top%2010%20(2023)-green.svg)](https://owasp.org)
[![LLM Security](https://img.shields.io/badge/LLM-OWASP%20Top%2010%20(2025)-purple.svg)](https://owasp.org)
[![Organization](https://img.shields.io/badge/Organization-URAH--Network-red.svg)](https://github.com/URAH-Network)

---

## 🎯 1. TỔNG QUAN DỰ ÁN

Kho lưu trữ **`urah-agent-standards`** là tài sản kỹ thuật trung tâm của tổ chức **URAH Network**, được thiết kế để:
1. **Chuẩn hóa kỷ luật phát triển phần mềm (Engineering Discipline):** Quy định chặt chẽ kiến trúc hệ thống, quy chuẩn viết code (Frontend & Backend), quy trình logging theo Job, và chính sách cập nhật công nghệ mới nhất.
2. **Tự động hóa rà soát an toàn thông tin (Automated Security Audit):** Cung cấp các **Skills** chuyên sâu cho AI Coding Agent (Antigravity IDE, Cursor, Claude Code, Windsurf) nhằm tự động phát hiện và ngăn chặn 100% các lỗ hổng theo chuẩn **OWASP API Security Top 10 (2023)**, **OWASP LLM (2025)** và **ASVS v4.0.3 Level 2**.
3. **Đóng gói và chia sẻ thống nhất:** Giúp mọi kỹ sư, QA và AI Agent trong tổ chức có thể tái sử dụng ngay lập tức chỉ với 1 dòng lệnh cài đặt.

---

## 📂 2. CẤU TRÚC KHO LƯU TRỮ

```text
urah-agent-standards/
├── .agents/                                # Chuẩn Antigravity Workspace
│   ├── AGENTS.md                           # Quy tắc hợp nhất cho Agent
│   ├── rules/                              # Các quy tắc kỹ thuật mô-đun
│   └── skills/                             # Các bộ kỹ năng bảo mật
├── skills/                                 # Kỹ năng kiểm thử bảo mật
│   ├── backend-security-audit/
│   │   └── SKILL.md                        # Rà soát Backend NestJS/Node.js/Prisma
│   ├── frontend-security-audit/
│   │   └── SKILL.md                        # Rà soát Frontend Next.js/React/Tailwind
│   └── securevibes-audit/
│       └── SKILL.md                        # Kiểm thử Đa tác tử 5-Pass theo SecureVibes (Lyft)
├── rules/                                  # Bộ quy chuẩn kỹ thuật (Modular)
│   ├── architecture-patterns.md            # Mô hình kiến trúc & phân tầng React
│   ├── backend-development.md              # Chuẩn phát triển Backend (Firebase / NestJS)
│   ├── backend-job-logging.md              # Quy tắc ghi log theo phiên (Job Logging)
│   ├── frontend-development.md             # Chuẩn Frontend (Tailwind v4, Components, State)
│   ├── styleguide-conventions.md           # Quy ước đặt tên, DRY, KISS, Refactoring
│   ├── latest-version-policy.md            # Chính sách luôn áp dụng công nghệ mới nhất
│   ├── pr-quality-guardrails.md            # Tiêu chuẩn nghiệm thu Pull Request (Guardrails)
│   └── agentic-engineering-discipline.md   # Kỷ luật làm việc thực chiến của AI Agent
├── docs/                                   # Tài liệu tiêu chuẩn doanh nghiệp
│   └── QUY_CHUAN_VA_HUONG_DAN_PENTEST_DOANH_NGHIEP.md
├── scripts/                                # Công cụ cài đặt & quét mã nguồn tự động
│   ├── install-to-global.ps1 / .sh         # Cài đặt vào Global (~/.gemini/)
│   ├── install-to-project.ps1 / .sh        # Tích hợp vào thư mục .agents/ của dự án
│   └── run-security-scan.ps1 / .sh         # Chạy quét an ninh SAST Grep trực tiếp
├── GEMINI.md                               # File Global Rules chuẩn của Antigravity IDE
└── README.md                               # Tài liệu hướng dẫn sử dụng này
```

---

## 🚀 3. HƯỚNG DẪN CÀI ĐẶT & SỬ DỤNG

### Cách 1: Cài đặt vào Máy Cá Nhân (Global Config)
Áp dụng cho mọi dự án bạn mở trên máy tính (Antigravity IDE / Gemini Code Assist):

* **Trên Windows (PowerShell):**
  ```powershell
  cd c:\Work\Projects\NoiBo\urah-agent-standards
  .\scripts\install-to-global.ps1
  ```
* **Trên macOS / Linux (Bash):**
  ```bash
  ./scripts/install-to-global.sh
  ```

---

### Cách 2: Tích hợp vào một Dự án Cụ Thể (Project Workspace)
Tự động copy toàn bộ Skills và Rules vào thư mục `.agents/` của repository đích:

* **Trên Windows (PowerShell):**
  ```powershell
  .\scripts\install-to-project.ps1 -TargetProject "c:\Work\Projects\KhachHang\TenDuAn"
  ```
* **Trên macOS / Linux (Bash):**
  ```bash
  ./scripts/install-to-project.sh /path/to/your/project
  ```

---

### Cách 3: Chạy Quét An Ninh Trực Tiếp (1-Click SAST Scanner)
Bạn có thể chạy script quét tĩnh độc lập trên bất kỳ thư mục dự án nào:

* **Trên Windows:**
  ```powershell
  .\scripts\run-security-scan.ps1 -TargetDir "c:\Work\Projects\KhachHang\TenDuAn"
  ```
* **Trên macOS / Linux:**
  ```bash
  ./scripts/run-security-scan.sh /path/to/your/project
  ```

---

## 🛡️ 4. MA TRẬN TIÊU CHUẨN AN NINH & SAST SCAN MATRIX

### 4.1. Backend Security Matrix (NestJS / Node.js / Prisma)

| Tiêu Chuẩn | Tên Lỗ Hổng | Cách Nhận Diện Trong Code | Khắc Phục Bắt Buộc |
| :--- | :--- | :--- | :--- |
| **API1:2023** | **BOLA / IDOR** | Dùng `@Param('id')`, `@Query('userId')` để truy vấn dữ liệu cá nhân. | Lấy danh tính từ JWT Token: `req.user.id` / `req.user.sub`. |
| **API2:2023** | **Broken Auth** | Thiếu `@UseGuards(JwtAuthGuard)` trên endpoint nhạy cảm. | 100% endpoint mặc định là Private, bọc Guard. |
| **API3:2023** | **Mass Assignment** | Dùng `@Body() body: any` hoặc `@Body() body: { name: string }`. | Định nghĩa Class DTO độc lập với `class-validator` + `whitelist: true`. |
| **API4:2023** | **DoS / DoW** | Query `findMany` không phân trang; timeout AI không giới hạn. | Áp dụng pagination max 100; timeout AbortController 45s cho AI. |
| **API6:2023** | **SSRF** | Server gọi `fetch(url)` với URL do người dùng truyền lên. | Whitelist tên miền an toàn; chặn dải IP Private RFC1918 & Cloud Metadata. |
| **API7:2023** | **Misconfig** | CORS `origin: '*'`; lộ PII, Token, Prompt trong logs. | Khóa CORS theo whitelist domain; hàm mask/redact thông tin nhạy cảm. |
| **CWE-330** | **Weak Tokens** | Dùng `Math.random()` để sinh mã xác thực, OTP, token. | Bắt buộc dùng CSPRNG: `crypto.randomBytes` hoặc `crypto.randomInt`. |

### 4.2. Frontend Security Matrix (Next.js App Router / React)

| Tiêu Chuẩn | Tên Lỗ Hổng | Cách Nhận Diện Trong Code | Khắc Phục Bắt Buộc |
| :--- | :--- | :--- | :--- |
| **CWE-522** | **Token Leakage** | Lưu trữ JWT token trong `localStorage`. | 100% dùng HttpOnly Cookie; cơ chế tự động xóa sạch token localStorage cũ. |
| **CWE-284** | **Weak Route Guard**| Dùng `useEffect` kiểm tra quyền và redirect ở Client. | Chặn tại Server/Edge bằng Next.js `middleware.ts`. |
| **CWE-79** | **DOM XSS** | Dùng `dangerouslySetInnerHTML` với nội dung thô. | Tránh dùng; nếu bắt buộc phải lọc qua `DOMPurify.sanitize()`. |
| **CWE-200** | **Secret Leaks** | Đặt Secret Key trong biến `NEXT_PUBLIC_*`. | Loại bỏ tiền tố `NEXT_PUBLIC_`; mọi Secret I/O đi qua Backend Gateway. |
| **CWE-1022**| **Tabnabbing** | `<a target="_blank">` thiếu `rel="noopener noreferrer"`. | Bắt buộc thêm `rel="noopener noreferrer"` cho mọi link mở tab mới. |
| **CWE-601** | **Open Redirect** | `window.location.href = redirectUrl` từ URL param. | Chỉ cho phép path nội bộ (`/`) hoặc so khớp whitelist domain. |

---

## 🤖 5. KÍCH HOẠT SKILL VỚI AI CODING AGENT

Khi làm việc với các trợ lý AI Coding (Antigravity IDE, Cursor, Claude Code), bạn có thể kích hoạt trực tiếp các skill:

* **Quét toàn diện Backend:**
  > *"Hãy dùng skill `backend-security-audit` để rà soát toàn bộ các Controller và Service trong backend của dự án này."*
* **Quét an ninh Frontend:**
  > *"Hãy dùng skill `frontend-security-audit` để kiểm tra các lỗ hổng CWE-522, DOM XSS và cấu hình Middleware."*
* **Quét chuyên sâu Đa tác tử (SecureVibes 5-Pass Audit):**
  > *"Hãy dùng skill `securevibes-audit` để thực hiện 5 lượt thẩm định độc lập từ Architecture, STRIDE Threat Modeling đến đọc full context loại bỏ False-Positive và xuất file `.securevibes/scan_report.md`."*
* **Thẩm định trước khi tạo PR:**
  > *"Đối soát mã nguồn vừa sửa với tài liệu `docs/QUY_CHUAN_VA_HUONG_DAN_PENTEST_DOANH_NGHIEP.md` trước khi bàn giao."*

---

## 📜 6. BẢN QUYỀN & BẢO MẬT
Tài liệu và mã nguồn thuộc sở hữu nội bộ của **URAH Network**. Nghiêm cấm sao chép, phát tán ra ngoài tổ chức khi chưa có sự chấp thuận bằng văn bản của Ban Công Nghệ URAH Network.
