from flask import Flask, jsonify
import socket
import time
import random

app = Flask(__name__)

@app.route('/api/hello')
def hello():
    return jsonify({
        "message": "Hello from Flask!",
        "server": socket.gethostname()
    })

@app.route('/api/slow')
def slow():
    time.sleep(3)
    return jsonify({
        "server": socket.gethostname(),
        "type": "slow response"
    })

@app.route('/api/health')
def health():
    # Giả lập trạng thái động
    # 80% OK, 20% DOWN (để test load balancer hoặc app)
    status = random.choices(["healthy", "unhealthy"], weights=[80, 20])[0]
    if status == "healthy":
        return jsonify({
            "status": "OK",
            "server": socket.gethostname()
        }), 200
    else:
        return jsonify({
            "status": "FAIL",
            "server": socket.gethostname()
        }), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
