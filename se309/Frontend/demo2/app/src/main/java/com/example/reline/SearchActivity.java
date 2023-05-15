package com.example.reline;

import android.content.Intent;
import android.os.Bundle;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonArrayRequest;
import com.android.volley.toolbox.Volley;
import com.example.reline.databinding.ActivityHomeBinding;
import com.google.android.material.appbar.CollapsingToolbarLayout;
import com.google.android.material.bottomnavigation.BottomNavigationView;
import com.google.android.material.floatingactionbutton.FloatingActionButton;
import com.google.android.material.snackbar.Snackbar;

import androidx.appcompat.app.AppCompatActivity;

import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.widget.Toolbar;
import androidx.navigation.NavController;
import androidx.navigation.Navigation;
import androidx.navigation.ui.AppBarConfiguration;
import androidx.navigation.ui.NavigationUI;

import com.example.reline.databinding.ActivitySearchBinding;

import org.json.JSONArray;

public class SearchActivity extends AppCompatActivity {

    Button b1;
    EditText e1;

    public static String title;
    public static String username;
    public static String price;
    public static String description;
    //public static String uid;
    public static String idViewMode;

    public static String search;

    private AppBarConfiguration appBarConfiguration;
    private ActivitySearchBinding binding;

    private String URL ="http://coms-309-066.cs.iastate.edu:8080/";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_search);

        b1 = (Button) findViewById(R.id.bt1);
        e1 = (EditText) findViewById(R.id.et1);

        displayListings(search);

        b1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                search = e1.getText().toString();
                recreate();
            }
        });

        BottomNavigationView bottomNavigationView = (BottomNavigationView) findViewById(R.id.bottomNavigationView);
        bottomNavigationView.setOnNavigationItemSelectedListener((item) -> {
            switch (item.getItemId()) {
                case R.id.miHome:
                    startActivity(new Intent(SearchActivity.this, Home.class));
                    break;

                case R.id.miSearch:
                    //startActivity(new Intent(SearchActivity.this, SearchActivity.class));
                    break;

                case R.id.miChat:
                    //startActivity(new Intent(Profile.this, Home.class));
                    startActivity(new Intent(SearchActivity.this, ChatActivity.class));
                    break;

                case R.id.miProfile:
                    startActivity(new Intent(SearchActivity.this, Profile.class));
                    break;
            }
            return false;
        });

        FloatingActionButton addListingButton = findViewById(R.id.fab);
        addListingButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                startActivity(new Intent(SearchActivity.this, CreateListing.class));
            }
        });

    }

    private void displayListings(String search) {
//        binding = ActivityHomeBinding.inflate(getLayoutInflater());
//        setContentView(binding.getRoot());
//
//        Toolbar toolbar = binding.toolbar;
//        setSupportActionBar(toolbar);
//        CollapsingToolbarLayout toolBarLayout = binding.toolbarLayout;
//        toolBarLayout.setTitle(getTitle());

        //setContentView(binding.getRoot());
        String searchURL = URL + "/listings/search/" + search;

        //String searchURL = URL + "/listings/";
        JsonArrayRequest listingsGetRequest = new JsonArrayRequest(Request.Method.GET, searchURL,null, new Response.Listener<JSONArray>() {
            @Override
            public void onResponse(JSONArray response) {
                LinearLayout linearLayout = findViewById(R.id.searchLinear);

                for( int i = 0; i < response.length(); i++ )
                {
                    //Title
                    TextView textViewTitle = new TextView(SearchActivity.this);
                    textViewTitle.setText("Title: " + response.optJSONObject(i).optString("title"));
                    textViewTitle.setTextSize(28);
                    linearLayout.addView(textViewTitle);

                    //Username
                    TextView textViewUsername = new TextView(SearchActivity.this);
                    textViewUsername.setText("Username: " + response.optJSONObject(i).optString("username"));
                    textViewUsername.setTextSize(20);
                    linearLayout.addView(textViewUsername);

                    //Price
                    TextView textViewPrice = new TextView(SearchActivity.this);
                    Float priceFloat = Float.parseFloat(response.optJSONObject(i).optString("price"));
                    textViewPrice.setText("Price: $" + String.format("%.2f", priceFloat));
                    textViewPrice.setTextSize(20);
                    linearLayout.addView(textViewPrice);

                    //Description
                    TextView textViewDes = new TextView(SearchActivity.this);
                    textViewDes.setText("Description: " + response.optJSONObject(i).optString("description"));
                    textViewDes.setTextSize(18);
                    linearLayout.addView(textViewDes);

                    //Premium
                    TextView textViewBump = new TextView(SearchActivity.this);
                    textViewBump.setText("Premium User: " + response.optJSONObject(i).optString("bumped"));
                    textViewBump.setTextSize(18);
                    linearLayout.addView(textViewBump);

                    //Spacer
                    TextView textViewSpacer = new TextView(SearchActivity.this);
                    textViewSpacer.setText(" ");
                    textViewSpacer.setTextSize(15);
                    linearLayout.addView(textViewSpacer);

                    //uid
                    String idViewModeResponse = response.optJSONObject(i).optString("uid");



                    //Go to Listing View
                    textViewTitle.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View view) {
                            //ServerRequest.idHard = textView.getText().toString();
                            // Toast.makeText(AdminPage.this, textView.getText().toString(), Toast.LENGTH_SHORT).show();
                            //String str = textView.getText().toString();
                            //Toast.makeText(Home.this, "View Listing", Toast.LENGTH_SHORT).show();
                            //ServerRequest.idHard = str.substring(Math.max(str.length() - 2, 0));
                            Home.title = textViewTitle.getText().toString();
                            Home.username = textViewUsername.getText().toString();
                            Home.price = textViewPrice.getText().toString();
                            Home.description = textViewDes.getText().toString();
                            //uid = uidResponse;
                            Home.idViewMode = idViewModeResponse;
                            //Toast.makeText(Home.this, description, Toast.LENGTH_SHORT).show();
                            startActivity(new Intent(SearchActivity.this, ViewListingVMode.class));

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
                            Home.idViewMode = idViewModeResponse;
                            startActivity(new Intent(SearchActivity.this, ProfileViewMode.class));

                        }
                    });



                }

                //ADD EXTRA SPACE FOR NAV BAR
                //LinearLayout linearLayout = findViewById(R.id.homeLinear);

                TextView textViewSpacer = new TextView(SearchActivity.this);
                textViewSpacer.setText(" ");
                textViewSpacer.setTextSize(50);
                linearLayout.addView(textViewSpacer);


            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                Toast.makeText(SearchActivity.this, error.toString().trim(), Toast.LENGTH_SHORT).show();
            }
        });

        RequestQueue listingsRequestQueue = Volley.newRequestQueue(getApplicationContext());
        listingsRequestQueue.add(listingsGetRequest);

    }

    @Override
    public boolean onSupportNavigateUp() {
        NavController navController = Navigation.findNavController(this, R.id.nav_host_fragment_content_search);
        return NavigationUI.navigateUp(navController, appBarConfiguration)
                || super.onSupportNavigateUp();
    }


}