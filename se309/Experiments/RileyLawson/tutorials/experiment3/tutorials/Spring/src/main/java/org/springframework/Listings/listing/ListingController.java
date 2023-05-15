package org.springframework.Listings.listing;

import org.springframework.Listings.listing.Listings;
import org.springframework.Listings.listing.ListingsRepository;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.web.bind.annotation.*;

import java.util.*;

import java.net.MalformedURLException;
import java.net.URL;
import java.awt.*;
import javax.swing.ImageIcon;

@RestController
class ListingsController {

    @Autowired
    ListingsRepository lr;

    private final Logger logger = LoggerFactory.getLogger(ListingsController.class);

    //get all current listings in the database
    @GetMapping(path = "/listings")
    List<Listings> getAllListings(){
        return lr.findAll();
    }

    //get the listing by the id
    @GetMapping(path = "/listings/{id}")
    Listings getListingsById(@PathVariable int id){
        return lr.findById(id);
    }

    //creates the listing
    @PostMapping(path = "/listings")
    String createListing(@RequestBody Listings listings){
        if (listings == null)
            return "failure";
        lr.save(listings);
        return "success";
    }

    //updates listing
    @PutMapping(path = "/listings/{id}")
    Listings updateListing(@PathVariable int id, @RequestBody Listings request){
        Listings l = lr.findById(id);
        if(l == null)
            return null;
        lr.save(request);
        return lr.findById(id);
    }

    //sets photo in listing
    @PutMapping(path = "/listings/{id}/{i}")
    Listings setPhoto(@PathVariable Image i, @PathVariable int id){
        lr.createId(id);
        Listings newListing = new Listing(i);

        if(newListing == null){
            return "Photo was not applied... please re-upload";
        }

        newListing.setListing(i);
        lr.save(newListing);

        return "Photo has been uploaded!";
    }

    //deletes listing
    @DeleteMapping(path = "/listings/{id}")
    String deleteLaptop(@PathVariable int id){

        User user = userRepository.findById(id);
        user.setListing(null);
        userRepository.save(user);

        lr.deleteById(id);
        return "You've deleted your listing!";
    }

    //gets title
    @GetMapping(path = "listings/{id}/{title}")
    String getTitle(@PathVariable int id) {
        Listing list = lr.findById(id);
        if(list == null)
            return "Title not found";
        return list.getTitle();
    }

    @PutMapping(path = "/listings/{id}/{title}")
    Listings setTitle(@PathVariable int id, @PathVariable String title){
        Listings list = lr.findById(id);
        if(list == null)
            return "Please try again.";
        lr.setTitle(title);
        lr.save(user);
        return "Title set.";
    }

    //gets price
    @GetMapping(path = "user/{id}/getBalance")
    String getPrice(@PathVariable int id) {
        Listing list = lr.findById(id);
        if(list == null)
            return "Price not found";
        return String.format("%f", list.getPrice());
    }

}
