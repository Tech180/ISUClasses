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

public class Balance extends AppCompatActivity {

    private String URL ="http://coms-309-066.cs.iastate.edu:8080/users/";
    //private EditText enteredBal;
    private double balanceNum;
    private String balance;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_balance);

        //toolbar
        Toolbar toolbar = findViewById(R.id.toolBar);
        getSupportActionBar().setTitle("Balance");

        //getUsername (it is getName for now since we don't have usernames yet)
        StringRequest balanceGetRequest = new StringRequest(Request.Method.GET, URL + ServerRequest.idHard + "/getBalance/", new Response.Listener<String>() {
            @Override
            public void onResponse(String response) {
                Log.i("Error: ", response.toString());
                String bal = response;
                //Toast.makeText(Balance.this, bal, Toast.LENGTH_SHORT).show();
                EditText editText = (EditText) findViewById(R.id.valueToAdd);
                editText.setText(bal);
            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                Toast.makeText(Balance.this, error.toString().trim(), Toast.LENGTH_SHORT).show();
            }
        });

        RequestQueue balanceRequest = Volley.newRequestQueue(getApplicationContext());
        balanceRequest.add(balanceGetRequest);

        Button addBalance = (Button)findViewById(R.id.addBalance);
        //Button balanceInc = (Button) findViewById(R.id.balance); //go to settings from button
        addBalance.setOnClickListener(new View.OnClickListener(){
            public void onClick(View v){

                TextView enteredBal = (TextView) findViewById(R.id.valueToAdd);
                balanceNum = Double.parseDouble(enteredBal.getText().toString()); //enteredBal to balance
                balance = String.valueOf(balanceNum);

                StringRequest balanceSetRequest = new StringRequest(Request.Method.PUT, URL + ServerRequest.idHard + "/addBalance/" + balance, new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        Log.i("Error: ", response.toString());
                        //balance = response;
                        Toast.makeText(Balance.this, response, Toast.LENGTH_SHORT).show();
                        //Button button = (Button)findViewById(R.id.balance);
                        //button.setText(balance);
                    }
                }, new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {
                        Toast.makeText(Balance.this, error.toString().trim(), Toast.LENGTH_SHORT).show();
                        Toast.makeText(Balance.this, balance, Toast.LENGTH_SHORT).show();

                    }
                });

                RequestQueue requestQueue = Volley.newRequestQueue(getApplicationContext());
                requestQueue.add(balanceSetRequest);


            }
        });




        Button transButton = (Button)findViewById(R.id.transButton);
        transButton.setOnClickListener(new View.OnClickListener(){
            public void onClick(View v){

                startActivity(new Intent(Balance.this, Transactions.class));




            }
        });




    }

    public boolean checkFunds(Double balance, Double listingPrice){
        if(balance < listingPrice){
            return false;
        }
        else{
            return true;
        }

    }

}