package reline.users;

import java.util.ArrayList;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import io.swagger.annotations.*;
import reline.listings.Listings;
import reline.listings.ListingsRepository;
import reline.transactions.Transactions;
import reline.transactions.TransactionsRepository;

@Api("Endpoints for creating and accessing values stored for each user.")
@RestController
public class UserController {

    @Autowired
    UserRepository userRepository;

    @Autowired
    ListingsRepository listingsRepository;

    @Autowired
    TransactionsRepository transactionsRepository;

    @ApiOperation(value = "Get a list of all user objects stored in the database.", tags = "user")
    @GetMapping("users")
    List<User> GetAllUsers() {
        return userRepository.findAll();
    }

    @GetMapping(path = "users/{id}")
    User getUser(@PathVariable Integer id){
        if(userRepository.findById(id).isPresent()) {
            return userRepository.findById(id).get();
        }
        return null;
    }

    @GetMapping("users/getIds")
    List<Integer> GetAllIds() {
        List<User> users = userRepository.findAll();
        List<Integer> ids = new ArrayList();
        for(int i = 0; i < users.size(); i++) {
            ids.add(users.get(i).getId());
        }
        return ids;
    }

    @ApiOperation(value = "Create a new user with the username and password values passed in.", tags = "user")
    @PostMapping("users/new/{u}/{p}")
    String PostNewUser(@PathVariable String u, @PathVariable String p){
        try {
            User newUser = new User();
            newUser.setUsername(u);
            newUser.setPassword(p);
            newUser.addBalance(0);
            newUser.setFollowers("");
            newUser.setFollowing("");
            newUser.setType("User");
            userRepository.save(newUser);
            return login(u, p);
        } catch(Exception e) {
            return "failure";
        }
    }

    @ApiOperation(value = "Delete the user with a certain ID.", tags = "user")
    @DeleteMapping("users/delete/{id}")
    String deleteUser(@PathVariable Integer id) {
        try {
            userRepository.deleteById(id);
            return "success";
        } catch(Exception e) {
            return "failure";
        }
    }

    @ApiOperation(value = "Verify that the username and password passed in are equivalent to a user's in the database.", tags = "user")
    @GetMapping("users/login/{u}/{p}")
    String login(@PathVariable String u, @PathVariable String p) {
        List<User> allUsers = userRepository.findAll();
        for(int i = 0; i < allUsers.size(); i++) {
            String email = allUsers.get(i).getUsername();
            if(email.equals(u)) {
                User loginUser = allUsers.get(i);
                String pass = loginUser.getPassword();
                if(pass.equals(p)) {
                    return String.valueOf(loginUser.getId());
                }
                break;
            }
        }
        return "failure";
    }

    @ApiOperation(value = "Get the username from the user with the given ID.", tags = "user")
    @GetMapping("users/{id}/getUsername")
    String getUsername(@PathVariable Integer id) {
        if (userRepository.findById(id).isPresent()){
            User user = userRepository.findById(id).get();
            return user.getUsername();
        }
        return "failure";

    }

    @ApiOperation(value = "Set the username of a user by providing the ID.", tags = "user")
    @PutMapping("users/{id}/setUsername/{u}")
    String setUsername(@PathVariable Integer id, @PathVariable String u){
        if (userRepository.findById(id).isPresent()) {
            User user = userRepository.findById(id).get();
            user.setUsername(u);
            userRepository.save(user);
            return "success";
        }
        return "failure";


    }

    @ApiOperation(value = "Get password of the user with the given ID.", tags = "user")
    @GetMapping("users/{id}/getPassword")
    String getPassword(@PathVariable Integer id) {
        if (userRepository.findById(id).isPresent()){
            User user = userRepository.findById(id).get();
            String pass = user.getPassword();
            return pass;
        }
        return "failure";

    }

    @ApiOperation(value = "Get balance of the user with the given ID.", tags = "user")
    @GetMapping("users/{id}/getBalance")
    String getBalance(@PathVariable Integer id) {
        if (userRepository.findById(id).isPresent()){
            User user = userRepository.findById(id).get();
            return String.format("%.2f", user.getBalance());
        }
        return "failure";

    }

    @ApiOperation(value = "Add a float value to a user's balance.", tags = "user")
    @PutMapping("users/{id}/addBalance/{b}")
    String addBalance(@PathVariable Integer id, @PathVariable float b){
        if (userRepository.findById(id).isPresent()){
            User user = userRepository.findById(id).get();
            user.addBalance(b);
            userRepository.save(user);
            return "success";
        }
        return "failure";
    }

    @ApiOperation(value = "Subtract a float value from a user's balance.", tags = "user")
    @PutMapping("users/{id}/subBalance/{b}")
    String subBalance(@PathVariable Integer id, @PathVariable float b){
        if (userRepository.findById(id).isPresent()){
            User user = userRepository.findById(id).get();
            user.subBalance(b);
            userRepository.save(user);
            return "success";
        }
        return "failure";
    }

    @PutMapping("users/{id}/setAdmin")
    String setAdmin(@PathVariable Integer id) {
        if (userRepository.findById(id).isPresent()){
            User user = userRepository.findById(id).get();
            user.setType("Admin");
            userRepository.save(user);
            return "success";
        }
        return "failure";
    }

    @PutMapping("users/{id}/setUser")
    String setUser(@PathVariable Integer id) {
        if (userRepository.findById(id).isPresent()){
            User user = userRepository.findById(id).get();
            user.setType("User");
            userRepository.save(user);
            return "success";
        }
        return "failure";
    }

    @PutMapping("users/{id}/setPaid")
    String setPaid(@PathVariable Integer id) {
        if (userRepository.findById(id).isPresent()){
            User user = userRepository.findById(id).get();
            if(user.getBalance() >= 10) {
                user.setType("Paid");
                user.subBalance(10);
                userRepository.save(user);
                List<Listings> listings = getListings(id);
                for(int i = 0; i < listings.size(); i++) {
                    listings.get(i).setBumped("true");
                    listingsRepository.save(listings.get(i));
                }
                return "success";
            }
        }
        return "failure";
    }

    @GetMapping("users/{id}/getListings")
    List<Listings> getListings(@PathVariable Integer id) {
        if (userRepository.findById(id).isPresent()){
            List<Listings> list = listingsRepository.findAll();
            for(int i = 0; i < list.size(); i++) {
                if(list.get(i).getUid() != id) {
                    list.remove(i);
                    i--;
                }
            }
            return list;
        }
        return null;
    }

    @GetMapping("users/{id}/getTransactions")
    List<Transactions> getTransactions(@PathVariable Integer id) {
        if (userRepository.findById(id).isPresent()){
            List<Transactions> list = transactionsRepository.findAll();
            for(int i = 0; i < list.size(); i++) {
                if(list.get(i).getUserBuying() != id && list.get(i).getUserSelling() != id) {
                    list.remove(i);
                    i--;
                }
            }
            return list;
        }
        return null;
    }

    @GetMapping(path = "users/search/{s}")
    List<User> search(@PathVariable String s) {
        List<User> list = userRepository.findAll();
        for(int i = 0; i < list.size(); i++) {
            if(!list.get(i).getUsername().toLowerCase().contains(s.toLowerCase())) {
                list.remove(i);
                i--;
            }
        }
        return list;
    }
}
