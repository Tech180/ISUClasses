package coms309;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.*;

/**
 * Simple Hello World Controller to display the string returned
 *
 * @author Vivek Bengre
 */

@RestController
class WelcomeController {

    int c = 0;

    List names = new ArrayList();

    @GetMapping("/")
    public String welcome() {
        return "Please redirect yourself to /help";
    }

    @GetMapping("/help")
	public String help(@RequestParam(value = "username", defaultValue = "help") String message) {
		return String.format("Hello, %s! Congrats you are officially a helper! Head to /helper! If you need help redirect yourself to /help/please", message);
	}

    @GetMapping("/helper")
	public String helper(@RequestParam(value = "username", defaultValue = "helper") String message) {

        this.c++;
		return String.format("Hello you are one of " + (this.c - 1) + " number of helpers... to register please go to /helper/*insert your name here* and here are the generous helpers -> " + names, message);
	}

    @RequestMapping("/help/please")
    public String helpless() {
        return "You got help! Huzzah you're all better now!!!";
    }

    /*
    @RequestMapping("/helper/setup")
    @ResponseBody
    public List helperSetup() {
        List names = new ArrayList();


        return names;
        //String.format("Your name is now recorded and will be documented as a helper! Thank you for your contribution!!! There will be a max of 50 helpers");
    }
    */

    @RequestMapping("/helper/{thehelper}")
    @ResponseBody
    public List helperName(@PathVariable String thehelper) {

        names.add(thehelper);

        helper(thehelper);

        return names;
        //String.format("Your name is now recorded and will be documented as a helper! Thank you for your contribution!!! There will be a max of 50 helpers");
    }

    @RequestMapping("/helpers")
    @ResponseBody
    public List helpers() {
        return names;
        //String.format("Your name is now recorded and will be documented as a helper! Thank you for your contribution!!! There will be a max of 50 helpers");
    }

    @PostMapping("/post")
    public @ResponseBody ResponseEntity<String> post() {
        return new ResponseEntity<String>("POST Response", HttpStatus.OK);
    }
}
