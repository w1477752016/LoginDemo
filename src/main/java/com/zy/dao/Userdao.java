package com.zy.dao;

import com.zy.entity.User;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public interface Userdao {
    /**
     * 添加用户
     */
    int addUser(User user);

    /**
     * 根据主键ID删除用户
     */
     int deleteUserById(Integer id);

    /**
     * 根据条件删除用户
     */
     int deleteUsers(User user);

    /**
     * 修改用户信息
     */
     int updateUser(User user);

    /**
     * 根据主键ID查询用户
     */
     User selectUserById(Integer id);

    /**
     * 根据条件查询用户信息
     */
     List<User> findUsers();
}
