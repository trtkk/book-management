<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>图书管理系统 - 登录</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="/static/css/background.css" rel="stylesheet">
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            height: 100vh;
            overflow: hidden;
        }

        .login-container {
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
        }

        .background-image {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            opacity: 0.15;
            z-index: 1;
        }

        .login-card {
            background: rgba(255, 255, 255, 0.92);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
            padding: 40px;
            width: 100%;
            max-width: 400px;
            border: 1px solid rgba(255, 255, 255, 0.3);
            position: relative;
            z-index: 2;
            animation: slideUp 0.8s ease-out;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .login-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .login-icon {
            font-size: 3rem;
            color: #4e73df;
            margin-bottom: 15px;
            display: block;
        }

        .login-title {
            color: #2e59d9;
            font-weight: 700;
            font-size: 1.8rem;
            margin-bottom: 5px;
        }

        .login-subtitle {
            color: #6c757d;
            font-size: 0.9rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 0.5rem;
        }

        .input-group {
            position: relative;
        }

        .input-group-text {
            background: #f8f9fc;
            border: 1px solid #d1d3e2;
            border-right: none;
        }

        .form-control {
            border: 1px solid #d1d3e2;
            border-left: none;
            padding: 0.75rem 1rem;
            transition: all 0.3s;
        }

        .form-control:focus {
            box-shadow: 0 0 0 0.2rem rgba(78, 115, 223, 0.25);
            border-color: #4e73df;
        }

        .input-group:focus-within .input-group-text {
            border-color: #4e73df;
            background: #4e73df;
            color: white;
        }

        .btn-login {
            background: linear-gradient(135deg, #4e73df 0%, #224abe 100%);
            border: none;
            padding: 12px;
            font-weight: 600;
            font-size: 1rem;
            border-radius: 10px;
            transition: all 0.3s;
            box-shadow: 0 4px 15px rgba(78, 115, 223, 0.3);
        }

        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(78, 115, 223, 0.4);
        }

        .test-accounts {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 15px;
            margin-top: 20px;
            border-left: 4px solid #4e73df;
        }

        .test-accounts h6 {
            color: #2e59d9;
            margin-bottom: 10px;
        }

        .test-accounts p {
            margin: 5px 0;
            font-size: 0.85rem;
            color: #6c757d;
        }

        .alert {
            border-radius: 10px;
            border: none;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        /* 响应式设计 */
        @media (max-width: 576px) {
            .login-card {
                margin: 20px;
                padding: 30px 25px;
            }

            .login-container {
                padding: 10px;
            }
        }

        /* 浮动动画 */
        .floating {
            animation: floating 3s ease-in-out infinite;
        }

        @keyframes floating {
            0% { transform: translateY(0px); }
            50% { transform: translateY(-10px); }
            100% { transform: translateY(0px); }
        }
    </style>
</head>
<body class="login-background">
<!-- 登录容器 -->
<div class="login-container">
    <div class="login-card">
        <!-- 登录头部 -->
        <div class="login-header">
            <i class="fas fa-book login-icon floating"></i>
            <h1 class="login-title">图书管理系统</h1>
            <p class="login-subtitle">欢迎回来，请登录您的账户</p>
        </div>

        <!-- 登录表单 -->
        <form action="/login" method="post">
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- 用户名输入 -->
            <div class="form-group">
                <label class="form-label">用户名</label>
                <div class="input-group">
                        <span class="input-group-text">
                            <i class="fas fa-user"></i>
                        </span>
                    <input type="text" class="form-control" name="username"
                           placeholder="请输入用户名" required
                           value="${param.username}">
                </div>
            </div>

            <!-- 密码输入 -->
            <div class="form-group">
                <label class="form-label">密码</label>
                <div class="input-group">
                        <span class="input-group-text">
                            <i class="fas fa-lock"></i>
                        </span>
                    <input type="password" class="form-control" name="password"
                           placeholder="请输入密码" required>
                </div>
            </div>

            <!-- 登录按钮 -->
            <button type="submit" class="btn btn-primary btn-login w-100 mb-3">
                <i class="fas fa-sign-in-alt me-2"></i>登录系统
            </button>
        </form>

        <!-- 测试账户信息 -->
        <div class="text-center mt-3">
            <a href="/register" class="text-decoration-none">没有账户？立即注册</a>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // 输入框聚焦效果
    $(document).ready(function() {
        $('.form-control').focus(function() {
            $(this).parent().addClass('focused');
        }).blur(function() {
            $(this).parent().removeClass('focused');
        });

        // 自动聚焦到用户名输入框
        $('input[name="username"]').focus();
    });
</script>
</body>
</html>