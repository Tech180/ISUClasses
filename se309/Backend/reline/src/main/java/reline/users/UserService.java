package reline.users;

public class UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public UserService(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    public boolean isValidUser(String id, String password) {

        User user = null;
        
//        if (userRepository.findById(Integer.valueOf(id)).isPresent()) {
//            user = userRepository.findById(Integer.valueOf(id)).get();
//
//            return isEnabledUser(user); //&& isValidPassword(user, password);
//        }

        return false;
    }

//    private boolean isEnabledUser(User user) {
//        return user != null && user.switched(true);
//    }


    /*
    private boolean isValidBalance(User user, String password) {
        String aBalance =
    }
    */


}