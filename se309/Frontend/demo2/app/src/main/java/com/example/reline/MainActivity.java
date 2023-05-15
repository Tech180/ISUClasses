package com.example.reline;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.EditText;


import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;

import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;

import android.widget.Toast;


public class MainActivity extends AppCompatActivity{
    public static double responseBalance;
    public static String responseEmail;
    public static int responseId;
    public static String responseName;
    public static String responsePassword;
    private EditText etUsername, etPassword;
    private String username, password;
    private String URL ="http://3sc1:309_Reline@coms-309-066.cs.iastate.edu:8080/users/";
    public static User user = new User(responseBalance, responseEmail, responseId, responseName, responsePassword);


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        username = password = "";
        etUsername = findViewById(R.id.etUsername);
        etPassword = findViewById(R.id.etPasswordReg);
    }

    public void login(View view) {
        username = etUsername.getText().toString().trim();
        password = etPassword.getText().toString().trim();
        if (!username.equals("") && !password.equals("")) {

            //from isaac
            /*String loginURL = URL + "login/" + username + "/" + password;
            StringRequest loginRequest = new StringRequest(Request.Method.GET, loginURL, new Response.Listener<String>() {
                @Override
                public void onResponse(String response) {
                    if(!response.equals("failure")) {
                        Toast.makeText(MainActivity.this, "Login successful", Toast.LENGTH_SHORT).show();
                        Intent intent = new Intent(MainActivity.this, Profile.class); //change to home screen when its ready
                        startActivity((intent));
                        finish();
                    }
                }
            }, new Response.ErrorListener() {
                @Override
                public void onErrorResponse(VolleyError error) {
                    Toast.makeText(MainActivity.this, error.toString().trim(), Toast.LENGTH_SHORT).show();
                }
            });

            RequestQueue usernameRequestQueue = Volley.newRequestQueue(getApplicationContext());
            usernameRequestQueue.add(loginRequest);
        }*/
            ServerRequest sr = new ServerRequest();

            sr.loginUser(username, password, this);
        }}

    public void register(View view) {
        Intent intent = new Intent(MainActivity.this, Register.class);
        startActivity(intent);
        finish();
    }


}
