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
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.LinearLayout;
import android.widget.ScrollView;
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
import com.google.android.material.navigation.NavigationView;


import org.json.JSONArray;
import org.w3c.dom.Text;

import java.util.Objects;

public class Profile extends AppCompatActivity {

    private String URL ="http://coms-309-066.cs.iastate.edu:8080/users/";
    private String URLlistings ="http://coms-309-066.cs.iastate.edu:8080/listings/";
    public static String balance;
    public static String title;
    public static String username;
    public static String price;
    public static String description;
    public static String listingID;
    //public static String uid;
    //public static String idBackup;


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
        setContentView(R.layout.activity_profile);

        //toolbar
        Toolbar toolbar = findViewById(R.id.toolBar);
        getSupportActionBar().setTitle("Profile");

        //getUsername
        StringRequest usernameGetRequest = new StringRequest(Request.Method.GET, URL + ServerRequest.idHard + "/getUsername/", new Response.Listener<String>() {
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
                Toast.makeText(Profile.this, error.toString().trim(), Toast.LENGTH_SHORT).show();
            }
        });

        RequestQueue usernameRequestQueue = Volley.newRequestQueue(getApplicationContext());
        usernameRequestQueue.add(usernameGetRequest);


        //getBalance
        StringRequest balanceGetRequest = new StringRequest(Request.Method.GET, URL + ServerRequest.idHard + "/getBalance/", new Response.Listener<String>() {
            @Override
            public void onResponse(String response) {
                Log.i("Error: ", response.toString());
                balance = response;
                //Toast.makeText(Profile.this, balance, Toast.LENGTH_SHORT).show();
                Button button = (Button)findViewById(R.id.balance);
                button.setText("$" + balance);
            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                Toast.makeText(Profile.this, error.toString().trim(), Toast.LENGTH_SHORT).show();
            }
        });

        RequestQueue balanceRequestQueue = Volley.newRequestQueue(getApplicationContext());
        balanceRequestQueue.add(balanceGetRequest);

        //getListings
        JsonArrayRequest listingsGetRequest = new JsonArrayRequest(Request.Method.GET, URL + ServerRequest.idHard + "/getListings/", null, new Response.Listener<JSONArray>() {
            @Override
            public void onResponse(JSONArray response) {

                LinearLayout linearLayout = findViewById(R.id.profileListings);

                //ScrollView scrollView = findViewById(R.id.profileScroll);

                //Toast.makeText(Profile.this, response.toString(), Toast.LENGTH_SHORT).show();

                if(response.toString().equals("[]")){
                    //Toast.makeText(Profile.this, "No listings", Toast.LENGTH_SHORT).show();
                    //Title
                    TextView textViewTitle = new TextView(Profile.this);
                    textViewTitle.setText("No Listings");
                    textViewTitle.setTextSize(28);
                    //textViewTitle.setLayoutParams(new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.MATCH_PARENT));
                    linearLayout.addView(textViewTitle);

                }

                for(int i = 0; i < response.length(); i++){

                    if(response.optJSONObject(i).optString("hidden").equals("false")) {

                        //Title
                        TextView textViewTitle = new TextView(Profile.this);
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
                                username = usernameResponse;
                                price = String.format("%.2f", priceFloat);
                                description = descriptionResponse;
                                listingID = listingIDResponse;
                                //Toast.makeText(Home.this, description, Toast.LENGTH_SHORT).show();
                                startActivity(new Intent(Profile.this, ViewListingEMode.class));

                            }
                        });

                    }




                }


            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                Toast.makeText(Profile.this, error.toString().trim(), Toast.LENGTH_SHORT).show();
            }
        });

        RequestQueue listingsRequestQueue = Volley.newRequestQueue(getApplicationContext());
        listingsRequestQueue.add(listingsGetRequest);

        Button balanceButton = (Button) findViewById(R.id.balance); //go to balance from button
        balanceButton.setOnClickListener(new View.OnClickListener(){
            public void onClick(View v){
                startActivity(new Intent(Profile.this, Balance.class));
            }
        });


        Button yourButton = (Button) findViewById(R.id.open_settings); //go to settings from button
        yourButton.setOnClickListener(new View.OnClickListener(){
            public void onClick(View v){
                startActivity(new Intent(Profile.this, Settings.class));
            }
        });

        Button bumpButton = (Button) findViewById(R.id.bumpButton); //go to settings from button
        bumpButton.setOnClickListener(new View.OnClickListener(){
            public void onClick(View v){

                Toast.makeText(Profile.this, "Clicked", Toast.LENGTH_SHORT).show();
                //bump
                StringRequest bumpGetRequest = new StringRequest(Request.Method.PUT, URL + ServerRequest.idHard + "/setPaid/", new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        Toast.makeText(Profile.this, "Premium Status: " + response, Toast.LENGTH_SHORT).show();
                    }
                }, new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {
                        Toast.makeText(Profile.this, error.toString().trim(), Toast.LENGTH_SHORT).show();
                    }
                });

                RequestQueue bumpRequestQueue = Volley.newRequestQueue(getApplicationContext());
                bumpRequestQueue.add(bumpGetRequest);
            }
        });

        BottomNavigationView bottomNavigationView = (BottomNavigationView) findViewById(R.id.bottomNavigationView);
        bottomNavigationView.setOnNavigationItemSelectedListener((item) -> {
            switch (item.getItemId()) {
                case R.id.miHome:
                    startActivity(new Intent(Profile.this, Home.class));
                    break;

                case R.id.miSearch:
                    startActivity(new Intent(Profile.this, SearchActivity.class));
                    break;

                case R.id.miChat:
                    startActivity(new Intent(Profile.this, ChatActivity.class));
                    break;

                case R.id.miProfile:
                    break;
            }
            return false;
        });

        FloatingActionButton addListingButton = findViewById(R.id.fab);
        addListingButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                startActivity(new Intent(Profile.this, CreateListing.class));
            }
        });

    }

    public boolean makePremium(Double balance, String accountStatus){
        if(balance >= 10 && !accountStatus.equals("Paid")){
            return true;
        }
        else{
            return false;
        }
    }

}