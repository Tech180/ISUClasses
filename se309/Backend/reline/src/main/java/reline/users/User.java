package reline.users;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;


@Entity
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    private float balance;
    private String password;
    private String username;
    private String following;
    private String followers;
    private String type;

    public User() {
    }

    public User(String name, String email, String password) {

        this.password = password;
        this.balance = 0;
    }

    public String getUsername(){
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public Integer getId() {
        if(id != null) {
            return id;
        }
        return 0;
    }

    public String getPassword() { return password; }

    public void setPassword(String pass) { this.password = pass; }

    public float getBalance() {
        return balance;
    }

    public float addBalance(float addition) { this.balance = balance + addition;
        return balance; }

    public float subBalance(float addition) { this.balance = balance - addition;
        return balance; }

    public void setFollowers(String follower) {
        this.followers = follower;
    }

    public void setFollowing(String following) {
        this.following = following;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getType() {
        return type;
    }

}
