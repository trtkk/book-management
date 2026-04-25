package com.example.book.dao;

import com.example.book.entity.BorrowRecord;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface BorrowRecordMapper {

    // 查询所有借阅记录
    List<BorrowRecord> findAll();

    // 分页查询所有借阅记录
    List<BorrowRecord> findByPage(@Param("offset") int offset, @Param("pageSize") int pageSize);

    // 根据用户ID查询借阅记录
    List<BorrowRecord> findByUserId(Integer userId);

    // 分页根据用户ID查询借阅记录
    List<BorrowRecord> findByUserIdAndPage(@Param("userId") Integer userId, 
                                          @Param("offset") int offset, 
                                          @Param("pageSize") int pageSize);

    // 查询当前借阅中的记录
    List<BorrowRecord> findCurrentBorrows();

    // 根据ID查询借阅记录
    BorrowRecord findById(Integer id);

    // 新增借阅记录
    void insert(BorrowRecord record);

    // 更新借阅记录（归还）
    void update(BorrowRecord record);

    // 查询逾期记录
    List<BorrowRecord> findOverdueRecords();

    // 统计用户当前借阅数量
    int countCurrentBorrowsByUser(Integer userId);

    // 检查图书是否已被某用户借阅且未归还
    BorrowRecord findBorrowingByBookAndUser(@Param("bookId") Integer bookId,
                                            @Param("userId") Integer userId);
                                            
    // 统计当前借阅中的记录数量
    int countCurrentBorrows();
    
    // 根据图书ID删除借阅记录
    void deleteByBookId(Integer bookId);
    
    // 统计借阅记录总数
    int countAllRecords();
    
    // 统计指定用户的借阅记录总数
    int countByUserId(Integer userId);
}