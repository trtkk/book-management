package com.example.book.service;

import com.example.book.dao.BookMapper;
import com.example.book.dao.BorrowRecordMapper;
import com.example.book.entity.Book;
import com.example.book.entity.BorrowRecord;
import com.example.book.util.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Calendar;
import java.util.Date;
import java.util.List;

@Service
@Transactional
public class BorrowRecordServiceImpl implements BorrowRecordService {

    @Autowired
    private BorrowRecordMapper borrowRecordMapper;

    @Autowired
    private BookMapper bookMapper;

    @Override
    public List<BorrowRecord> getAllBorrowRecords() {
        return borrowRecordMapper.findAll();
    }

    @Override
    public PageInfo<BorrowRecord> getAllBorrowRecordsByPage(int currentPage, int pageSize) {
        // 计算偏移量
        int offset = (currentPage - 1) * pageSize;
        
        // 查询数据
        List<BorrowRecord> records = borrowRecordMapper.findByPage(offset, pageSize);
        
        // 查询总数
        int totalCount = borrowRecordMapper.countAllRecords();
        
        // 创建分页信息对象
        return new PageInfo<>(currentPage, pageSize, totalCount, records);
    }

    @Override
    public List<BorrowRecord> getBorrowRecordsByUser(Integer userId) {
        return borrowRecordMapper.findByUserId(userId);
    }

    @Override
    public PageInfo<BorrowRecord> getBorrowRecordsByUserByPage(Integer userId, int currentPage, int pageSize) {
        // 计算偏移量
        int offset = (currentPage - 1) * pageSize;
        
        // 查询数据
        List<BorrowRecord> records = borrowRecordMapper.findByUserIdAndPage(userId, offset, pageSize);
        
        // 查询总数
        int totalCount = borrowRecordMapper.countByUserId(userId);
        
        // 创建分页信息对象
        return new PageInfo<>(currentPage, pageSize, totalCount, records);
    }

    @Override
    public List<BorrowRecord> getCurrentBorrows() {
        return borrowRecordMapper.findCurrentBorrows();
    }

    @Override
    public boolean borrowBook(Integer bookId, Integer userId, Integer days) {
        // 检查图书是否可借
        Book book = bookMapper.findById(bookId);
        if (book == null || book.getAvailableCopies() <= 0) {
            return false;
        }

        // 检查用户是否已经借阅了同一本书且未归还
        BorrowRecord existingRecord = borrowRecordMapper.findBorrowingByBookAndUser(bookId, userId);
        if (existingRecord != null) {
            return false;
        }

        try {
            // 创建借阅记录
            BorrowRecord record = new BorrowRecord();
            record.setBookId(bookId);
            record.setUserId(userId);
            record.setBorrowDate(new Date());

            // 计算应还日期
            Calendar calendar = Calendar.getInstance();
            calendar.add(Calendar.DAY_OF_YEAR, days);
            record.setExpectedReturnDate(calendar.getTime());
            record.setStatus("BORROWED");

            // 更新图书库存
            bookMapper.updateAvailableCopies(bookId, -1);

            // 保存借阅记录
            borrowRecordMapper.insert(record);

            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean returnBook(Integer recordId) {
        BorrowRecord record = borrowRecordMapper.findById(recordId);
        if (record == null || "RETURNED".equals(record.getStatus())) {
            return false;
        }

        // 更新借阅记录
        record.setActualReturnDate(new Date());
        record.setStatus("RETURNED");
        borrowRecordMapper.update(record);

        // 恢复图书库存
        bookMapper.updateAvailableCopies(record.getBookId(), 1);

        return true;
    }

    @Override
    public List<BorrowRecord> getOverdueRecords() {
        return borrowRecordMapper.findOverdueRecords();
    }
    
    @Override
    public BorrowRecord getBorrowRecordById(Integer recordId) {
        return borrowRecordMapper.findById(recordId);
    }
    
    @Override
    public int getCurrentBorrowCount() {
        return borrowRecordMapper.countCurrentBorrows();
    }
    
    @Override
    public int getTotalBorrowRecordCount() {
        return borrowRecordMapper.countAllRecords();
    }
}