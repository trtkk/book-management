<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>我的借阅 - 图书管理系统</title>
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
                <a class="nav-link text-white active" href="/borrow/my">
                    <i class="fas fa-exchange-alt me-2"></i>我的借阅
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
                    <span class="navbar-brand">我的借阅记录</span>
                    <div class="d-flex">
                        <span class="navbar-text me-3">
                            <i class="fas fa-user me-1"></i>${user.realName} (${user.role == 'ADMIN' ? '管理员' : '普通用户'})
                        </span>
                    </div>
                </div>
            </nav>

            <!-- 页面内容 -->
            <div class="container-fluid p-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2><i class="fas fa-book-reader me-2"></i>我的借阅记录</h2>
                </div>

                <div class="card">
                    <div class="card-body">
                        <c:if test="${empty pageInfo.list}">
                            <div class="text-center py-5">
                                <i class="fas fa-book-open fa-3x text-muted mb-3"></i>
                                <h4 class="text-muted">暂无借阅记录</h4>
                                <p class="text-muted">您可以前往图书列表借阅喜欢的书籍</p>
                                <a href="/book/list" class="btn btn-primary">浏览图书</a>
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty pageInfo.list}">
                        <div class="table-responsive">
                            <table class="table table-striped table-hover">
                                <thead class="table-dark">
                                <tr>
                                    <th>ID</th>
                                    <th>书名</th>
                                    <th>借阅日期</th>
                                    <th>应还日期</th>
                                    <th>状态</th>
                                    <th>操作</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="record" items="${pageInfo.list}">
                                    <tr>
                                        <td>${record.id}</td>
                                        <td>${record.bookTitle}</td>
                                        <td><fmt:formatDate value="${record.borrowDate}" pattern="yyyy年MM月dd日"/></td>
                                        <td><fmt:formatDate value="${record.expectedReturnDate}" pattern="yyyy年MM月dd日"/></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${record.status == 'BORROWED'}">
                                                    <span class="badge bg-success">借阅中</span>
                                                </c:when>
                                                <c:when test="${record.status == 'RETURNED'}">
                                                    <span class="badge bg-secondary">已归还</span>
                                                </c:when>
                                                <c:when test="${record.status == 'OVERDUE'}">
                                                    <span class="badge bg-danger">已逾期</span>
                                                </c:when>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:if test="${record.status == 'BORROWED'}">
                                            <button class="btn btn-sm btn-outline-primary" onclick="returnBook(${record.id})">
                                                <i class="fas fa-undo me-1"></i>归还
                                            </button>
                                            </c:if>
                                            <c:if test="${record.status == 'RETURNED'}">
                                            <button class="btn btn-sm btn-outline-secondary" disabled>
                                                <i class="fas fa-check me-1"></i>已完成
                                            </button>
                                            </c:if>
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
                        </c:if>
                    </div>
                </div>

                <div class="mt-3">
                    <a href="/dashboard" class="btn btn-secondary">
                        <i class="fas fa-arrow-left me-2"></i>返回首页
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function returnBook(recordId) {
        if (!confirm('确定要归还这本书吗？')) {
            return;
        }
        
        $.ajax({
            url: '/borrow/return/' + recordId,
            type: 'POST',
            success: function(response) {
                if (response.success) {
                    alert('归还成功！');
                    location.reload();
                } else {
                    alert('归还失败：' + response.message);
                }
            },
            error: function() {
                alert('归还失败，请稍后重试！');
            }
        });
    }
</script>
</body>
</html>