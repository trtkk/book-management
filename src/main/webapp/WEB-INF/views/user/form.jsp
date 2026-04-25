<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户管理 - 图书管理系统</title>
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
                <a class="nav-link text-white" href="/dashboard">
                    <i class="fas fa-tachometer-alt me-2"></i>首页
                </a>
                <a class="nav-link text-white" href="/book/list">
                    <i class="fas fa-book me-2"></i>图书管理
                </a>
                <a class="nav-link text-white" href="/borrow/list">
                    <i class="fas fa-exchange-alt me-2"></i>借阅管理
                </a>
                <c:if test="${currentUser.role == 'ADMIN'}">
                <a class="nav-link text-white active" href="/user/list">
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
                    <span class="navbar-brand">
                        <c:choose>
                            <c:when test="${empty user.id}">添加用户</c:when>
                            <c:otherwise>编辑用户</c:otherwise>
                        </c:choose>
                    </span>
                    <div class="d-flex">
                        <span class="navbar-text me-3">
                            <i class="fas fa-user me-1"></i>${currentUser.realName} (${currentUser.role == 'ADMIN' ? '管理员' : '普通用户'})
                        </span>
                    </div>
                </div>
            </nav>

            <!-- 页面内容 -->
            <div class="container-fluid p-4">
                <div class="row">
                    <div class="col-md-8 mx-auto">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">
                                    <c:choose>
                                        <c:when test="${empty user.id}"><i class="fas fa-user-plus me-2"></i>添加用户</c:when>
                                        <c:otherwise><i class="fas fa-user-edit me-2"></i>编辑用户</c:otherwise>
                                    </c:choose>
                                </h5>
                            </div>
                            <div class="card-body">
                                <form id="userForm" action="${empty user.id ? '/user/add' : '/user/update'}" method="post">
                                    <input type="hidden" name="id" value="${user.id}">
                                    
                                    <div class="mb-3">
                                        <label for="username" class="form-label">用户名 *</label>
                                        <div class="input-group">
                                            <span class="input-group-text"><i class="fas fa-user"></i></span>
                                            <input type="text" class="form-control" id="username" name="username" 
                                                   value="${user.username}" required 
                                                   <c:if test="${not empty user.id}">readonly</c:if>>
                                        </div>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label for="password" class="form-label">
                                            <c:choose>
                                                <c:when test="${empty user.id}">密码 *</c:when>
                                                <c:otherwise>新密码 (留空则不修改)</c:otherwise>
                                            </c:choose>
                                        </label>
                                        <div class="input-group">
                                            <span class="input-group-text"><i class="fas fa-lock"></i></span>
                                            <input type="password" class="form-control" id="password" name="password" 
                                                   <c:if test="${empty user.id}">required</c:if>>
                                        </div>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label for="realName" class="form-label">真实姓名 *</label>
                                        <div class="input-group">
                                            <span class="input-group-text"><i class="fas fa-id-card"></i></span>
                                            <input type="text" class="form-control" id="realName" name="realName" 
                                                   value="${user.realName}" required>
                                        </div>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label for="role" class="form-label">角色 *</label>
                                        <div class="input-group">
                                            <span class="input-group-text"><i class="fas fa-user-tag"></i></span>
                                            <select class="form-select" id="role" name="role" required <c:if test="${user.id == currentUser.id}">disabled</c:if>>
                                                <option value="">请选择角色</option>
                                                <option value="USER" <c:if test="${user.role == 'USER'}">selected</c:if>>普通用户</option>
                                                <option value="ADMIN" <c:if test="${user.role == 'ADMIN'}">selected</c:if>>管理员</option>
                                            </select>
                                        </div>
                                    </div>
                                    
                                    <c:if test="${not empty user.id && user.id != currentUser.id}">
                                    <div class="mb-3">
                                        <label for="status" class="form-label">状态</label>
                                        <div class="input-group">
                                            <span class="input-group-text"><i class="fas fa-info-circle"></i></span>
                                            <select class="form-select" id="status" name="status" required>
                                                <option value="ACTIVE" <c:if test="${user.status == 'ACTIVE'}">selected</c:if>>激活</option>
                                                <option value="INACTIVE" <c:if test="${user.status == 'INACTIVE'}">selected</c:if>>禁用</option>
                                                <option value="PENDING" <c:if test="${user.status == 'PENDING'}">selected</c:if>>待激活</option>
                                            </select>
                                        </div>
                                    </div>
                                    </c:if>
                                    
                                    <div class="d-flex justify-content-between">
                                        <a href="/user/list" class="btn btn-secondary">
                                            <i class="fas fa-arrow-left me-1"></i>返回用户列表
                                        </a>
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-save me-1"></i>
                                            <c:choose>
                                                <c:when test="${empty user.id}">添加用户</c:when>
                                                <c:otherwise>保存更改</c:otherwise>
                                            </c:choose>
                                        </button>
                                    </div>
                                </form>
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
<script>
    $(document).ready(function() {
        $('#userForm').on('submit', function(e) {
            e.preventDefault();
            
            const formData = $(this).serialize();
            const url = '${empty user.id ? "/user/add" : "/user/update"}';
            
            $.ajax({
                url: url,
                type: 'POST',
                data: formData,
                success: function(response) {
                    alert('${empty user.id ? "用户添加成功！" : "用户信息更新成功！"}');
                    window.location.href = '/user/list';
                },
                error: function(xhr, status, error) {
                    alert('操作失败: ' + xhr.responseText);
                }
            });
        });
    });
</script>
</body>
</html>