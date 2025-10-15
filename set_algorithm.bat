@echo off
setlocal
echo ===============================================
echo    CHON THUAT TOAN LOAD BALANCER NGINX
echo ===============================================
echo 1. Round Robin
echo 2. Least Connections
echo 3. IP Hash
set /p choice="Nhap lua chon (1/2/3): "

if "%choice%"=="1" (
    copy /Y nginx\nginx_roundrobin.conf nginx\nginx.conf >nul
    echo ✅ Da chon Round Robin
) else if "%choice%"=="2" (
    copy /Y nginx\nginx_leastconn.conf nginx\nginx.conf >nul
    echo ✅ Da chon Least Connections
) else if "%choice%"=="3" (
    copy /Y nginx\nginx_iphash.conf nginx\nginx.conf >nul
    echo ✅ Da chon IP Hash
) else (
    echo ❌ Lua chon khong hop le
    exit /b
)

docker-compose restart nginx
echo 🚀 Da restart NGINX voi thuat toan moi!
pause
