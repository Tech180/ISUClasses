/*
 * Copyright 2002-2013 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package reline.system;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import reline.listings.Listings;

@Api(description = "Endpoint for any runtime crash", tags = {"crash"})
@RestController
class CrashController {


    @ApiOperation(value = "Takes you to a Crash page", tags = { "crash" })
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "Success")
    })
    @RequestMapping(method = RequestMethod.GET, path = "/error")
    public String triggerException() {
        throw new RuntimeException("I'm sorry, we are uncertain of what happened. Please try putting in the correct URL because the current page could not be found!");
    }

}
