<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
                    <span class="navbar-brand">用户管理</span>
                    <div class="d-flex">
                        <span class="navbar-text me-3">
                            <i class="fas fa-user me-1"></i>${currentUser.realName} (${currentUser.role == 'ADMIN' ? '管理员' : '普通用户'})
                        </span>
                    </div>
                </div>
            </nav>

            <!-- 页面内容 -->
            <div class="container-fluid p-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h3 class="mb-0">用户列表</h3>
                    <a href="/user/add" class="btn btn-primary">
                        <i class="fas fa-user-plus me-1"></i>添加用户
                    </a>
                </div>

                <div class="card">
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>用户名</th>
                                        <th>真实姓名</th>
                                        <th>角色</th>
                                        <th>状态</th>
                                        <th>创建时间</th>
                                        <th>操作</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${pageInfo.list}" var="u">
                                        <tr>
                                            <td>${u.id}</td>
                                            <td>${u.username}</td>
                                            <td>${u.realName}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${u.role == 'ADMIN'}">
                                                        <span class="badge bg-danger">管理员</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-primary">普通用户</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${u.status == 'ACTIVE'}">
                                                        <span class="badge bg-success">激活</span>
                                                    </c:when>
                                                    <c:when test="${u.status == 'INACTIVE'}">
                                                        <span class="badge bg-secondary">禁用</span>
                                                    </c:when>
                                                    <c:when test="${u.status == 'DELETED'}">
                                                        <span class="badge bg-dark">已删除</span>
                                                    </c:when>
                                                    <c:when test="${u.status == 'PENDING'}">
                                                        <span class="badge bg-warning">待激活</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-warning">未知状态: ${u.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td><fmt:formatDate value="${u.createTime}" pattern="yyyy年MM月dd日"/></td>
                                            <td>
                                                <div class="btn-group" role="group">
                                                    <a href="/user/edit/${u.id}" class="btn btn-sm btn-outline-primary">
                                                        <i class="fas fa-edit"></i> 编辑
                                                    </a>
                                                    <c:if test="${u.status == 'ACTIVE' && currentUser.id != u.id}">
                                                        <button onclick="toggleUserStatus(${u.id}, 'disable')" class="btn btn-sm btn-outline-secondary">
                                                            <i class="fas fa-ban"></i> 禁用
                                                        </button>
                                                    </c:if>
                                                    <c:if test="${u.status == 'INACTIVE' && currentUser.id != u.id}">
                                                        <button onclick="toggleUserStatus(${u.id}, 'enable')" class="btn btn-sm btn-outline-success">
                                                            <i class="fas fa-check"></i> 启用
                                                        </button>
                                                    </c:if>
                                                    <c:if test="${u.status != 'DELETED' && currentUser.id != u.id}">
                                                        <button onclick="deleteUser(${u.id})" class="btn btn-sm btn-outline-danger">
                                                            <i class="fas fa-trash"></i> 删除
                                                        </button>
                                                    </c:if>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                        
                        <!-- 分页控件 -->
                        <c:if test="${pageInfo.totalPage > 1}">
                        <nav aria-label="分页导航">
                            <ul class="pagination justify-content-center">
                                <!-- 上一页 -->
                                <c:if test="${pageInfo.hasPrevious}">
                                    <li class="page-item">
                                        <a class="page-link" href="?page=${pageInfo.currentPage - 1}&size=${pageInfo.pageSize}">上一页</a>
                                    </li>
                                </c:if>
                                
                                <!-- 页码 -->
                                <c:forEach var="i" begin="1" end="${pageInfo.totalPage}">
                                    <li class="page-item ${i == pageInfo.currentPage ? 'active' : ''}">
                                        <a class="page-link" href="?page=${i}&size=${pageInfo.pageSize}">${i}</a>
                                    </li>
                                </c:forEach>
                                
                                <!-- 下一页 -->
                                <c:if test="${pageInfo.hasNext}">
                                    <li class="page-item">
                                        <a class="page-link" href="?page=${pageInfo.currentPage + 1}&size=${pageInfo.pageSize}">下一页</a>
                                    </li>
                                </c:if>
                            </ul>
                        </nav>
                        </c:if>
                    </div>
                </div>
                
                <a href="/dashboard" class="btn btn-secondary mt-3">
                    <i class="fas fa-arrow-left me-1"></i>返回首页
                </a>
            </div>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function toggleUserStatus(userId, action) {
        if (!confirm('确定要执行此操作吗？')) {
            return;
        }
        
        $.ajax({
            url: '/user/' + action + '/' + userId,
            type: 'POST',
            success: function(response) {
                if (response === 'success') {
                    alert('操作成功！');
                    location.reload();
                } else {
                    alert('操作失败：' + response);
                }
            },
            error: function(xhr, status, error) {
                alert('操作失败：' + error);
            }
        });
    }
    
    function deleteUser(userId) {
        if (!confirm('确定要删除此用户吗？这将执行软删除操作。')) {
            return;
        }
        
        $.ajax({
            url: '/user/delete/' + userId,
            type: 'POST',
            success: function(response) {
                if (response === 'success') {
                    alert('用户删除成功！');
                    location.reload();
                } else {
                    alert('删除失败：' + response);
                }
            },
            error: function(xhr, status, error) {
                alert('删除失败：' + error);
            }
        });
    }
</script>
</body>
</html>