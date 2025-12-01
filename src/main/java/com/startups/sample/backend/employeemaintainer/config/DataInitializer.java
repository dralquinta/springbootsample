package com.startups.sample.backend.employeemaintainer.config;

import com.startups.sample.backend.employeemaintainer.model.Employee;
import com.startups.sample.backend.employeemaintainer.repo.EmployeeRepo;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

/**
 * Data Initializer Component
 * Automatically seeds mock employee data on application startup
 */
@Component
@RequiredArgsConstructor
@Slf4j
public class DataInitializer implements CommandLineRunner {

    private final EmployeeRepo employeeRepo;

    @Override
    public void run(String... args) throws Exception {
        log.info("Initializing mock employee data...");

        // Clear existing data
        employeeRepo.deleteAll();

        // Create mock employees
        Employee emp1 = Employee.builder()
                .name("John Smith")
                .email("john.smith@company.com")
                .jobTitle("Senior Software Engineer")
                .profilePicture("https://via.placeholder.com/150?text=John")
                .build();

        Employee emp2 = Employee.builder()
                .name("Maria Garcia")
                .email("maria.garcia@company.com")
                .jobTitle("Product Manager")
                .profilePicture("https://via.placeholder.com/150?text=Maria")
                .build();

        Employee emp3 = Employee.builder()
                .name("David Chen")
                .email("david.chen@company.com")
                .jobTitle("DevOps Engineer")
                .profilePicture("https://via.placeholder.com/150?text=David")
                .build();

        Employee emp4 = Employee.builder()
                .name("Sarah Wilson")
                .email("sarah.wilson@company.com")
                .jobTitle("UX/UI Designer")
                .profilePicture("https://via.placeholder.com/150?text=Sarah")
                .build();

        Employee emp5 = Employee.builder()
                .name("Robert Johnson")
                .email("robert.johnson@company.com")
                .jobTitle("QA Lead")
                .profilePicture("https://via.placeholder.com/150?text=Robert")
                .build();

        // Save all employees
        employeeRepo.saveAll(java.util.List.of(emp1, emp2, emp3, emp4, emp5));

        log.info("✓ Mock data initialized: 5 employees loaded");
    }
}
