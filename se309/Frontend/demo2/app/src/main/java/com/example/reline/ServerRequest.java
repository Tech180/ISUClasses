package com.example.reline;

import android.app.Application;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.android.volley.AuthFailureError;
import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonArrayRequest;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;


public class ServerRequest {
    static String URL ="http://3sc1:309_Reline@coms-309-066.cs.iastate.edu:8080/users/";
    static String idHard;
    static String usernameHard;

    public void newUser(String username, String password, Context context) {
        String newUserURL = URL + "new/" + username + "/" + password + "/";
        StringRequest newUserRequest = new StringRequest(Request.Method.POST, newUserURL, new Response.Listener<String>() {
            @Override
            public void onResponse(String response) {
                if (!response.equals("failure")) {
                    idHard = response;
                    Toast.makeText(context, "Registration successful", Toast.LENGTH_SHORT).show();
                    Intent intent = new Intent(context, Profile.class); //change to home screen when its ready
                    context.startActivity(intent);

                }
                else if(response.equals("failure")){
                    Toast.makeText(context, "Username Exists", Toast.LENGTH_SHORT).show();
                }
            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                Toast.makeText(context, error.toString(), Toast.LENGTH_SHORT).show();
                //probably should add something to handle error here
            }
        });
        RequestQueue requestQueue = Volley.newRequestQueue(context);
        requestQueue.add(newUserRequest);




    }

    public void loginUser(String username, String password, Context context) {
        String loginUserURL = URL + "login/" + username + "/" + password + "/"; //need to get backend to fix controller
        usernameHard = username;
        StringRequest loginRequest = new StringRequest(Request.Method.GET, loginUserURL, new Response.Listener<String>() {
            @Override
            public void onResponse(String response) {
                if (!response.equals("failure")) {
                    idHard = response;
                    //for admin
                    if(username.equals("admin")){
                        Toast.makeText(context, "Admin Login Success", Toast.LENGTH_SHORT).show();
                        Intent AdminIntent = new Intent(context, AdminPage.class);
                        context.startActivity(AdminIntent);
                    }
                    else{
                        Toast.makeText(context, "Login successful", Toast.LENGTH_SHORT).show();
                        Intent intent = new Intent(context, Profile.class); //change to home screen when its ready
                        context.startActivity(intent);
                    }
                    //finish();
                }
                else{
                    Toast.makeText(context, "Incorrect Username/Password", Toast.LENGTH_SHORT).show();
                }
            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                Toast.makeText(context, error.toString(), Toast.LENGTH_SHORT).show();
                //probably should add something to handle error here
            }
        });
        RequestQueue requestQueue = Volley.newRequestQueue(context);
        requestQueue.add(loginRequest);
    }

    public void setUsername(String id, Context context) {
        String setUsernameURL = URL + id + "/getUsername"; //need to get backend to fix controller
        StringRequest usernameRequest = new StringRequest(Request.Method.GET, setUsernameURL, new Response.Listener<String>() {
            @Override
            public void onResponse(String response) {
                usernameHard = response;
            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                //Toast.makeText(context, error.toString(), Toast.LENGTH_SHORT).show();
                Log.d("Error", "user id doesnt exist");
                //probably should add something to handle error here
            }
        });
        RequestQueue requestQueue = Volley.newRequestQueue(context);
        requestQueue.add(usernameRequest);
    }
}

