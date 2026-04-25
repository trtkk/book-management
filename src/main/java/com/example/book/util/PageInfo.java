package com.example.book.util;

import java.util.List;

/**
 * 分页信息类
 * @param <T> 数据类型
 */
public class PageInfo<T> {
    // 当前页码
    private int currentPage;
    
    // 每页显示数量
    private int pageSize;
    
    // 总记录数
    private int totalCount;
    
    // 总页数
    private int totalPage;
    
    // 数据列表
    private List<T> list;
    
    // 是否有上一页
    private boolean hasPrevious;
    
    // 是否有下一页
    private boolean hasNext;
    
    public PageInfo() {}
    
    public PageInfo(int currentPage, int pageSize, int totalCount, List<T> list) {
        this.currentPage = currentPage;
        this.pageSize = pageSize;
        this.totalCount = totalCount;
        this.list = list;
        
        // 计算总页数
        this.totalPage = (totalCount + pageSize - 1) / pageSize;
        
        // 计算是否有上一页和下一页
        this.hasPrevious = currentPage > 1;
        this.hasNext = currentPage < totalPage;
    }
    
    // Getter和Setter方法
    public int getCurrentPage() {
        return currentPage;
    }
    
    public void setCurrentPage(int currentPage) {
        this.currentPage = currentPage;
    }
    
    public int getPageSize() {
        return pageSize;
    }
    
    public void setPageSize(int pageSize) {
        this.pageSize = pageSize;
    }
    
    public int getTotalCount() {
        return totalCount;
    }
    
    public void setTotalCount(int totalCount) {
        this.totalCount = totalCount;
    }
    
    public int getTotalPage() {
        return totalPage;
    }
    
    public void setTotalPage(int totalPage) {
        this.totalPage = totalPage;
    }
    
    public List<T> getList() {
        return list;
    }
    
    public void setList(List<T> list) {
        this.list = list;
    }
    
    public boolean isHasPrevious() {
        return hasPrevious;
    }
    
    public void setHasPrevious(boolean hasPrevious) {
        this.hasPrevious = hasPrevious;
    }
    
    public boolean isHasNext() {
        return hasNext;
    }
    
    public void setHasNext(boolean hasNext) {
        this.hasNext = hasNext;
    }
}