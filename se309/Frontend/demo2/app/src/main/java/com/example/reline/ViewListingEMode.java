package com.example.reline;

import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
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

public class ViewListingEMode extends AppCompatActivity {

    private String URL ="http://coms-309-066.cs.iastate.edu:8080/users/";
    private String URLlistings ="http://coms-309-066.cs.iastate.edu:8080/listings/";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_view_listing_emode);

        //toolbar
        Toolbar toolbar = findViewById(R.id.toolBar);
        getSupportActionBar().setTitle("Listing Edit Mode");

        TextView textViewUsername = (TextView) findViewById(R.id.usernameTextE);
        textViewUsername.setText("Username: " + Profile.username);

        TextView textViewTitle = (TextView) findViewById(R.id.titleTextE);
        textViewTitle.setText("Title: " + Profile.title);

        TextView textViewPrice = (TextView) findViewById(R.id.priceTextE);
        textViewPrice.setText("Price: $" + Profile.price);

        TextView textViewDes = (TextView) findViewById(R.id.descriptionTextE);
        textViewDes.setText("Description: " + Profile.description);

        AlertDialog.Builder builder = new AlertDialog.Builder(this);

        builder.setTitle("Confirm");
        builder.setMessage("Are you sure you want to DELETE this listing?");

        builder.setPositiveButton("YES", new DialogInterface.OnClickListener() {

            public void onClick(DialogInterface dialog, int which) {

                //request
                StringRequest listingDeleteRequest = new StringRequest(Request.Method.DELETE, URLlistings + "delete/" + Profile.listingID, new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        Toast.makeText(ViewListingEMode.this, "Deletion Status: " + response, Toast.LENGTH_SHORT).show();
                    }
                }, new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {
                        Toast.makeText(ViewListingEMode.this, error.toString().trim(), Toast.LENGTH_SHORT).show();
                    }
                });

                RequestQueue listingDeleteRequestQueue = Volley.newRequestQueue(getApplicationContext());
                listingDeleteRequestQueue.add(listingDeleteRequest);

                dialog.dismiss();
            }
        });

        builder.setNegativeButton("NO", new DialogInterface.OnClickListener() {

            @Override
            public void onClick(DialogInterface dialog, int which) {

                Toast.makeText(ViewListingEMode.this, "No Deletion", Toast.LENGTH_SHORT).show();

                // Do nothing
                dialog.dismiss();
            }
        });

        Button deleteListing = (Button)findViewById(R.id.deleteListingButton);
        //Button balanceInc = (Button) findViewById(R.id.balance); //go to settings from button
        deleteListing.setOnClickListener(new View.OnClickListener(){
            public void onClick(View v){

                AlertDialog alert = builder.create();
                alert.show();
            }
        });


        //nav bar stuff
        BottomNavigationView bottomNavigationView = (BottomNavigationView) findViewById(R.id.bottomNavigationView);
        bottomNavigationView.setOnNavigationItemSelectedListener((item) -> {
            switch (item.getItemId()) {
                case R.id.miHome:
                    startActivity(new Intent(ViewListingEMode.this, Home.class));
                    break;

                case R.id.miSearch:
                    //startActivity(new Intent(Profile.this, Home.class));
                    break;

                case R.id.miChat:
                    //startActivity(new Intent(Profile.this, Home.class));
                    break;

                case R.id.miProfile:
                    startActivity(new Intent(ViewListingEMode.this, Profile.class));
                    break;
            }
            return false;
        });

        FloatingActionButton addListingButton = findViewById(R.id.fab);
        addListingButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                startActivity(new Intent(ViewListingEMode.this, CreateListing.class));
            }
        });




    }
}