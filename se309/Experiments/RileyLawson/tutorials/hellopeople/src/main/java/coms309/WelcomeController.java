package coms309;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Random;
/**
 * Simple Hello World Controller to display the string returned
 *
 * @author Vivek Bengre
 */

@RestController
class WelcomeController {

    int count = 1;
    private String month;
    private String stone;

    //Random r - new Random();

    //int random = r.nextInt(13);

    @GetMapping("/")
    public String welcome() {
        return "Hello and welcome! Please enter /crystal";
    }


	/*
	@PostMapping("/postTest2")
	public String postTest2(@RequestBody TestData testData) {
		//TODO
		return String.format("Hello, %s! You sent a post request with a requestbody!", testData.getMessage());
	}
    */

	@GetMapping("/crystal")
	public String crystal() {

	this.count = count;

        switch(count) {
            case 2:
                month = "January";
                stone = "Garnet";
                count++;
                break;
            case 3:
                month = "February";
                stone = "Amethyst";
                count++;
                break;
            case 4:
                month = "March";
                stone = "Aquamarine";
                count++;
                break;
            case 5:
                month = "April";
                stone = "Diamond";
                count++;
                break;
            case 6:
                month = "May";
                stone = "Emerald";
                count++;
                break;
            case 7:
                month = "June";
                stone = "Alexandrite";
                count++;
                break;
            case 8:
                month = "July";
                stone = "Ruby";
                count++;
                break;
            case 9:
                month = "August";
                stone = "Peridot";
                count++;
                break;
            case 10:
                month = "September";
                stone = "Sapphire";
                count++;
                break;
            case 11:
                month = "October";
                stone = "Tourmaline";
                count++;
                break;
            case 12:
                month = "November";
                stone = "Golden Topaz";
                count++;
                break;
            case 13:
                month = "December";
                stone = "Tanzanite";
                count++;
                break;
            default:
                if (count < 13) {
                    month = "Please refresh the page to see the month and its corresponding birthstone... ";
                    stone = "I am a stone";
                    count++;
                }
                else {
                    count = 14;
                    month = "all done ";
                    stone = "don't even worry about it";
                }
                break;
        }

            return String.format("You've grown " + (count - 2) + " crystal(s)! Month: " + month + " and the Birthstone: " + stone);
	}
}
