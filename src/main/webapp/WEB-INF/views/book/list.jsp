<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>图书管理 - 图书管理系统</title>
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
                <a class="nav-link text-white active" href="/book/list">
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
                    <span class="navbar-brand">图书管理</span>
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
                    <h2><i class="fas fa-book me-2"></i>图书列表</h2>
                    <c:if test="${user.role == 'ADMIN'}">
                    <a href="/book/add" class="btn btn-primary">
                        <i class="fas fa-plus me-2"></i>添加图书
                    </a>
                    </c:if>
                </div>

                <!-- 搜索表单 -->
                <div class="card mb-4">
                    <div class="card-body">
                        <form class="row g-3" action="/book/search" method="get">
                            <div class="col-md-3">
                                <label for="searchTitle" class="form-label">书名</label>
                                <input type="text" class="form-control" id="searchTitle" name="title" 
                                       value="${searchTitle != null ? searchTitle : ''}" placeholder="请输入书名">
                            </div>
                            <div class="col-md-3">
                                <label for="searchAuthor" class="form-label">作者</label>
                                <input type="text" class="form-control" id="searchAuthor" name="author" 
                                       value="${searchAuthor != null ? searchAuthor : ''}" placeholder="请输入作者">
                            </div>
                            <div class="col-md-3">
                                <label for="searchCategory" class="form-label">分类</label>
                                <input type="text" class="form-control" id="searchCategory" name="category" 
                                       value="${searchCategory != null ? searchCategory : ''}" placeholder="请输入分类">
                            </div>
                            <div class="col-md-3 d-flex align-items-end">
                                <div class="btn-group" role="group">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-search me-1"></i>搜索
                                    </button>
                                    <a href="/book/list" class="btn btn-outline-secondary">重置</a>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="card">
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-striped table-hover">
                                <thead class="table-dark">
                                <tr>
                                    <th>ID</th>
                                    <th>书名</th>
                                    <th>作者</th>
                                    <th>出版社</th>
                                    <th>分类</th>
                                    <th>ISBN</th>
                                    <th>库存</th>
                                    <th>操作</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="book" items="${pageInfo.list}">
                                    <tr>
                                        <td>${book.id}</td>
                                        <td>${book.title}</td>
                                        <td>${book.author}</td>
                                        <td>${book.publisher}</td>
                                        <td><span class="badge bg-info">${book.category}</span></td>
                                        <td>${book.isbn}</td>
                                        <td>
                                                    <span class="badge ${book.availableCopies > 0 ? 'bg-success' : 'bg-danger'}">
                                                        ${book.availableCopies}/${book.totalCopies}
                                                    </span>
                                        </td>
                                        <td>
                                            <div class="btn-group btn-group-sm" role="group">
                                                <c:if test="${user.role == 'ADMIN'}">
                                                <a href="/book/edit/${book.id}" class="btn btn-outline-primary">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                                <a href="/book/delete/${book.id}" class="btn btn-outline-danger"
                                                   onclick="return confirm('确定删除这本书吗？')">
                                                    <i class="fas fa-trash"></i>
                                                </a>
                                                </c:if>
                                                <c:if test="${user.role == 'USER' && book.availableCopies > 0}">
                                                <button class="btn btn-outline-success" onclick="borrowBook(${book.id})">
                                                    <i class="fas fa-hand-holding me-1"></i>借阅
                                                </button>
                                                </c:if>
                                                <c:if test="${user.role == 'USER' && book.availableCopies <= 0}">
                                                <button class="btn btn-outline-secondary" disabled>
                                                    <i class="fas fa-hand-holding me-1"></i>已借完
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
                                        <c:choose>
                                            <c:when test="${not empty searchTitle or not empty searchAuthor or not empty searchCategory}">
                                                <a class="page-link" href="?title=${searchTitle}&author=${searchAuthor}&category=${searchCategory}&page=${pageInfo.currentPage - 1}&size=${pageInfo.pageSize}">上一页</a>
                                            </c:when>
                                            <c:otherwise>
                                                <a class="page-link" href="?page=${pageInfo.currentPage - 1}&size=${pageInfo.pageSize}">上一页</a>
                                            </c:otherwise>
                                        </c:choose>
                                    </li>
                                </c:if>
                                
                                <!-- 页码 -->
                                <c:forEach var="i" begin="1" end="${pageInfo.totalPage}">
                                    <li class="page-item ${i == pageInfo.currentPage ? 'active' : ''}">
                                        <c:choose>
                                            <c:when test="${not empty searchTitle or not empty searchAuthor or not empty searchCategory}">
                                                <a class="page-link" href="?title=${searchTitle}&author=${searchAuthor}&category=${searchCategory}&page=${i}&size=${pageInfo.pageSize}">${i}</a>
                                            </c:when>
                                            <c:otherwise>
                                                <a class="page-link" href="?page=${i}&size=${pageInfo.pageSize}">${i}</a>
                                            </c:otherwise>
                                        </c:choose>
                                    </li>
                                </c:forEach>
                                
                                <!-- 下一页 -->
                                <c:if test="${pageInfo.hasNext}">
                                    <li class="page-item">
                                        <c:choose>
                                            <c:when test="${not empty searchTitle or not empty searchAuthor or not empty searchCategory}">
                                                <a class="page-link" href="?title=${searchTitle}&author=${searchAuthor}&category=${searchCategory}&page=${pageInfo.currentPage + 1}&size=${pageInfo.pageSize}">下一页</a>
                                            </c:when>
                                            <c:otherwise>
                                                <a class="page-link" href="?page=${pageInfo.currentPage + 1}&size=${pageInfo.pageSize}">下一页</a>
                                            </c:otherwise>
                                        </c:choose>
                                    </li>
                                </c:if>
                            </ul>
                        </nav>
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
    function borrowBook(bookId) {
        if (!confirm('确定要借阅这本书吗？')) {
            return;
        }
        
        // 默认借阅天数为30天
        const days = 30;
        
        $.ajax({
            url: '/borrow/add',
            type: 'POST',
            data: {
                bookId: bookId,
                days: days
            },
            success: function(response) {
                if (response.success) {
                    alert('借阅成功！');
                    location.reload();
                } else {
                    alert('借阅失败：' + response.message);
                }
            },
            error: function() {
                alert('借阅失败，请稍后重试！');
            }
        });
    }
</script>
</body>
</html>