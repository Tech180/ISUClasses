package com.example.reline;

import android.content.Context;

import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.*;

public class ProfileTest {
    @Mock
    private Context context;

    @Mock
    private UsernameView view;

    @Before
    public void setUpMockito(){
        MockitoAnnotations.initMocks(this);
    }

    @Test
    public void usernameStartsWithUnderScore(){
        //test String
        String testString = "_reline";
        UsernameView usernameView = mock(UsernameView.class);
        //when
        when(usernameView.underscoreStart(testString)).thenReturn(true);
        //test
        usernameView.underscoreStart(testString);
        //verify
        verify(usernameView).underscoreStart(testString);
        //assert
        assertTrue(usernameView.underscoreStart(testString));
    }

    @Test
    public void whenUsernameEmpty_Error(){
        String testString = "";
        UsernamePresenter presenter = mock(UsernamePresenter.class);
        //UsernameView presenter = mock(UsernameView.class);
        //when
        when(presenter.emptyUsername(testString)).thenReturn(true);
        //test
        presenter.emptyUsername(testString);
        //Verify
        verify(presenter).emptyUsername(testString);
        //assert
        assertTrue(presenter.emptyUsername(testString));
    }

    @Test
    public void whenSpecialChar(){
        String testString = "r$l%ne";
        UsernamePresenter presenter = mock(UsernamePresenter.class);
        //when
        when(presenter.specialChar(testString)).thenReturn(true);
        //test
        presenter.specialChar(testString);
        //Verify
        verify(presenter).specialChar(testString);
        //assert
        assertTrue(presenter.specialChar(testString));
    }

    @Test
    public void whenMoreThanFifteen(){
        String testString = "isaacplambeckreline";
        UsernamePresenter presenter = mock(UsernamePresenter.class);
        //when
        when(presenter.moreThanFifteen(testString)).thenReturn(true);
        //test
        presenter.moreThanFifteen(testString);
        //Verify
        verify(presenter).moreThanFifteen(testString);
        //assert
        assertTrue(presenter.moreThanFifteen(testString));


    }
}
