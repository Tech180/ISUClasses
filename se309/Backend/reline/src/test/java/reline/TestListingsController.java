package reline;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.junit.Assert.*;
import static org.mockito.Mockito.when;
import static org.mockito.Mockito.any;
import org.springframework.test.web.servlet.MvcResult;
import reline.listings.Listings;
import reline.listings.ListingsController;
import reline.listings.ListingsRepository;
import reline.users.UserRepository;

import java.util.*;

@RunWith(SpringRunner.class)
@WebMvcTest(ListingsController.class)
public class TestListingsController {
    @Autowired
    private MockMvc controller;

    @MockBean
    private ListingsRepository lr;

    @MockBean
    private UserRepository ur;

    @Test
    public void testListings() throws Exception {
        List<Listings> listings = new ArrayList<Listings>();
        Listings listing = new Listings();
        when(lr.findAll()).thenReturn(listings);
        when(lr.findById(0)).thenReturn(java.util.Optional.of(listing));
        when(lr.save((Listings)any(Listings.class)))
            .thenAnswer(x -> {
                Listings l = x.getArgument(0);
                listings.add(l);
                return null;
        });

        //Constructor tests

        //expect success
//        MvcResult result = controller.perform(post("/listings/new/{uid}/{t}/{p}/{d}", 69,"title", "0", "test")).andReturn();
//        String content = result.getResponse().getContentAsString();
//        assertEquals("success",content);
//
//        //expect failure with String price parameter
//        result = controller.perform(post("/listings/new/{uid}/{t}/{p}/{d}", 69, "title", "notafloat", "test")).andReturn();
//        content = result.getResponse().getContentAsString();
//        assertEquals("failure",content);

        //Set tests

        //expect success
        MvcResult result = controller.perform(put("/listings/{id}/setTitle/{t}", "0", "title")).andReturn();
        String content = result.getResponse().getContentAsString();
        assertEquals("success",content);

        //expect failure, id is not valid
        result = controller.perform(put("/listings/{id}/setTitle/{t}", "9", "title")).andReturn();
        content = result.getResponse().getContentAsString();
        assertEquals("failure",content);

        //Get tests

        //expect title of listing that we set above, "title"
        result = controller.perform(get("/listings/{id}/getTitle", "0")).andReturn();
        content = result.getResponse().getContentAsString();
        assertEquals("title",content);

        //expect failure, id is not valid
        result = controller.perform(get("/listings/{id}/getTitle", "9")).andReturn();
        content = result.getResponse().getContentAsString();
        assertEquals("failure",content);

        //Delete tests

        //expect success
        result = controller.perform(delete("/listings/delete/{id}", "0")).andReturn();
        content = result.getResponse().getContentAsString();
        assertEquals("success",content);

        //expect failure, id is not valid
        result = controller.perform(delete("/listings/delete/{id}", "9")).andReturn();
        content = result.getResponse().getContentAsString();
        assertEquals("failure",content);
    }
}
