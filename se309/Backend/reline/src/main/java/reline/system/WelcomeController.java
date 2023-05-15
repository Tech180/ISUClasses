package reline.system;


import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import reline.listings.Listings;

@Api(description = "Welcome Controller help guide you to set dummy data", tags = {"welcome"})
@RestController
class WelcomeController {

    @ApiOperation(value = "Greets you with a warm welcome", tags = { "welcome" })
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "Success")
    })
    @GetMapping("/")
    public String welcome() {
        return "Welcome</br> Go to localhost:8080/listings.Listings/create to create dummy data </br>";
    }

}
