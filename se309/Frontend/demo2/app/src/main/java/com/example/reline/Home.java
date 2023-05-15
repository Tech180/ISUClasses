package com.example.reline;

import android.content.Intent;
import android.os.Bundle;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonArrayRequest;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;
import com.google.android.material.appbar.CollapsingToolbarLayout;
import com.google.android.material.bottomnavigation.BottomNavigationView;
import com.google.android.material.floatingactionbutton.FloatingActionButton;
import com.google.android.material.snackbar.Snackbar;

import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;

import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.example.reline.databinding.ActivityHomeBinding;

import org.json.JSONArray;

public class Home extends AppCompatActivity {

    private ActivityHomeBinding binding;
    private String URL ="http://coms-309-066.cs.iastate.edu:8080/users/";
    private String URLlistings ="http://coms-309-066.cs.iastate.edu:8080/listings/";
    private String[] listings;
    public static String title;
    public static String username;
    public static String price;
    public static String description;
    //public static String uid;
    public static String idViewMode;
    public static String idListing;




    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        binding = ActivityHomeBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        Toolbar toolbar = binding.toolbar;
        setSupportActionBar(toolbar);
        CollapsingToolbarLayout toolBarLayout = binding.toolbarLayout;
        toolBarLayout.setTitle(getTitle());


        JsonArrayRequest listingsGetRequest = new JsonArrayRequest(Request.Method.GET, URLlistings,null, new Response.Listener<JSONArray>() {
            @Override
            public void onResponse(JSONArray response) {

                LinearLayout linearLayout = findViewById(R.id.homeLinear);

                for( int i = 0; i < response.length(); i++ )
                {

                    if(response.optJSONObject(i).optString("hidden").equals("false")){



                    //Title
                    TextView textViewTitle = new TextView(Home.this);
                    textViewTitle.setText("Title: " + response.optJSONObject(i).optString("title"));
                    textViewTitle.setTextSize(28);
                    linearLayout.addView(textViewTitle);

                    //Username
                    TextView textViewUsername = new TextView(Home.this);
                    textViewUsername.setText("Username: " + response.optJSONObject(i).optString("username"));
                    textViewUsername.setTextSize(20);
                    linearLayout.addView(textViewUsername);

                    //Price
                    TextView textViewPrice = new TextView(Home.this);
                    Float priceFloat = Float.parseFloat(response.optJSONObject(i).optString("price"));
                    textViewPrice.setText("Price: $" + String.format("%.2f", priceFloat));
                    textViewPrice.setTextSize(20);
                    linearLayout.addView(textViewPrice);

                    //Description
                    TextView textViewDes = new TextView(Home.this);
                    textViewDes.setText("Description: " + response.optJSONObject(i).optString("description"));
                    textViewDes.setTextSize(18);
                    linearLayout.addView(textViewDes);

                    //Premium
                    TextView textViewBump = new TextView(Home.this);
                    textViewBump.setText("Premium User: " + response.optJSONObject(i).optString("bumped"));
                    textViewBump.setTextSize(18);
                    linearLayout.addView(textViewBump);

                    //Spacer
                    TextView textViewSpacer = new TextView(Home.this);
                    textViewSpacer.setText(" ");
                    textViewSpacer.setTextSize(15);
                    linearLayout.addView(textViewSpacer);

                    //uid
                    String idViewModeResponse = response.optJSONObject(i).optString("uid");

                    //id
                    String idResponse = response.optJSONObject(i).optString("id");




                    //Go to Listing View
                    textViewTitle.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View view) {
                            //ServerRequest.idHard = textView.getText().toString();
                            // Toast.makeText(AdminPage.this, textView.getText().toString(), Toast.LENGTH_SHORT).show();
                            //String str = textView.getText().toString();
                            //Toast.makeText(Home.this, "View Listing", Toast.LENGTH_SHORT).show();
                            //ServerRequest.idHard = str.substring(Math.max(str.length() - 2, 0));
                            title = textViewTitle.getText().toString();
                            username = textViewUsername.getText().toString();
                            price = textViewPrice.getText().toString();
                            description = textViewDes.getText().toString();
                            //uid = uidResponse;
                            idListing = idResponse;
                            idViewMode = idViewModeResponse;
                            //Toast.makeText(Home.this, description, Toast.LENGTH_SHORT).show();
                            startActivity(new Intent(Home.this, ViewListingVMode.class));

                        }
                    });

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
                            //idBackup = ServerRequest.idHard;
                            //ServerRequest.idHard = uidResponse;
                            idViewMode = idViewModeResponse;
                            startActivity(new Intent(Home.this, ProfileViewMode.class));

                        }
                    });

                    }
                    else{
                        i++;
                    }

                }

                //ADD EXTRA SPACE FOR NAV BAR
                //LinearLayout linearLayout = findViewById(R.id.homeLinear);
                TextView textViewSpacer = new TextView(Home.this);
                textViewSpacer.setText(" ");
                textViewSpacer.setTextSize(50);
                linearLayout.addView(textViewSpacer);


            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                Toast.makeText(Home.this, error.toString().trim(), Toast.LENGTH_SHORT).show();
            }
        });

        RequestQueue listingsRequestQueue = Volley.newRequestQueue(getApplicationContext());
        listingsRequestQueue.add(listingsGetRequest);






        //getUsername
        /*
        StringRequest usernameGetRequest = new StringRequest(Request.Method.GET, URL + MainActivity.user.getId() + "/getUsername/", new Response.Listener<String>() {
            @Override
            public void onResponse(String response) {
                Log.i("Error: ", response.toString());
                String username = response;
                //Toast.makeText(Profile.this, balance, Toast.LENGTH_SHORT).show();
                TextView textview = (TextView) findViewById(R.id.username);
                textview.setText(username);
            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                Toast.makeText(Home.this, error.toString().trim(), Toast.LENGTH_SHORT).show();
            }
        });

        RequestQueue usernameRequestQueue = Volley.newRequestQueue(getApplicationContext());
        usernameRequestQueue.add(usernameGetRequest);


         */




        FloatingActionButton fab = binding.fab;
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = Home.this.getIntent();
                finish();
                startActivity(intent);
            }
        });

        BottomNavigationView bottomNavigationView = (BottomNavigationView) findViewById(R.id.bottomNavigationView);
        bottomNavigationView.setOnNavigationItemSelectedListener((item) -> {
            switch (item.getItemId()) {
                case R.id.miHome:
                    break;

                case R.id.miSearch:
                    startActivity(new Intent(Home.this, SearchActivity.class));
                    break;

                case R.id.miChat:
                    //startActivity(new Intent(Profile.this, Home.class));
                    startActivity(new Intent(Home.this, ChatActivity.class));
                    break;

                case R.id.miProfile:
                    startActivity(new Intent(Home.this, Profile.class));
                    break;
            }
            return false;
        });

        FloatingActionButton addListingButton = findViewById(R.id.fab2);
        addListingButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                startActivity(new Intent(Home.this, CreateListing.class));
            }
        });
    }

}