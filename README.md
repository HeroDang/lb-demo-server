# 🔁 Load Balancer Demo (NGINX + Flask + Docker)

Demo hệ thống **Load Balancer** mô phỏng cơ chế phân phối tải trong môi trường *Mobile & Pervasive Computing*.

## 🧠 Tổng quan
Ứng dụng gồm:
- **2 Flask API servers** (`api1`, `api2`)
- **1 NGINX Load Balancer** (`nginx-lb`)
- Tất cả chạy qua **Docker Compose**

Mục tiêu:
- Minh họa các thuật toán Load Balancing: `round_robin`, `least_conn`, `ip_hash`
- Thể hiện khả năng phân tải, chịu tải cao và tự phục hồi khi một server ngưng hoạt động
- Dùng để test qua Postman, JMeter hoặc ứng dụng Android client

---

## ⚙️ Cấu trúc thư mục
```
loadbalancer-demo/
├── app/
│   ├── app.py           # Flask backend
│   ├── Dockerfile       # Image Flask
├── nginx/
│   ├── nginx.conf       # Config NGINX load balancer
├── docker-compose.yml   # Compose file
```
---

## 🚀 Cách chạy project

### 1️⃣ Cài đặt Docker
Tải và cài **Docker Desktop** tại https://www.docker.com/

### 2️⃣ Khởi động các container
docker-compose up -d --build

### 3️⃣ Kiểm tra
```
curl http://localhost:5000/api/hello   # Flask 1
curl http://localhost:5001/api/hello   # Flask 2
curl http://localhost:8080/api/hello   # NGINX Load Balancer
```
Kết quả trả về JSON:
{"message": "Hello from Flask!", "server": "api1"}

---

## 🧩 Cấu hình thuật toán Load Balancing

Trong file nginx/nginx.conf:

upstream backend {
    # round robin (default)
    # server api1:5000;
    # server api2:5000;

    # least connections
    least_conn;
    server api1:5000 max_fails=3 fail_timeout=10s;
    server api2:5000 max_fails=3 fail_timeout=10s;

    # ip hash
    # ip_hash;
    # server api1:5000;
    # server api2:5000;
}

Sau khi chỉnh, restart NGINX:
docker-compose restart nginx

---

## ❤️ Health Check (Tự động bỏ server lỗi)

NGINX sẽ tự loại bỏ backend nếu `/health` trả lỗi.

server api1:5000 max_fails=3 fail_timeout=10s;
server api2:5000 max_fails=3 fail_timeout=10s;

Test thử:
docker stop api1
curl http://localhost:8080/api/hello
→ Tất cả request sẽ tự động chuyển sang `api2`.

---

## 🧪 Test bằng JMeter

1. Mở JMeter GUI  
2. Thread Group → 10 users × 5 loops  
3. HTTP Request → http://localhost:8080/api/hello  
4. Thêm listener “View Results Tree”  
5. Chạy → Quan sát server thay đổi luân phiên (`api1`, `api2`)

---

## 📱 Kết nối Mobile App
Ứng dụng Android gọi API:
http://10.0.2.2:8080/api/hello
http://10.0.2.2:8080/api/slow
để hiển thị server backend đang xử lý.

---

## 🧰 Lệnh hữu ích

| Mục đích | Lệnh |
|----------|------|
| Dừng container | docker-compose down |
| Restart Flask | docker-compose restart api1 api2 |
| Restart NGINX | docker-compose restart nginx |
| Xem log | docker logs nginx-lb -f |
| Build lại sạch | docker-compose build --no-cache |

---

## 🧩 Liên hệ với Mobile & Pervasive Computing
- Load Balancer giúp hệ thống **đáp ứng nhiều người dùng di động đồng thời**
- Tăng **availability** và **QoS (Quality of Service)** cho ứng dụng pervasive
- Là tầng “middleware” phổ biến trong **mobile cloud systems**

---

**Author:** Nhóm SE405  
**Course:** Mobile & Pervasive Computing  
**Date:** October 2025
