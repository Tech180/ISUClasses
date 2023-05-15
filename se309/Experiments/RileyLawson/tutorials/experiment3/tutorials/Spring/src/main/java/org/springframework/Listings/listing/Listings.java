package org.springframework.Listings.listing;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.NotFound;
import org.hibernate.annotations.NotFoundAction;
import org.springframework.core.style.ToStringCreator;

import java.net.MalformedURLException;
import java.net.URL;
import java.awt.*;
import javax.swing.ImageIcon;

@Entity
@Table(name = "listings")
public class Listings {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    @NotFound(action = NotFoundAction.IGNORE)
    private int id;

    @Column(name = "pictures")
    @NotFound(action = NotFoundAction.IGNORE)
    private Image pictures;

    @Column(name = "title")
    @NotFound(action = NotFoundAction.IGNORE)
    private String title;

    @Column(name = "price")
    @NotFound(action = NotFoundAction.IGNORE)
    private double price;

    @Column(name = "description")
    @NotFound(action = NotFoundAction.IGNORE)
    private String description;

    @Column(name = "telephone")
    @NotFound(action = NotFoundAction.IGNORE)
    private String telephone;

    @Column(name = "bumbed")
    @NotFound(action = NotFoundAction.IGNORE)
    private String bumbed;

    @Column(name = "hidden")
    @NotFound(action = NotFoundAction.IGNORE)
    private boolean hidden;


    //constructor
    public Listings(){
        
    }

    //get an image
    URL image = new URL("");
    // image is null when not found
    ImageIcon icon = new ImageIcon(image);
    Image i = icon.getImage();

    public Listings(Image i, String title, double price, String description, String telephone, String bumbed, boolean hidden){
        this.id = id;
        this.i = image;
        this.title = title;
        this.price = price;
        this.description = description;
        this.telephome = telephone;
        this.bumbed = bumbed;
        this.hidden = hidden;
    }


    //Getters and Setters

    //Pictures
    public Image getPictures() {
        return this.i;
    }

    public Image setPictures() {
        this.i = image;
    }

    //title
    public String getTitle() {
        return this.title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    //price
    public double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    //Description
    public String getDescription() {
        return this.description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    //bumbed
    public String bumbed() {
        return this.bumbed;
    }

    public void bumbed(String bumbed) {
        this.bumbed = bumbed;
    }

    //telephone
    public String getTelephone() {
        return this.telephone;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }

    //hidden
    public boolean getHidden() {
        return this.hidden;
    }

    public void setHidden(String hidden) {
        this.hidden = hidden;
    }

    @Override
    public String toString() {
        return new ToStringCreator(this)
                .append("telephone", this.telephone).toString();
    }
}
