package reline;

import org.mockito.Mockito;
import org.junit.Test;
import reline.users.PasswordEncoder;

import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;
import static org.mockito.AdditionalMatchers.or;


public class PasswordEncoderMockTest {

    @Test
    public void mock() {
        PasswordEncoder pe = Mockito.mock(PasswordEncoder.class);
    }

}
