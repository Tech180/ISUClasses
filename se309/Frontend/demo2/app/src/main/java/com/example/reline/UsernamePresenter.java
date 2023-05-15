package com.example.reline;

import android.content.Context;

public class UsernamePresenter {
    //private RequestServerForService model;

    private UsernameView view;
    private Context context;

    //Everything should be static to work with Settings.java, remove static for Mockito Testing.

    public static boolean emptyUsername(String username){
        //view.showError();
        if(username.equals("")){
            //view.showError();
            //view.setError("Username is Empty");
            return true;
        }
        else{
            //view.hideError();
            return false;
        }
    }

    public static boolean correctUsername(String username){
        if(!emptyUsername(username) && !underscoreStart(username) && !specialChar(username) && !moreThanFifteen(username)){
            return true;
        }
        else{
            return false;
        }
    }


    public static boolean underscoreStart(String username){
        if(username.charAt(0) == '_'){
            //view.showError();
            //view.setError("Username starts with underscore");
            return true;
        }
        else{
            //view.hideError();
            return false;
        }
    }


    public static boolean specialChar(String username){
        for(int i = 0; i < username.length(); i++){
            if(username.charAt(i) == '$' || username.charAt(i) == '%' || username.charAt(i) == '#' || username.charAt(i) == '*' || username.charAt(i) == '&'){
                return true;
            }
        }
        return false;
    }


    public static boolean moreThanFifteen(String username){
        if(username.length() > 15){
            return true;
        }
        else{
            return false;
        }
    }

}
