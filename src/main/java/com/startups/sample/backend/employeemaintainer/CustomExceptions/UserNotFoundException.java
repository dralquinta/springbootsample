package com.startups.sample.backend.employeemaintainer.CustomExceptions;

public class UserNotFoundException extends RuntimeException{
    


    public UserNotFoundException(String message) {
        super(message);
    }

}
