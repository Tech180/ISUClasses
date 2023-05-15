package reline;

import org.mockito.Mockito;
import org.junit.Test;
import reline.users.PasswordEncoder;

import static org.mockito.AdditionalMatchers.or;
import static org.mockito.ArgumentMatchers.endsWith;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

public class TestPasswordTest {

    @Test
    public void verifyTestPassword(){
        PasswordEncoder pe = Mockito.mock(PasswordEncoder.class);

        when(pe.encode("z")).thenReturn("1");

        pe.encode("a");

        // 4: verify
        verify(pe).encode(or(eq("a"), endsWith("b")));
    }
}
