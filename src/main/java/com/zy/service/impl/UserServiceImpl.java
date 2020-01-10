package com.zy.service.impl;

import com.github.pagehelper.PageInfo;
import com.zy.dao.Userdao;
import com.zy.entity.User;
import com.zy.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private Userdao userdao;

    @Override
    public int addUser(User user) {
        return userdao.addUser(user);
    }

    @Override
    public int deleteUserById(Integer id) {
        return userdao.deleteUserById(id);
    }

    @Override
    public int deleteUsers(User user) {
        return userdao.deleteUsers(user);
    }

    @Override
    public int updateUser(User user) {
        return userdao.updateUser(user);
    }

    @Override
    public User selectUserById(Integer id) {
        return userdao.selectUserById(id);
    }

    @Override
    public List<User> findUsers() {

        return userdao.findUsers();
    }

}
