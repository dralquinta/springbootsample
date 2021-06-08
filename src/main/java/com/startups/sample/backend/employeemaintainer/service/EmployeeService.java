package com.startups.sample.backend.employeemaintainer.service;


import com.startups.sample.backend.employeemaintainer.model.Employee;
import com.startups.sample.backend.employeemaintainer.repo.EmployeeRepo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.startups.sample.backend.employeemaintainer.CustomExceptions.UserNotFoundException;


import antlr.collections.List;

@Service
public class EmployeeService {
    private final EmployeeRepo employeeRepo;

    @Autowired
    public EmployeeService(EmployeeRepo employeeRepo) {
        this.employeeRepo = employeeRepo;
    }

    public Employee addEmployee(Employee employee) {
        return employeeRepo.save(employee);
    }

    public List findAllEmployees() {
        return (List) employeeRepo.findAll();
    }

    public Employee updateEmployee(Employee employee) {
        return employeeRepo.save(employee);
    }

    public Employee findEmployeeById(Long id){
        return employeeRepo.findEmployeeById(id)
        .orElseThrow(() -> new UserNotFoundException("User with id:"+ id + " does not exists"));
    }

    public void deleteEmployee(Long id) {
        employeeRepo.deleteEmployeeById(id);
    }
}
