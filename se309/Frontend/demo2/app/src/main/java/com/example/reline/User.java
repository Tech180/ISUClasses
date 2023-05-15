package com.example.reline;

import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.toolbox.JsonArrayRequest;

import org.json.JSONArray;

public class User {

    private String URL ="http://coms-309-066.cs.iastate.edu:8080/";


    //balance
    private double balance;
    public void setBalance(double balance) {

        /*
        JsonArrayRequest jsonRequest = new JsonArrayRequest(Request.Method.POST, URL + "users/1/setBalance/" + balance, null, new Response.Listener<JSONArray>() {

        }
         */

        this.balance = balance;
    }
    public double getBalance() {


        return balance;
    }

    //email
    private String email;
    public void setEmail(String email) {
        this.email = email;
    }
    public String getEmail() {
        return email;
    }

    //id
    private int id;
    public void setId(int id) {
        this.id = id;
    }
    public int getId(){
        return id;
    }

    //name
    private String name;
    public void setName(String name) {
        this.name = name;
    }
    public String getName() {
        return name;
    }

    //password
    private String password;
    public void setPassword(String password) {
        this.password = password;
    }
    public String getPassword() {
        return password;
    }


    public User(double balance, String email, int id, String name, String password) {
        this.balance = balance;
        this.email = email;
        this.id = id;
        this.name = name;
        this.password = password;

    }
}
