import org.example.eventiapro.model.Gender;
import org.example.eventiapro.model.Person;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import static org.junit.jupiter.api.Assertions.*;

public class PersonTest {
    @Test
    public void getGender() {
        Person p = new Person(1, "Rukundo", "Divin", Gender.MALE, LocalDate.now());
        assertTrue(p.getGender() == Gender.MALE);
        assertFalse(p.getGender() == Gender.FEMALE);
    }

    @Test
    public void getAge() {
        String birthdate = "10-10-2025";
        LocalDate dob = LocalDate.parse(birthdate, DateTimeFormatter.ofPattern("dd-MM-yyyy"));
        Person p = new Person(1, "Furaha", "Divin", Gender.MALE, dob);
        assertTrue(p.getAge() == 0);
        assertEquals(0, p.getAge());
    }
}