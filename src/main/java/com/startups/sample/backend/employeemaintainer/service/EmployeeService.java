package com.startups.sample.backend.employeemaintainer.service;

import com.startups.sample.backend.employeemaintainer.CustomExceptions.UserNotFoundException;
import com.startups.sample.backend.employeemaintainer.model.Employee;
import com.startups.sample.backend.employeemaintainer.repo.EmployeeRepo;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
@Transactional
public class EmployeeService {
    
    private final EmployeeRepo employeeRepo;

    public Employee addEmployee(Employee employee) {
        log.info("Adding new employee: {}", employee.getName());
        return employeeRepo.save(employee);
    }

    public List<Employee> findAllEmployees() {
        log.info("Fetching all employees");
        return employeeRepo.findAll();
    }

    public Employee updateEmployee(Employee employee) {
        log.info("Updating employee with id: {}", employee.getId());
        findEmployeeById(employee.getId()); // Verify employee exists
        return employeeRepo.save(employee);
    }

    public Employee findEmployeeById(Long id) {
        log.info("Finding employee with id: {}", id);
        return employeeRepo.findById(id)
                .orElseThrow(() -> new UserNotFoundException("Employee with id: " + id + " not found"));
    }

    public void deleteEmployee(Long id) {
        log.info("Deleting employee with id: {}", id);
        findEmployeeById(id); // Verify employee exists before deleting
        employeeRepo.deleteById(id);
    }
}
