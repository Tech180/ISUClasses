package com.example.reline;

import static org.junit.Assert.assertTrue;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import android.content.Context;

import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

public class MockTest {
    @Mock
    private Context context;

    @Mock
    private UsernameView view;

    @Before
    public void setUpMockito(){
        MockitoAnnotations.initMocks(this);
    }

    @Test
    public void notEnoughBalance(){

        Double currBalance = 50.00;
        Double listingPrice = 10.00;

        Balance balance = mock(Balance.class);

        when(balance.checkFunds(currBalance, listingPrice)).thenReturn(true);

        Boolean result = balance.checkFunds(currBalance, listingPrice);

        assertTrue(result);


    }


    @Test
    public void makePremium(){

        Double currBalance = 15.00;
        String status = "User";

        Profile profile = mock(Profile.class);

        when(profile.makePremium(currBalance, status)).thenReturn(true);
        Boolean result = profile.makePremium(currBalance, status);

        assertTrue(result);




    }



}
