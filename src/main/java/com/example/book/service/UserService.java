package com.example.book.service;

import com.example.book.entity.User;
import com.example.book.util.PageInfo;
import java.util.List;

public interface UserService {

    // 用户注册
    boolean register(User user);

    // 检查用户名是否存在
    boolean isUsernameExists(String username);

    // 用户登录
    User login(String username, String password);

    // 获取所有用户
    List<User> getAllUsers();

    // 分页获取用户
    PageInfo<User> getUsersByPage(int currentPage, int pageSize);

    // 根据ID获取用户
    User getUserById(Integer id);

    // 添加用户
    void addUser(User user);

    // 更新用户
    void updateUser(User user);

    // 禁用用户
    void disableUser(Integer id);

    // 启用用户
    void enableUser(Integer id);

    // 删除用户（软删除）
    void deleteUser(Integer id);
    
    // 软删除用户（使用inactive状态表示删除）
    void softDeleteUser(Integer id);

    // 获取活跃用户列表
    List<User> getActiveUsers();
    
    // 获取用户总数
    int getTotalUserCount();
}