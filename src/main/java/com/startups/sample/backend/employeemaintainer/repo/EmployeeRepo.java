package com.startups.sample.backend.employeemaintainer.repo;

import java.util.Optional;

import com.startups.sample.backend.employeemaintainer.model.Employee;

import org.springframework.data.jpa.repository.JpaRepository;

public interface EmployeeRepo extends JpaRepository<Employee, Long> {

    void deleteEmployeeById(Long id);

    Optional<Employee> findEmployeeById(Long id);
    
}
