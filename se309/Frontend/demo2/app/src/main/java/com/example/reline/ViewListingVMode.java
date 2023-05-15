package com.example.reline;

import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;

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

public class ViewListingVMode extends AppCompatActivity {

    public static String idViewModeFromVMode = Home.idViewMode;
    private String URLbuy ="http://coms-309-066.cs.iastate.edu:8080/transactions/new/";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_view_listing_vmode);

        //toolbar
        Toolbar toolbar = findViewById(R.id.toolBar);
        getSupportActionBar().setTitle("Listing View Mode");

        //Username
        TextView textViewUsername = (TextView) findViewById(R.id.usernameText);
        textViewUsername.setText(Home.username);

        //Title
        TextView textViewTitle = (TextView) findViewById(R.id.titleText);
        textViewTitle.setText(Home.title);

        //Price
        TextView textViewPrice = (TextView) findViewById(R.id.priceText);
        textViewPrice.setText(Home.price);

        //Description
        TextView textViewDes = (TextView) findViewById(R.id.descriptionText);
        textViewDes.setText(Home.description);

        //Toast.makeText(ViewListingVMode.this, Home.uid, Toast.LENGTH_SHORT).show();

        textViewUsername.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                //ServerRequest.idHard = textView.getText().toString();
                // Toast.makeText(AdminPage.this, textView.getText().toString(), Toast.LENGTH_SHORT).show();
                //String str = textView.getText().toString();
                //Toast.makeText(Home.this, "View Listing", Toast.LENGTH_SHORT).show();
                //ServerRequest.idHard = str.substring(Math.max(str.length() - 2, 0));
                //title = textViewTitle.getText().toString();
                //username = textViewUsername.getText().toString();
                //price = textViewPrice.getText().toString();
                //description = textViewDes.getText().toString();
                //uid = uidResponse;
                //Toast.makeText(Home.this, description, Toast.LENGTH_SHORT).show();

                startActivity(new Intent(ViewListingVMode.this, ProfileViewMode.class));

            }
        });

        Button tradeButton = (Button) findViewById(R.id.tradeListingButton); //go to settings from button
        tradeButton.setOnClickListener(new View.OnClickListener(){
            public void onClick(View v){
                startActivity(new Intent(ViewListingVMode.this, Trade.class));
            }
        });

        Button buyButton = (Button) findViewById(R.id.buyListingButton); //go to settings from button
        buyButton.setOnClickListener(new View.OnClickListener(){
            public void onClick(View v){
                //startActivity(new Intent(ViewListingVMode.this, Trade.class));

                //buy
                StringRequest balanceGetRequest = new StringRequest(Request.Method.POST, URLbuy + Home.idViewMode + "/" + ServerRequest.idHard + "/" + Home.idListing, new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        Toast.makeText(ViewListingVMode.this, "Purchase Status: " + response, Toast.LENGTH_SHORT).show();
                    }
                }, new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {
                        Toast.makeText(ViewListingVMode.this, error.toString().trim(), Toast.LENGTH_SHORT).show();
                    }
                });

                RequestQueue balanceRequest = Volley.newRequestQueue(getApplicationContext());
                balanceRequest.add(balanceGetRequest);
            }
        });








        //nav bar stuff
        BottomNavigationView bottomNavigationView = (BottomNavigationView) findViewById(R.id.bottomNavigationView);
        bottomNavigationView.setOnNavigationItemSelectedListener((item) -> {
            switch (item.getItemId()) {
                case R.id.miHome:
                    startActivity(new Intent(ViewListingVMode.this, Home.class));
                    break;

                case R.id.miSearch:
                    //startActivity(new Intent(Profile.this, Home.class));
                    break;

                case R.id.miChat:
                    //startActivity(new Intent(Profile.this, Home.class));
                    break;

                case R.id.miProfile:
                    startActivity(new Intent(ViewListingVMode.this, Profile.class));
                    break;
            }
            return false;
        });

        FloatingActionButton addListingButton = findViewById(R.id.fab);
        addListingButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                startActivity(new Intent(ViewListingVMode.this, CreateListing.class));
            }
        });

    }
}