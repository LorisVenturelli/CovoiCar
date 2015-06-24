package com.covoicar.rcdsm.models;

import io.realm.RealmObject;
import io.realm.annotations.PrimaryKey;

/**
 * Created by rcdsm on 23/06/15.
 */
public class User extends RealmObject {

    @PrimaryKey
    private long        id;

    private String      email;
    private String      lastName;
    private String      firtname;
    private String      phone;
    private String      bio;
    private String      birthday;
    private String      gender;
    private String      token;
    private static User instance;

    public static User getInstance(){
        if (instance == null) {
            instance = new User();
        }
        return instance;
    }

    public User(){
    }

    public long getId(){
        return id;
    }

    public void setId(long valueId){
        this.id = valueId;
    }


    public String getEmail() {
        return email;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getFirtname() {
        return firtname;
    }

    public void setFirtname(String firtname) {
        this.firtname = firtname;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getBirthday() {
        return birthday;
    }

    public void setBirthday(String birthday) {
        this.birthday = birthday;
    }

    public String getBio() {
        return bio;
    }

    public void setBio(String bio) {
        this.bio = bio;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }
}

