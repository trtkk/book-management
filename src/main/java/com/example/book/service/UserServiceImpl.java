package com.example.book.service;

import com.example.book.dao.UserMapper;
import com.example.book.entity.User;
import com.example.book.util.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

import org.mindrot.jbcrypt.BCrypt;

@Service
@Transactional
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Override
    public User login(String username, String password) {
        try {
            User user = userMapper.findByUsername(username);
            if (user != null) {
                // 直接使用BCrypt验证密码
                if (checkPassword(password, user.getPassword())) {
                    return user;
                }
            }
            return null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    @Override
    public boolean register(User user) {
        try {
            // 检查用户名是否已存在
            if (isUsernameExists(user.getUsername())) {
                return false;
            }

            // 设置默认值
            user.setRole("USER");
            user.setStatus("ACTIVE");
            user.setCreateTime(new Date());
         
            // 使用BCrypt加密密码
            String hashedPassword = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt());
            user.setPassword(hashedPassword);

            userMapper.insert(user);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean isUsernameExists(String username) {
        User user = userMapper.findByUsername(username);
        return user != null;
    }

    // 删除现有的MD5加密方法，使用BCrypt替代
    private boolean checkPassword(String plainPassword, String hashedPassword) {
        return BCrypt.checkpw(plainPassword, hashedPassword);
    }
    
    @Override
    public List<User> getAllUsers() {
        return userMapper.findAll();
    }

    @Override
    public PageInfo<User> getUsersByPage(int currentPage, int pageSize) {
        // 计算偏移量
        int offset = (currentPage - 1) * pageSize;
        
        // 查询数据
        List<User> users = userMapper.findByPage(offset, pageSize);
        
        // 查询总数
        int totalCount = userMapper.countAllUsers();
        
        // 创建分页信息对象
        return new PageInfo<>(currentPage, pageSize, totalCount, users);
    }

    @Override
    public User getUserById(Integer id) {
        return userMapper.findById(id);
    }

    @Override
    public void addUser(User user) {
        try {
            // 检查用户名是否已存在
            User existingUser = userMapper.findByUsername(user.getUsername());
            if (existingUser != null) {
                throw new RuntimeException("用户名已存在");
            }
            // 设置默认状态为待激活
            if (user.getStatus() == null || user.getStatus().isEmpty()) {
                user.setStatus("PENDING");
            }
            // 使用BCrypt加密密码
            String hashedPassword = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt());
            user.setPassword(hashedPassword);
            user.setCreateTime(new Date());
            userMapper.insert(user);
        } catch (Exception e) {
            throw new RuntimeException("添加用户失败: " + e.getMessage(), e);
        }
    }

    @Override
    public void updateUser(User user) {
        try {
            // 如果密码为空，则不更新密码
            if (user.getPassword() == null || user.getPassword().trim().isEmpty()) {
                // 从数据库获取现有用户信息
                User existingUser = userMapper.findById(user.getId());
                if (existingUser != null) {
                    user.setPassword(existingUser.getPassword());
                }
            } else {
                // 如果提供了新密码，则使用BCrypt加密
                String hashedPassword = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt());
                user.setPassword(hashedPassword);
            }
            userMapper.update(user);
        } catch (Exception e) {
            throw new RuntimeException("更新用户失败: " + e.getMessage(), e);
        }
    }

    @Override
    public void disableUser(Integer id) {
        userMapper.updateStatus(id, "INACTIVE");
    }

    @Override
    public void enableUser(Integer id) {
        userMapper.updateStatus(id, "ACTIVE");
    }

    @Override
    public void deleteUser(Integer id) {
        try {
            userMapper.deleteUser(id);
        } catch (Exception e) {
            // 如果deleteUser失败，尝试使用softDeleteUser
            try {
                userMapper.softDeleteUser(id);
            } catch (Exception ex) {
                throw new RuntimeException("删除用户失败: " + ex.getMessage(), ex);
            }
        }
    }
    
    @Override
    public void softDeleteUser(Integer id) {
        userMapper.softDeleteUser(id);
    }

    @Override
    public List<User> getActiveUsers() {
        return userMapper.findActiveUsers();
    }
    
    @Override
    public int getTotalUserCount() {
        return userMapper.countAllUsers();
    }
}