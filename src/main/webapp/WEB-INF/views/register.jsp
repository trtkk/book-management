<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>用户注册</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
  <link href="/static/css/background.css" rel="stylesheet">
  <style>
    .register-container {
      height: 100vh;
    }
    .register-card {
      background: rgba(255, 255, 255, 0.92);
      backdrop-filter: blur(10px);
      border-radius: 15px;
      box-shadow: 0 10px 30px rgba(0,0,0,0.2);
      border: 1px solid rgba(255, 255, 255, 0.3);
    }
  </style>
</head>
<body class="register-background">
<div class="register-container d-flex align-items-center">
  <div class="container">
    <div class="row justify-content-center">
      <div class="col-md-5">
        <div class="register-card p-4">
          <div class="text-center mb-4">
            <i class="fas fa-user-plus fa-3x text-primary mb-3"></i>
            <h3>用户注册</h3>
            <p class="text-muted">创建您的账户</p>
          </div>

          <form action="/register" method="post" id="registerForm">
            <div class="mb-3">
              <label class="form-label">用户名 *</label>
              <input type="text" class="form-control" name="username" required>
            </div>

            <div class="mb-3">
              <label class="form-label">密码 *</label>
              <input type="password" class="form-control" name="password" required>
            </div>

            <div class="mb-3">
              <label class="form-label">真实姓名</label>
              <input type="text" class="form-control" name="realName">
            </div>

            <button type="submit" class="btn btn-primary w-100 mb-3">
              <i class="fas fa-user-plus me-2"></i>注册
            </button>

            <div class="text-center">
              <a href="/login" class="text-decoration-none">已有账户？立即登录</a>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- 成功弹窗 -->
<div class="modal fade" id="successModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header bg-success text-white">
        <h5 class="modal-title"><i class="fas fa-check-circle me-2"></i>注册成功</h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <p>注册成功，请登录您的账户</p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-bs-dismiss="modal" onclick="redirectToLogin()">前往登录</button>
      </div>
    </div>
  </div>
</div>

<!-- 错误弹窗 -->
<div class="modal fade" id="errorModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header bg-danger text-white">
        <h5 class="modal-title"><i class="fas fa-exclamation-circle me-2"></i>注册失败</h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <p>用户名已存在，请选择其他用户名</p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-danger" data-bs-dismiss="modal">确定</button>
      </div>
    </div>
  </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
  // 页面加载时检查是否有错误或成功消息
  $(document).ready(function() {
    <c:if test="${not empty error}">
    // 显示错误弹窗
    var errorModal = new bootstrap.Modal(document.getElementById('errorModal'));
    errorModal.show();
    </c:if>

    <c:if test="${not empty message}">
    // 显示成功弹窗
    var successModal = new bootstrap.Modal(document.getElementById('successModal'));
    successModal.show();
    </c:if>
  });

  // 跳转到登录页面
  function redirectToLogin() {
    window.location.href = '/login';
  }
</script>
</body>
</html>