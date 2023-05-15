package reline;

import org.aspectj.lang.annotation.Before;
//import org.junit.Before;
//import org.junit.Test;
import org.mockito.ArgumentCaptor;
import org.mockito.InOrder;
import org.mockito.Mock;
import org.testng.annotations.Test;
import reline.users.PasswordEncoder;
import reline.users.User;
import reline.users.UserRepository;
import reline.users.UserService;

//import static org.junit.Assert.*;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;
/*
    public class UserServiceTest {

        private static final String PASSWORD = "password";

        //private static final String BALANCE = "balance";
        //private static final User ENABLED_USER = new User("user id", "hash", true);
        private static final User ENABLED_USER = new User("username", "name", "email", "password");
        //private static final User DISABLED_USER = new User("disabled user id", "disabled user password hash", false);
        private static final User DISABLED_USER = new User("disabled username", "disabled name", "disabled email", "disabled user password");

        @Mock
        private UserRepository userRepository;

        @Mock
        private PasswordEncoder passwordEncoder;

        @Mock
        private UserService userService;

        //@Before //("")
        public void setup() {
            userRepository = createUserRepository();
            passwordEncoder = createPasswordEncoder();
            userService = new UserService(userRepository, passwordEncoder);
        }

        @Test
        public void shouldBeValidForValidCredentials() {
            boolean userIsValid = userService.isValidUser(Integer.toString(ENABLED_USER.getId()), PASSWORD);
            assertTrue(userIsValid);

            //id="user id"
            verify(userRepository).findById(ENABLED_USER.getId());

            verify(passwordEncoder).encode(PASSWORD);
        }

        @Test
        public void shouldBeInvalidForInvalidId() {
            boolean userIsValid = userService.isValidUser("invalid id", PASSWORD);
            assertFalse(userIsValid);

            InOrder inOrder = inOrder(userRepository, passwordEncoder);
            inOrder.verify(userRepository).findById(Integer.valueOf("invalid id"));
            inOrder.verify(passwordEncoder, never()).encode(anyString());
        }

        @Test
        public void shouldBeInvalidForInvalidPassword() {
            boolean userIsValid = userService.isValidUser(Integer.toString(ENABLED_USER.getId()), "invalid");
            assertFalse(userIsValid);

            ArgumentCaptor<String> passwordCaptor = ArgumentCaptor.forClass(String.class);
            verify(passwordEncoder).encode(passwordCaptor.capture());
            assertEquals("invalid", passwordCaptor.getValue());
        }


        @Test
        public void shouldBeInvalidForDisabledUser() {
            boolean userIsValid = userService.isValidUser(Integer.toString(DISABLED_USER.getId()), PASSWORD);
            assertFalse(userIsValid);

            verify(userRepository).findById(DISABLED_USER.getId());
            //verifyZeroInteractions(passwordEncoder);
        }


        /*
        public void shouldBeValidForValidBalance() {
            boolean balanceIsValid = userService.isValidBalance(Integer.toString(ENABLED_USER.getId()), "invalid");
            assertFalse(balanceIsValid);

            ArgumentCaptor<String> balanceCaptor = ArgumentCaptor.forClass(String.class);
            //verify(passwordEncoder).encode(passwordCaptor.capture());
            assertEquals("invalid", balanceCaptor.getValue());
        }
         */
/*
        private PasswordEncoder createPasswordEncoder() {
            PasswordEncoder mock = mock(PasswordEncoder.class);
            when(mock.encode(anyString())).thenReturn("any password hash");
            when(mock.encode(PASSWORD)).thenReturn(ENABLED_USER.getPassword());
            return mock;
        }

        private UserRepository createUserRepository() {
            UserRepository mock = mock(UserRepository.class);
            when(mock.findById(ENABLED_USER.getId())).thenReturn(java.util.Optional.of(ENABLED_USER));
            when(mock.findById(DISABLED_USER.getId())).thenReturn(java.util.Optional.of(DISABLED_USER));
            return mock;
        }
}
*/
