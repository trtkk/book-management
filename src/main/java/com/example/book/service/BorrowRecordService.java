package com.example.book.service;

import com.example.book.entity.BorrowRecord;
import com.example.book.util.PageInfo;
import java.util.List;

public interface BorrowRecordService {

    // 获取所有借阅记录
    List<BorrowRecord> getAllBorrowRecords();

    // 分页获取所有借阅记录
    PageInfo<BorrowRecord> getAllBorrowRecordsByPage(int currentPage, int pageSize);

    // 根据用户ID获取借阅记录
    List<BorrowRecord> getBorrowRecordsByUser(Integer userId);

    // 分页根据用户ID获取借阅记录
    PageInfo<BorrowRecord> getBorrowRecordsByUserByPage(Integer userId, int currentPage, int pageSize);

    // 获取当前借阅记录
    List<BorrowRecord> getCurrentBorrows();

    // 借阅图书
    boolean borrowBook(Integer bookId, Integer userId, Integer days);

    // 归还图书
    boolean returnBook(Integer recordId);

    // 获取逾期记录
    List<BorrowRecord> getOverdueRecords();
    
    // 根据ID获取借阅记录
    BorrowRecord getBorrowRecordById(Integer recordId);
    
    // 获取当前借阅中的记录数量
    int getCurrentBorrowCount();
    
    // 统计借阅记录总数
    int getTotalBorrowRecordCount();
}