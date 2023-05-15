package com.example.reline;

import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
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

import org.json.JSONArray;

public class Transactions extends AppCompatActivity {

    private String URL ="http://coms-309-066.cs.iastate.edu:8080/users/";
    private String URLtrans ="http://coms-309-066.cs.iastate.edu:8080/transactions/";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_transactions);

        //toolbar
        Toolbar toolbar = findViewById(R.id.toolBar);
        getSupportActionBar().setTitle("Transactions");


        JsonArrayRequest transGetRequest = new JsonArrayRequest(Request.Method.GET, URLtrans,null, new Response.Listener<JSONArray>() {
            @Override
            public void onResponse(JSONArray response) {



                for( int i = 0; i < response.length(); i++ )
                {

                    //String transID = response.optJSONObject(i).optString("id");


                    JsonArrayRequest transGetRequest = new JsonArrayRequest(Request.Method.GET, URLtrans + response.optJSONObject(i).optString("id"),null, new Response.Listener<JSONArray>() {
                        @Override
                        public void onResponse(JSONArray response) {

                            LinearLayout linearLayout = findViewById(R.id.transLinear);



                            int j = 0;



                                //Username
                                TextView textViewUsernameBuyer = new TextView(Transactions.this);
                                textViewUsernameBuyer.setText("Buyer: " + response.optJSONObject(j).optString("username"));
                                textViewUsernameBuyer.setTextSize(28);
                                linearLayout.addView(textViewUsernameBuyer);

                                j++;

                                //Username
                                TextView textViewUsernameSeller = new TextView(Transactions.this);
                                textViewUsernameSeller.setText("Seller: " + response.optJSONObject(j).optString("username"));
                                textViewUsernameSeller.setTextSize(28);
                                linearLayout.addView(textViewUsernameSeller);

                                j++;

                                //Title
                                TextView textViewListing = new TextView(Transactions.this);
                                textViewListing.setText("Title: " + response.optJSONObject(j).optString("title"));
                                textViewListing.setTextSize(28);
                                linearLayout.addView(textViewListing);

                                //Price
                                TextView textViewPrice = new TextView(Transactions.this);
                                Float priceFloat = Float.parseFloat(response.optJSONObject(j).optString("price"));
                                textViewPrice.setText("Price: $" + String.format("%.2f", priceFloat));
                                textViewPrice.setTextSize(28);
                                linearLayout.addView(textViewPrice);

                                if(response.length() == 4){
                                    j++;
                                    //Title
                                    TextView textViewListing2 = new TextView(Transactions.this);
                                    textViewListing2.setText("Title: " + response.optJSONObject(j).optString("title"));
                                    textViewListing2.setTextSize(28);
                                    linearLayout.addView(textViewListing2);

                                    //Price
                                    TextView textViewPrice2 = new TextView(Transactions.this);
                                    Float priceFloat2 = Float.parseFloat(response.optJSONObject(j).optString("price"));
                                    textViewPrice2.setText("Price: $" + String.format("%.2f", priceFloat2));
                                    textViewPrice2.setTextSize(28);
                                    linearLayout.addView(textViewPrice2);



                                }



                            //Spacer
                            TextView textViewSpacer = new TextView(Transactions.this);
                            textViewSpacer.setText(" ");
                            textViewSpacer.setTextSize(15);
                            linearLayout.addView(textViewSpacer);








                        }
                    }, new Response.ErrorListener() {
                        @Override
                        public void onErrorResponse(VolleyError error) {
                            Toast.makeText(Transactions.this, error.toString().trim(), Toast.LENGTH_SHORT).show();
                        }
                    });

                    RequestQueue transRequestQueue = Volley.newRequestQueue(getApplicationContext());
                    transRequestQueue.add(transGetRequest);

                }


                    /*

                    //listingInvolved
                    TextView textViewLI = new TextView(Transactions.this);
                    textViewLI.setText("Listing Involved: " + response.optJSONObject(i).optString("listingInvolved"));
                    textViewLI.setTextSize(28);
                    linearLayout.addView(textViewLI);

                    //getUsername
                    StringRequest usernameSellGetRequest = new StringRequest(Request.Method.GET, URL + response.optJSONObject(i).optString("userSelling") + "/getUsername/", new Response.Listener<String>() {
                        @Override
                        public void onResponse(String responseUsernameSell) {
                            //userSelling
                            TextView textViewUS = new TextView(Transactions.this);
                            textViewUS.setText("User Selling: " + responseUsernameSell);
                            textViewUS.setTextSize(28);
                            linearLayout.addView(textViewUS);
                        }
                    }, new Response.ErrorListener() {
                        @Override
                        public void onErrorResponse(VolleyError error) {
                            Toast.makeText(Transactions.this, error.toString().trim(), Toast.LENGTH_SHORT).show();
                        }
                    });

                    RequestQueue usernameSellRequestQueue = Volley.newRequestQueue(getApplicationContext());
                    usernameSellRequestQueue.add(usernameSellGetRequest);



                    //getUsername
                    StringRequest usernameBuyGetRequest = new StringRequest(Request.Method.GET, URL + response.optJSONObject(i).optString("userBuying") + "/getUsername/", new Response.Listener<String>() {
                        @Override
                        public void onResponse(String responseUsernameBuy) {
                            //userBuying
                            TextView textViewUB = new TextView(Transactions.this);
                            textViewUB.setText("User Buying: " + responseUsernameBuy);
                            textViewUB.setTextSize(28);
                            linearLayout.addView(textViewUB);
                        }
                    }, new Response.ErrorListener() {
                        @Override
                        public void onErrorResponse(VolleyError error) {
                            Toast.makeText(Transactions.this, error.toString().trim(), Toast.LENGTH_SHORT).show();
                        }
                    });

                    RequestQueue usernameBuyRequestQueue = Volley.newRequestQueue(getApplicationContext());
                    usernameBuyRequestQueue.add(usernameBuyGetRequest);









                    //Spacer
                    TextView textViewSpacer = new TextView(Transactions.this);
                    textViewSpacer.setText(" ");
                    textViewSpacer.setTextSize(15);
                    linearLayout.addView(textViewSpacer);


                     */





                    /*
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

                     */




                    /*



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


                        */


                /*
                //ADD EXTRA SPACE FOR NAV BAR
                //LinearLayout linearLayout = findViewById(R.id.homeLinear);
                TextView textViewSpacer = new TextView(Home.this);
                textViewSpacer.setText(" ");
                textViewSpacer.setTextSize(50);
                linearLayout.addView(textViewSpacer);

                 */




            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                Toast.makeText(Transactions.this, error.toString().trim(), Toast.LENGTH_SHORT).show();
            }
        });

        RequestQueue transRequestQueue = Volley.newRequestQueue(getApplicationContext());
        transRequestQueue.add(transGetRequest);



    }


}