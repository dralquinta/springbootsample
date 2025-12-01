package com.startups.sample.backend.employeemaintainer.controller;

import com.startups.sample.backend.employeemaintainer.model.Employee;
import com.startups.sample.backend.employeemaintainer.service.EmployeeService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/v1/employees")
@RequiredArgsConstructor
@Tag(name = "Employee Management", description = "APIs for managing employees")
public class EmployeeResource {
    
    private final EmployeeService employeeService;

    @GetMapping
    @Operation(summary = "Get all employees", description = "Retrieve a list of all employees")
    public ResponseEntity<List<Employee>> getAllEmployees() {
        List<Employee> employees = employeeService.findAllEmployees();
        return ResponseEntity.ok(employees);
    }

    @GetMapping("/{id}")
    @Operation(summary = "Get employee by ID", description = "Retrieve an employee by their unique identifier")
    public ResponseEntity<Employee> getEmployeeById(@PathVariable("id") Long id) {
        Employee employee = employeeService.findEmployeeById(id);
        return ResponseEntity.ok(employee);
    }

    @PostMapping
    @Operation(summary = "Create a new employee", description = "Add a new employee to the system")
    public ResponseEntity<Employee> createEmployee(@Valid @RequestBody Employee employee) {
        Employee newEmployee = employeeService.addEmployee(employee);
        return ResponseEntity.status(HttpStatus.CREATED).body(newEmployee);
    }

    @PutMapping("/{id}")
    @Operation(summary = "Update an employee", description = "Update an existing employee's information")
    public ResponseEntity<Employee> updateEmployee(
            @PathVariable("id") Long id,
            @Valid @RequestBody Employee employee) {
        employee.setId(id);
        Employee updatedEmployee = employeeService.updateEmployee(employee);
        return ResponseEntity.ok(updatedEmployee);
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Delete an employee", description = "Remove an employee from the system")
    public ResponseEntity<Void> deleteEmployee(@PathVariable("id") Long id) {
        employeeService.deleteEmployee(id);
        return ResponseEntity.noContent().build();
    }
}
