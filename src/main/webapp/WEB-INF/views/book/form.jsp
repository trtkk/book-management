<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
                    <span class="navbar-brand">
                        <c:choose>
                            <c:when test="${empty book.id}">添加图书</c:when>
                            <c:otherwise>编辑图书</c:otherwise>
                        </c:choose>
                    </span>
                    <div class="d-flex">
                        <span class="navbar-text me-3">
                            <i class="fas fa-user me-1"></i>${user.realName} (${user.role == 'ADMIN' ? '管理员' : '普通用户'})
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
                                        <c:when test="${empty book.id}"><i class="fas fa-plus-circle me-2"></i>添加图书</c:when>
                                        <c:otherwise><i class="fas fa-edit me-2"></i>编辑图书</c:otherwise>
                                    </c:choose>
                                </h5>
                            </div>
                            <div class="card-body">
                                <form id="bookForm" action="${empty book.id ? '/book/add' : '/book/update'}" method="post">
                                    <input type="hidden" name="id" value="${book.id}">
                                    
                                    <div class="mb-3">
                                        <label for="title" class="form-label">书名 *</label>
                                        <div class="input-group">
                                            <span class="input-group-text"><i class="fas fa-book"></i></span>
                                            <input type="text" class="form-control" id="title" name="title" 
                                                   value="${book.title}" required>
                                        </div>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label for="author" class="form-label">作者 *</label>
                                        <div class="input-group">
                                            <span class="input-group-text"><i class="fas fa-user-edit"></i></span>
                                            <input type="text" class="form-control" id="author" name="author" 
                                                   value="${book.author}" required>
                                        </div>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label for="isbn" class="form-label">ISBN *</label>
                                        <div class="input-group">
                                            <span class="input-group-text"><i class="fas fa-barcode"></i></span>
                                            <input type="text" class="form-control" id="isbn" name="isbn" 
                                                   value="${book.isbn}" required>
                                        </div>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label for="publisher" class="form-label">出版社 *</label>
                                        <div class="input-group">
                                            <span class="input-group-text"><i class="fas fa-building"></i></span>
                                            <input type="text" class="form-control" id="publisher" name="publisher" 
                                                   value="${book.publisher}" required>
                                        </div>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label for="publishDate" class="form-label">出版日期</label>
                                        <div class="input-group">
                                            <span class="input-group-text"><i class="fas fa-calendar-alt"></i></span>
                                            <input type="date" class="form-control" id="publishDate" name="publishDate" 
                                                   value="${book.publishDate != null ? book.publishDate : ''}">
                                        </div>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label for="category" class="form-label">分类 *</label>
                                        <div class="input-group">
                                            <span class="input-group-text"><i class="fas fa-tags"></i></span>
                                            <input type="text" class="form-control" id="category" name="category" 
                                                   value="${book.category}" required>
                                        </div>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label for="totalCopies" class="form-label">总数量 *</label>
                                        <div class="input-group">
                                            <span class="input-group-text"><i class="fas fa-layer-group"></i></span>
                                            <input type="number" class="form-control" id="totalCopies" name="totalCopies" 
                                                   value="${book.totalCopies != null ? book.totalCopies : '1'}" 
                                                   min="1" required>
                                        </div>
                                    </div>
                                    
                                    <c:if test="${not empty book.id}">
                                    <div class="mb-3">
                                        <label class="form-label">可借数量</label>
                                        <div class="input-group">
                                            <span class="input-group-text"><i class="fas fa-book-reader"></i></span>
                                            <input type="text" class="form-control" value="${book.availableCopies} / ${book.totalCopies}" readonly>
                                        </div>
                                    </div>
                                    </c:if>
                                    
                                    <div class="d-flex justify-content-between">
                                        <a href="/book/list" class="btn btn-secondary">
                                            <i class="fas fa-arrow-left me-1"></i>返回图书列表
                                        </a>
                                        <c:if test="${user.role == 'ADMIN'}">
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-save me-1"></i>
                                            <c:choose>
                                                <c:when test="${empty book.id}">添加图书</c:when>
                                                <c:otherwise>保存更改</c:otherwise>
                                            </c:choose>
                                        </button>
                                        </c:if>
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
<c:if test="${user.role == 'ADMIN'}">
<script>
    $(document).ready(function() {
        $('#bookForm').on('submit', function(e) {
            // 表单验证已在HTML5层面完成
        });
    });
</script>
</c:if>
</body>
</html>