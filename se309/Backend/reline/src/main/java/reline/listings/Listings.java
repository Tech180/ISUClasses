package reline.listings;

import javax.persistence.*;

@Entity
public class Listings {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    private Integer uid;
    private String username;
    private String bumped;
    private String description;
    private float price;
    private String title;
    private String hidden;

    //constructor
    public Listings(){

    }


    //Getters and Setters
    public Integer getId() {
        if(id != null) {
            return id;
        }
        return 0;
    }

    public void setUid(Integer uid) {
        this.uid = uid;
    }

    public Integer getUid() {
        if(uid == null) {
            return 0;
        }
        return uid;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getUsername() {
        return username;
    }

    //title
    public String getTitle() {
        return this.title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    //price
    public float getPrice() {
        return price;
    }

    public void setPrice(float price) {
        this.price = price;
    }

    //Description
    public String getDescription() {
        return this.description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    //bumped
    public String getBumped() {
        return this.bumped;
    }

    public void setBumped(String bumped) {
        this.bumped = bumped;
    }

    public String getHidden() { return hidden; }

    public void setHidden(String hidden) { this.hidden = hidden; }
}