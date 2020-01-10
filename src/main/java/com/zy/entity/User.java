package com.zy.entity;

import java.io.Serializable;

public class User implements Serializable {
    private static final long serialVersionUID = 2693809695953212355L;
    private Integer id;
    private  String name;
    private String passwrod;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPasswrod(){
        return passwrod;
    }

    public void setPasswrod(String password) {
        this.passwrod = password;
    }

    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", password='" + passwrod + '\'' +
                '}';
    }
}
