package com.example.reline;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.EditText;
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

import org.json.JSONArray;

public class Trade extends AppCompatActivity {

    private String URL ="http://coms-309-066.cs.iastate.edu:8080/users/";
    private String URLtrade ="http://coms-309-066.cs.iastate.edu:8080/transactions/newTrade/";
    public String listingIDResponse;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_trade);


        //getListings
        JsonArrayRequest listingsGetRequest = new JsonArrayRequest(Request.Method.GET, URL + ServerRequest.idHard + "/getListings/", null, new Response.Listener<JSONArray>() {
            @Override
            public void onResponse(JSONArray response) {

                LinearLayout linearLayout = findViewById(R.id.tradeLinear);

                //ScrollView scrollView = findViewById(R.id.profileScroll);

                //Toast.makeText(Profile.this, response.toString(), Toast.LENGTH_SHORT).show();

                if(response.toString().equals("[]")){
                    //Toast.makeText(Profile.this, "No listings", Toast.LENGTH_SHORT).show();
                    //Title
                    TextView textViewTitle = new TextView(Trade.this);
                    textViewTitle.setText("No Listings");
                    textViewTitle.setTextSize(28);
                    //textViewTitle.setLayoutParams(new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.MATCH_PARENT));
                    linearLayout.addView(textViewTitle);

                }

                for(int i = 0; i < response.length(); i++){

                    //Title
                    TextView textViewTitle = new TextView(Trade.this);
                    Float priceFloat = Float.parseFloat(response.optJSONObject(i).optString("price"));
                    textViewTitle.setText("Listing " + (i+1) + ": "+ response.optJSONObject(i).optString("title") + " $" + String.format("%.2f", priceFloat));
                    textViewTitle.setTextSize(23);
                    textViewTitle.setTextColor(Color.parseColor("#000000"));
                    // textViewTitle.setLayoutParams(new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.MATCH_PARENT));
                    linearLayout.addView(textViewTitle);

                    String usernameResponse = response.optJSONObject(i).optString("username");
                    //String priceResponse = response.optJSONObject(i).optString("price");
                    String titleResponse = response.optJSONObject(i).optString("title");
                    String descriptionResponse = response.optJSONObject(i).optString("description");
                    listingIDResponse = response.optJSONObject(i).optString("id");


                    //Go to Listing View
                    textViewTitle.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View view) {
                            /*
                            //ServerRequest.idHard = textView.getText().toString();
                            // Toast.makeText(AdminPage.this, textView.getText().toString(), Toast.LENGTH_SHORT).show();
                            //String str = textView.getText().toString();
                            //Toast.makeText(Home.this, "View Listing", Toast.LENGTH_SHORT).show();
                            //ServerRequest.idHard = str.substring(Math.max(str.length() - 2, 0));
                            Profile.title = titleResponse;
                            Profile.username = usernameResponse;
                            Profile.price = String.format("%.2f", priceFloat);
                            Profile.description = descriptionResponse;
                            Profile.listingID = listingIDResponse;
                            //Toast.makeText(Home.this, description, Toast.LENGTH_SHORT).show();
                            startActivity(new Intent(Trade.this, ViewListingEMode.class));

                             */

                            //Toast.makeText(Trade.this, "Clicked", Toast.LENGTH_SHORT).show();


                            //getUsername // seller(Home.idViewMode buyer(idHard) listingSeller(Home.idListing) listing(listingIDResponse)
                            StringRequest balanceGetRequest = new StringRequest(Request.Method.POST, URLtrade + Home.idViewMode + "/" + ServerRequest.idHard + "/" + Home.idListing + "/" + listingIDResponse, new Response.Listener<String>() {
                                @Override
                                public void onResponse(String response) {
                                    Toast.makeText(Trade.this, "Trade Status: " + response, Toast.LENGTH_SHORT).show();
                                }
                            }, new Response.ErrorListener() {
                                @Override
                                public void onErrorResponse(VolleyError error) {
                                    Toast.makeText(Trade.this, error.toString().trim(), Toast.LENGTH_SHORT).show();
                                }
                            });

                            RequestQueue balanceRequest = Volley.newRequestQueue(getApplicationContext());
                            balanceRequest.add(balanceGetRequest);






                        }
                    });






                }


            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                Toast.makeText(Trade.this, error.toString().trim(), Toast.LENGTH_SHORT).show();
            }
        });

        RequestQueue listingsRequestQueue = Volley.newRequestQueue(getApplicationContext());
        listingsRequestQueue.add(listingsGetRequest);


    }
}