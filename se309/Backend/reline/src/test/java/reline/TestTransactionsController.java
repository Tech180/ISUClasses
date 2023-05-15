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
import reline.listings.ListingsRepository;
import reline.transactions.Transactions;
import reline.transactions.TransactionsController;
import reline.transactions.TransactionsRepository;
import reline.users.User;
import reline.users.UserRepository;

import java.util.*;

@RunWith(SpringRunner.class)
@WebMvcTest(TransactionsController.class)
public class TestTransactionsController {
    @Autowired
    private MockMvc controller;

    @MockBean
    private TransactionsRepository tr;

    @MockBean
    private ListingsRepository lr;

    @MockBean
    private UserRepository ur;

    @Test
    public void testTransactions() throws Exception {
        List<Listings> listings = new ArrayList<>();
        Listings listing = new Listings();
        when(lr.findAll()).thenReturn(listings);
        when(lr.findById(0)).thenReturn(java.util.Optional.of(listing));
        when(lr.save((Listings) any(Listings.class)))
            .thenAnswer(x -> {
                Listings l = x.getArgument(0);
                listings.add(l);
                return null;
        });

        List<Transactions> transactions = new ArrayList<>();
        Transactions transaction = new Transactions();
        when(tr.findAll()).thenReturn(transactions);
        when(tr.findById(1)).thenReturn(java.util.Optional.of(transaction));
        when(tr.save((Transactions) any(Transactions.class)))
            .thenAnswer(x -> {
                Transactions t = x.getArgument(0);
                transactions.add(t);
                return null;
        });
        User u1 = new User();
        User u2 = new User();
        when(ur.findById(1)).thenReturn(java.util.Optional.of(u1));
        when(ur.findById(2)).thenReturn(java.util.Optional.of(u2));

        //Post test
        //Expect success
        MvcResult result = controller.perform(post("/transactions/new/{s}/{b}/{l}", "1","2", "0")).andReturn();
        String content = result.getResponse().getContentAsString();
        assertEquals("success", content);

        transaction.setUserSelling(1);
        transaction.setUserBuying(2);

        //Expect failure for invalid listing ID
        result = controller.perform(post("/transactions/new/{s}/{b}/{l}", "0","0", "1")).andReturn();
        content = result.getResponse().getContentAsString();
        assertEquals("failure", content);

        //Get tests
        //Expect 1
        result = controller.perform(get("/transactions/{id}/getSeller", "1")).andReturn();
        content = result.getResponse().getContentAsString();
        assertEquals("1", content);

        //Expect 2
        result = controller.perform(get("/transactions/{id}/getBuyer", "1")).andReturn();
        content = result.getResponse().getContentAsString();
        assertEquals("2", content);

        //Expect 0 for invalid id
        result = controller.perform(get("/transactions/{id}/getBuyer", "0")).andReturn();
        content = result.getResponse().getContentAsString();
        assertEquals("0", content);
    }
}

