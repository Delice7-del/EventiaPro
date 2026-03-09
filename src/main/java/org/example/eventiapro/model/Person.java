package org.example.eventiapro.model;

import java.time.LocalDate;

public class Person {

    private Integer id;
    private String firstName;
    private String lastName;
    private Gender gender;
    private LocalDate dob;

    public Person(Integer id, String firstName, String lastName, Gender gender, LocalDate dob) {
        this.id = id;
        this.firstName = firstName;
        this.lastName = lastName;
        this.gender = gender;
        this.dob = dob;
    }

    public Gender getGender() {
        return gender;
    }

    public void setGender(Gender gender) {
        this.gender = gender;
    }

    public int getAge() {
        if (dob == null)
            return 0;
        return java.time.Period.between(dob, java.time.LocalDate.now()).getYears();
    }

    public Integer getId() {
        return id;
    }

    public String getFirstName() {
        return firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public LocalDate getDob() {
        return dob;
    }
}