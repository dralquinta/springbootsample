package com.startups.sample.backend.employeemaintainer.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class Employee implements Serializable{
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(nullable = false, updatable = false)
    private Long id; 
    private String name; 
    private String email;
    private String jobTittle;
    


    public Employee() {
    }

    public Employee(Long id, String name, String email, String jobTittle, String profilePicture) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.jobTittle = jobTittle;

    }

    public Long getId() {
        return this.id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return this.name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return this.email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getJobTittle() {
        return this.jobTittle;
    }

    public void setJobTittle(String jobTittle) {
        this.jobTittle = jobTittle;
    }

    public String getProfilePicture() {
        return this.profilePicture;
    }

    public void setProfilePicture(String profilePicture) {
        this.profilePicture = profilePicture;
    }

    public Employee id(Long id) {
        setId(id);
        return this;
    }

    public Employee name(String name) {
        setName(name);
        return this;
    }

    public Employee email(String email) {
        setEmail(email);
        return this;
    }

    public Employee jobTittle(String jobTittle) {
        setJobTittle(jobTittle);
        return this;
    }

    public Employee profilePicture(String profilePicture) {
        setProfilePicture(profilePicture);
        return this;
    }


    @Override
    public String toString() {
        return "{" +
            " id='" + getId() + "'" +
            ", name='" + getName() + "'" +
            ", email='" + getEmail() + "'" +
            ", jobTittle='" + getJobTittle() + "'" +
            ", profilePicture='" + getProfilePicture() + "'" +
            "}";
    }
    private String profilePicture;

}
