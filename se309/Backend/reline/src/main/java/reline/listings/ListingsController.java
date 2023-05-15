package reline.listings;

import io.swagger.annotations.*;
import org.springframework.beans.factory.annotation.Autowired;


import org.springframework.web.bind.annotation.*;
import reline.users.User;
import reline.users.UserRepository;

import java.util.*;


@Api("Endpoints for creating, retrieving, updating, and deleting listings / creates and retrieves titles / creates and retrieves price")
@RestController
public class ListingsController {

    @Autowired
    ListingsRepository lr;

    @Autowired
    UserRepository ur;

    @ApiOperation(value = "Get all current listings in the database", notes = "finds all listings", tags = { "listing" })
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "success!", response= List.class )
    })
    //get all current listings in the database
    @GetMapping(path = "listings")
    List<Listings> getAllListings(){
        List<Listings> list = lr.findAll();
        for(int i = 0; i < list.size(); i++) {
            Listings listing = list.get(i);
            if(listing.getBumped().equals("true")) {
                list.remove(i);
                list.add(0, listing);
            }
        }
        return list;
    }

    @ApiOperation(value = "Retrieves the listing by the id", notes = "get id", tags = { "listing" })
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "success", response=Listings.class),
            @ApiResponse(code = 404, message = "Listing not found")
    })
    //get the listing by the id
    @GetMapping(path = "listings/{id}")
    Listings getListingsById(@ApiParam("ID of the listing, Error if empty") @PathVariable Integer id){
        if(lr.findById(id).isPresent()) {
            return lr.findById(id).get();
        }
        return null;
    }

    @ApiOperation(value = "Creates a new listing", tags = { "listing" })
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "Success", response=Listings.class),
            @ApiResponse(code = 404, message = "Invalid listing"),
            @ApiResponse(code = 409, message = "Listing already exists")
    })
    //creates the listing
    @PostMapping(path = "listings/new/{uid}/{t}/{p}/{d}")
    String createListing(@PathVariable Integer uid, @PathVariable String t, @PathVariable String p, @PathVariable String d){
        try {
            float price = Float.parseFloat(p);
            if(uid == null || t == null || d == null || ur.findById(uid).isPresent() == false) {
                throw new Exception();
            }
            User u = ur.findById(uid).get();
            Listings newListing = new Listings();
            newListing.setUid(uid);
            String username = u.getUsername();
            newListing.setUsername(username);
            newListing.setTitle(t);
            newListing.setPrice(price);
            newListing.setDescription(d);
            newListing.setHidden("false");
            String bumped = u.getType().equals("Paid") ? "true" : "false";
            newListing.setBumped(bumped);
            lr.save(newListing);
            return "success";
        } catch(Exception error) {
            return "failure";
        }
    }

    @ApiOperation(value = "Deletes a listing", tags = { "listing" })
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "Success", response=Listings.class),
            @ApiResponse(code = 404, message = "Listings not found")

    })

    //deletes listing
    @DeleteMapping(path = "listings/delete/{id}")
    String deleteListing(@PathVariable Integer id){
        try {
            if(lr.findById(id).isPresent() == false) {
                throw new Exception();
            }
            lr.deleteById(id);
            return "success";
        } catch(Exception e) {
            return "failure";
        }
    }

    @ApiOperation(value = "Retrieves the title of the listing ", tags = { "listing" })
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "Success", response = Listings.class)

    })

    @GetMapping(path = "listings/{id}/getUid")
    String getUid(@PathVariable Integer id) {
        if(lr.findById(id).isPresent()) {
            Listings list = lr.findById(id).get();
            if(list.getUid() != 0) {
                return list.getUid().toString();
            }
        }
        return "failure";

    }

    @GetMapping(path = "listings/{id}/getUsername")
    String getUsername(@PathVariable Integer id) {
        if(lr.findById(id).isPresent()) {
            Listings list = lr.findById(id).get();
            return list.getUsername();
        }
        return "failure";

    }

    //gets title
    @GetMapping(path = "listings/{id}/getTitle")
    String getTitle(@PathVariable Integer id) {
        if(lr.findById(id).isPresent()) {
            Listings list = lr.findById(id).get();
            return list.getTitle();
        }
        return "failure";

    }

    @ApiOperation(value = "Updates a listing", tags = { "listing" })
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "Success", response = Listings.class),
            @ApiResponse(code = 400, message = "Invalid ID"),
            @ApiResponse(code = 404, message = "Listing not found"),
            @ApiResponse(code = 405, message = "Listing not valid")
    })
    //sets title
    @PutMapping(path = "listings/{id}/setTitle/{title}")
    String setTitle(@PathVariable Integer id, @PathVariable String title){
        if(lr.findById(id).isPresent()) {
            Listings list = lr.findById(id).get();
            list.setTitle(title);
            lr.save(list);
            return "success";
        }
        return "failure";

    }

    @ApiOperation(value = "Retrieves the price", tags = { "listing" })
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "Success", response = Listings.class)
    })
    //gets price
    @GetMapping(path = "listings/{id}/getPrice")
    String getPrice(@PathVariable Integer id) {
        if(lr.findById(id).isPresent()) {
            Listings list = lr.findById(id).get();
            return String.format("%.2f", list.getPrice());
        }
        return "failure";

    }

    @ApiOperation(value = "Updates the price", tags = { "listing" })
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "Success", response = Listings.class),
            @ApiResponse(code = 400, message = "Invalid ID"),
            @ApiResponse(code = 404, message = "Price not found"),
            @ApiResponse(code = 405, message = "Price not valid")
    })
    //sets price
    @PutMapping("users/{id}/setPrice/{p}")
    String setPrice(@PathVariable Integer id, @PathVariable float p){
        if (lr.findById(id).isPresent()){
            Listings listing = lr.findById(id).get();
            listing.setPrice(p);
            lr.save(listing);
            return "success";
        }
        return "failure";
    }

    @ApiOperation(value = "Creates a description of the listing", tags = { "listing" })
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "Success", response = Listings.class)
    })
    //creates a description of the product
    @GetMapping(path = "listings/{id}/getDesc")
    String getDesc(@PathVariable Integer id) {
        if(lr.findById(id).isPresent()) {
            Listings list = lr.findById(id).get();
            return list.getDescription();
        }
        return "failure";

    }

    @ApiOperation(value = "Updates the description of the listing", tags = { "listing" })
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "Success", response = Listings.class),
            @ApiResponse(code = 400, message = "Invalid ID"),
            @ApiResponse(code = 404, message = "Description not found"),
            @ApiResponse(code = 405, message = "Description not valid")
    })
    @PutMapping(path = "listings/{id}/setDesc/{d}")
    String setDesc(@PathVariable Integer id, @PathVariable String d){
        if(lr.findById(id).isPresent()) {
            Listings list = lr.findById(id).get();
            list.setTitle(d);
            lr.save(list);
            return "success";
        }
        return "failure";

    }

    @GetMapping(path = "listings/{id}/getHidden")
    String getHidden(@PathVariable Integer id) {
        if(lr.findById(id).isPresent()) {
            Listings list = lr.findById(id).get();
            return list.getHidden();
        }
        return "failure";
    }

    @GetMapping(path = "listings/search/{s}")
    List<Listings> search(@PathVariable String s) {
        List<Listings> list = lr.findAll();
        for(int i = 0; i < list.size(); i++) {
            if(!list.get(i).getTitle().toLowerCase().contains(s.toLowerCase()) && !list.get(i).getDescription().toLowerCase().contains(s.toLowerCase())) {
                list.remove(i);
                i--;
            }
        }
        return list;
    }
}

