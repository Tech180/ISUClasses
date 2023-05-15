package com.example.reline;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;

import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonArrayRequest;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;
import com.google.android.material.bottomnavigation.BottomNavigationView;
import com.google.android.material.floatingactionbutton.FloatingActionButton;

import org.json.JSONArray;

public class ProfileViewMode extends AppCompatActivity {

    private String URL ="http://coms-309-066.cs.iastate.edu:8080/users/";
    private String URLlistings ="http://coms-309-066.cs.iastate.edu:8080/listings/";
    public static String balance;
    public static String title;
    public static String username;
    public static String price;
    public static String description;
    public static String listingID;

    //refresh button in toolbar things
    @Override
    public boolean onCreateOptionsMenu(Menu menu){
        MenuInflater menuInflater = getMenuInflater();
        menuInflater.inflate(R.menu.sub_menu, menu);
        return super.onCreateOptionsMenu(menu);
    }

    //refresh button in toolbar things
    @Override
    public boolean onOptionsItemSelected(@NonNull MenuItem item) {
        if(item.getItemId() == R.id.refresh){
            /* this commented out stuff does the same thing as recreate();
            Intent intent = Profile.this.getIntent();
            finish();
            startActivity(intent);
             */
            recreate();
        }
        return super.onOptionsItemSelected(item);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_profile_view_mode);

        //toolbar
        Toolbar toolbar = findViewById(R.id.toolBar);
        getSupportActionBar().setTitle("Profile View Mode");

        //getUsername
        StringRequest usernameGetRequest = new StringRequest(Request.Method.GET, URL + Home.idViewMode + "/getUsername/", new Response.Listener<String>() {
            @Override
            public void onResponse(String response) {
                Log.i("Error: ", response.toString());
                String username = response;
                //Toast.makeText(Profile.this, balance, Toast.LENGTH_SHORT).show();
                TextView textview = (TextView) findViewById(R.id.usernameVMode);
                textview.setText(username);
            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                Toast.makeText(ProfileViewMode.this, error.toString().trim(), Toast.LENGTH_SHORT).show();
            }
        });

        RequestQueue usernameRequestQueue = Volley.newRequestQueue(getApplicationContext());
        usernameRequestQueue.add(usernameGetRequest);

        //listings
        //getListings
        JsonArrayRequest listingsGetRequest = new JsonArrayRequest(Request.Method.GET, URL + Home.idViewMode + "/getListings/", null, new Response.Listener<JSONArray>() {
            @Override
            public void onResponse(JSONArray response) {

                LinearLayout linearLayout = findViewById(R.id.profileViewModeListings);

                //ScrollView scrollView = findViewById(R.id.profileScroll);

                //Toast.makeText(Profile.this, response.toString(), Toast.LENGTH_SHORT).show();

                if(response.toString().equals("[]")){
                    //Toast.makeText(Profile.this, "No listings", Toast.LENGTH_SHORT).show();
                    //Title
                    TextView textViewTitle = new TextView(ProfileViewMode.this);
                    textViewTitle.setText("No Listings");
                    textViewTitle.setTextSize(28);
                    //textViewTitle.setLayoutParams(new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.MATCH_PARENT));
                    linearLayout.addView(textViewTitle);

                }



                for(int i = 0; i < response.length(); i++){

                    if(response.optJSONObject(i).optString("hidden").equals("false")) {

                        //Title
                        TextView textViewTitle = new TextView(ProfileViewMode.this);
                        Float priceFloat = Float.parseFloat(response.optJSONObject(i).optString("price"));
                        textViewTitle.setText("Listing " + (i + 1) + ": " + response.optJSONObject(i).optString("title") + " $" + String.format("%.2f", priceFloat));
                        textViewTitle.setTextSize(23);
                        textViewTitle.setTextColor(Color.parseColor("#000000"));
                        // textViewTitle.setLayoutParams(new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.MATCH_PARENT));
                        linearLayout.addView(textViewTitle);

                        String usernameResponse = response.optJSONObject(i).optString("username");
                        //String priceResponse = response.optJSONObject(i).optString("price");
                        String titleResponse = response.optJSONObject(i).optString("title");
                        String descriptionResponse = response.optJSONObject(i).optString("description");
                        String listingIDResponse = response.optJSONObject(i).optString("id");


                        //Go to Listing View
                        textViewTitle.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View view) {
                                //ServerRequest.idHard = textView.getText().toString();
                                // Toast.makeText(AdminPage.this, textView.getText().toString(), Toast.LENGTH_SHORT).show();
                                //String str = textView.getText().toString();
                                //Toast.makeText(Home.this, "View Listing", Toast.LENGTH_SHORT).show();
                                //ServerRequest.idHard = str.substring(Math.max(str.length() - 2, 0));
                                title = titleResponse;
                                Home.title = "Title: " + titleResponse;
                                username = usernameResponse;
                                Home.username = "Username: " + usernameResponse;
                                price = String.format("%.2f", priceFloat);
                                Home.price = "Price: $" + String.format("%.2f", priceFloat);
                                description = descriptionResponse;
                                Home.description = "Description: " + descriptionResponse;
                                listingID = listingIDResponse;
                                //Home.listingID = listingIDResponse;
                                //Toast.makeText(Home.this, description, Toast.LENGTH_SHORT).show();
                                startActivity(new Intent(ProfileViewMode.this, ViewListingVMode.class));

                            }
                        });


                    }



                }


            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                Toast.makeText(ProfileViewMode.this, error.toString().trim(), Toast.LENGTH_SHORT).show();
            }
        });

        RequestQueue listingsRequestQueue = Volley.newRequestQueue(getApplicationContext());
        listingsRequestQueue.add(listingsGetRequest);

        BottomNavigationView bottomNavigationView = (BottomNavigationView) findViewById(R.id.bottomNavigationView);
        bottomNavigationView.setOnNavigationItemSelectedListener((item) -> {
            switch (item.getItemId()) {
                case R.id.miHome:
                    startActivity(new Intent(ProfileViewMode.this, Home.class));
                    break;

                case R.id.miSearch:
                    //startActivity(new Intent(Profile.this, Home.class));
                    break;

                case R.id.miChat:
                    //startActivity(new Intent(Profile.this, Home.class));
                    break;

                case R.id.miProfile:
                    startActivity(new Intent(ProfileViewMode.this, Profile.class));
                    break;
            }
            return false;
        });

        FloatingActionButton addListingButton = findViewById(R.id.fab);
        addListingButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                startActivity(new Intent(ProfileViewMode.this, CreateListing.class));
            }
        });




    }
}