package com.example.reline;

import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;
import com.google.android.material.bottomnavigation.BottomNavigationView;
import com.google.android.material.floatingactionbutton.FloatingActionButton;

public class CreateListing extends AppCompatActivity {

    //private String URLlistings ="http://coms-309-066.cs.iastate.edu:8080/listings/";
    private String URL ="http://coms-309-066.cs.iastate.edu:8080/users/";
    //private double priceNum;
    //private String title;
    //private String price;
    //private String description;



    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_create_listing);

        //toolbar
        Toolbar toolbar = findViewById(R.id.toolBar);
        getSupportActionBar().setTitle("Create Listing");

        Button postListing = (Button)findViewById(R.id.postListingButton);
        postListing.setOnClickListener(new View.OnClickListener(){
            public void onClick(View v){

                EditText titleText = (EditText) findViewById(R.id.listingTitle);
                String title = titleText.getText().toString();

                EditText priceText = (EditText) findViewById(R.id.listingPrice);
                double priceNum = Double.parseDouble(priceText.getText().toString());
                String price = String.valueOf(priceNum);

                EditText descriptionText = (EditText) findViewById(R.id.listingDescription);
                String description = descriptionText.getText().toString();

                postListing(title, price, description);


            }
        });

        BottomNavigationView bottomNavigationView = (BottomNavigationView) findViewById(R.id.bottomNavigationView);
        bottomNavigationView.setOnNavigationItemSelectedListener((item) -> {
            switch (item.getItemId()) {
                case R.id.miHome:
                    startActivity(new Intent(CreateListing.this, Home.class));
                    break;

                case R.id.miSearch:
                    //startActivity(new Intent(Profile.this, Home.class));
                    break;

                case R.id.miChat:
                    //startActivity(new Intent(Profile.this, Home.class));
                    break;

                case R.id.miProfile:
                    startActivity(new Intent(CreateListing.this, Profile.class));
                    break;
            }
            return false;
        });

        FloatingActionButton addListingButton = findViewById(R.id.fab);
        addListingButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                //startActivity(new Intent(CreateListing.this, CreateListing.class));
            }
        });



    }

    public void postListing(String title, String price, String description){

        String URLlistings ="http://coms-309-066.cs.iastate.edu:8080/listings/" + "new/" + ServerRequest.idHard + "/" + title + "/" + price + "/" + description;



        //newListing
        StringRequest listingGetRequest = new StringRequest(Request.Method.POST, URLlistings, new Response.Listener<String>() {
            @Override
            public void onResponse(String response) {
                Toast.makeText(CreateListing.this, response.toString(), Toast.LENGTH_SHORT).show();
            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                Toast.makeText(CreateListing.this, error.toString().trim(), Toast.LENGTH_SHORT).show();
                Toast.makeText(CreateListing.this, URLlistings, Toast.LENGTH_LONG).show();
            }
        });

        RequestQueue listingRequestQueue = Volley.newRequestQueue(getApplicationContext());
        listingRequestQueue.add(listingGetRequest);


    }
}