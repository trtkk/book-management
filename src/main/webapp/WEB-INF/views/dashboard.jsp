<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>图书管理系统 - 首页</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <!-- 侧边栏 -->
        <div class="col-md-2 bg-dark text-white p-0 min-vh-100">
            <div class="p-3">
                <h4 class="text-white text-center">
                    <i class="fas fa-book"></i>
                    图书管理系统
                </h4>
            </div>
            <nav class="nav flex-column">
                <a class="nav-link text-white active" href="/dashboard">
                    <i class="fas fa-tachometer-alt me-2"></i>首页
                </a>
                <a class="nav-link text-white" href="/book/list">
                    <i class="fas fa-book me-2"></i>图书管理
                </a>
                <a class="nav-link text-white" href="/borrow/list">
                    <i class="fas fa-exchange-alt me-2"></i>借阅管理
                </a>
                <c:if test="${user.role == 'ADMIN'}">
                <a class="nav-link text-white" href="/user/list">
                    <i class="fas fa-users me-2"></i>用户管理
                </a>
                </c:if>
                <a class="nav-link text-white" href="/logout">
                    <i class="fas fa-sign-out-alt me-2"></i>退出登录
                </a>
            </nav>
        </div>

        <!-- 主内容区 -->
        <div class="col-md-10 p-0">
            <!-- 顶部导航 -->
            <nav class="navbar navbar-light bg-white shadow-sm">
                <div class="container-fluid">
                    <span class="navbar-brand">系统概览</span>
                    <div class="d-flex">
                            <span class="navbar-text me-3">
                                <i class="fas fa-user me-1"></i>${user.realName} (${user.role == 'ADMIN' ? '管理员' : '普通用户'})
                            </span>
                    </div>
                </div>
            </nav>

            <!-- 页面内容 -->
            <div class="container-fluid p-4">
                <h3 class="mb-4">欢迎回来，${user.realName}！</h3>

                <!-- 统计卡片 -->
                <div class="row mb-4">
                    <div class="col-md-3">
                        <div class="card border-primary">
                            <div class="card-body">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <h5 class="card-title">总图书数</h5>
                                        <h2 class="text-primary">${totalBooks}</h2>
                                    </div>
                                    <div class="align-self-center">
                                        <i class="fas fa-book fa-2x text-primary"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card border-success">
                            <div class="card-body">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <h5 class="card-title">可借图书</h5>
                                        <h2 class="text-success">${availableBooks}</h2>
                                    </div>
                                    <div class="align-self-center">
                                        <i class="fas fa-book-open fa-2x text-success"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card border-warning">
                            <div class="card-body">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <h5 class="card-title">借阅中</h5>
                                        <h2 class="text-warning">${currentBorrows}</h2>
                                    </div>
                                    <div class="align-self-center">
                                        <i class="fas fa-exchange-alt fa-2x text-warning"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card border-info">
                            <div class="card-body">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <h5 class="card-title">总用户数</h5>
                                        <h2 class="text-info">${totalUsers}</h2>
                                    </div>
                                    <div class="align-self-center">
                                        <i class="fas fa-users fa-2x text-info"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 快捷操作 -->
                <div class="row">
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">快捷操作</h5>
                            </div>
                            <div class="card-body">
                                <div class="d-grid gap-2">
                                    <c:if test="${user.role == 'ADMIN'}">
                                    <a href="/book/add" class="btn btn-primary">
                                        <i class="fas fa-plus me-2"></i>添加新图书
                                    </a>
                                    </c:if>
                                    <a href="/book/list" class="btn btn-success">
                                        <i class="fas fa-search me-2"></i>浏览图书
                                    </a>
                                    <c:if test="${user.role == 'ADMIN'}">
                                        <a href="/user/add" class="btn btn-info">
                                            <i class="fas fa-user-plus me-2"></i>添加用户
                                        </a>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">系统信息</h5>
                            </div>
                            <div class="card-body">
                                <p><strong>用户名：</strong>${user.username}</p>
                                <p><strong>角色：</strong>${user.role == 'ADMIN' ? '管理员' : '普通用户'}</p>
                                <p><strong>登录时间：</strong><%= new java.util.Date() %></p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>