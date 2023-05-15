package com.example.reline;

import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
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
import com.google.android.material.floatingactionbutton.FloatingActionButton;
import com.google.android.material.snackbar.Snackbar;

public class Settings extends AppCompatActivity implements UsernameView {
    private String URL ="http://coms-309-066.cs.iastate.edu:8080/users/";
    private UsernamePresenter presenter;
    private UsernameView view;
    private Context context;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_settings);

        //toolbar
        Toolbar toolbar = findViewById(R.id.toolBar);
        getSupportActionBar().setTitle("Settings");

        AlertDialog.Builder builder = new AlertDialog.Builder(this);

        builder.setTitle("Confirm");
        builder.setMessage("Are you sure you want to DELETE this account?");

        builder.setPositiveButton("YES", new DialogInterface.OnClickListener() {

            public void onClick(DialogInterface dialog, int which) {

                if(!ServerRequest.idHard.equals("52")){
                    //Delete User
                    StringRequest usernameGetRequest = new StringRequest(Request.Method.DELETE, URL + "delete/" + ServerRequest.idHard, new Response.Listener<String>() {
                        @Override
                        public void onResponse(String response) {
                            Toast.makeText(Settings.this, "Profile Deleted: " + response, Toast.LENGTH_SHORT).show();
                        }
                    }, new Response.ErrorListener() {
                        @Override
                        public void onErrorResponse(VolleyError error) {
                            Toast.makeText(Settings.this, error.toString().trim(), Toast.LENGTH_SHORT).show();
                        }
                    });

                    RequestQueue usernameRequestQueue = Volley.newRequestQueue(getApplicationContext());
                    usernameRequestQueue.add(usernameGetRequest);
                }
                else{
                    Toast.makeText(Settings.this, "ADMIN cannot be deleted", Toast.LENGTH_SHORT).show();
                }

                dialog.dismiss();
            }
        });

        builder.setNegativeButton("NO", new DialogInterface.OnClickListener() {

            @Override
            public void onClick(DialogInterface dialog, int which) {
                if(ServerRequest.idHard.equals("52")) {
                    Toast.makeText(Settings.this, "ADMIN cannot be deleted", Toast.LENGTH_SHORT).show();
                }
                Toast.makeText(Settings.this, "No Deletion", Toast.LENGTH_SHORT).show();

                // Do nothing
                dialog.dismiss();
            }
        });


        Button deleteButton = (Button)findViewById(R.id.deleteProfile);
        //Button balanceInc = (Button) findViewById(R.id.balance); //go to settings from button
        deleteButton.setOnClickListener(new View.OnClickListener(){
            public void onClick(View v){

                AlertDialog alert = builder.create();
                alert.show();
            }
        });


        //getUsername
        StringRequest usernameGetRequest = new StringRequest(Request.Method.GET, URL + ServerRequest.idHard + "/getUsername/", new Response.Listener<String>() {
            @Override
            public void onResponse(String response) {
                Log.i("Error: ", response.toString());
                String username = response;
                //Toast.makeText(Profile.this, balance, Toast.LENGTH_SHORT).show();
                EditText editText = (EditText) findViewById(R.id.usernameText);
                editText.setText(username);
                String usernameGet = getUsername(username); //call getUsername to return the current username
            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                Toast.makeText(Settings.this, error.toString().trim(), Toast.LENGTH_SHORT).show();
            }
        });

        RequestQueue usernameRequestQueue = Volley.newRequestQueue(getApplicationContext());
        usernameRequestQueue.add(usernameGetRequest);


        Button usernameChange = (Button)findViewById(R.id.changeUsername);
        //Button balanceInc = (Button) findViewById(R.id.balance); //go to settings from button
        usernameChange.setOnClickListener(new View.OnClickListener(){
            public void onClick(View v){

                TextView enteredUser = (TextView) findViewById(R.id.usernameText);
                String username = enteredUser.getText().toString(); //enteredBal to balance


                if(checkUsername(username) == true){
                    changeUsername(username);
                }
                else{
                    //do nothing
                }
                //changeUsername(username); //Call to changeUsername function @param username entered in textbox
            }
        });

        //error fab, default set to invisible, because no error to start.
        FloatingActionButton fab = (FloatingActionButton) findViewById(R.id.errorFab);
        fab.setVisibility(View.INVISIBLE);

    }

    @Override
    public void changeUsername(String newUsername) {
            StringRequest balanceGetRequest = new StringRequest(Request.Method.PUT, URL + ServerRequest.idHard + "/setUsername/" + newUsername, new Response.Listener<String>() {
                @Override
                public void onResponse(String response) {
                    Log.i("Error: ", response.toString());
                    //balance = response;
                    Toast.makeText(Settings.this, response, Toast.LENGTH_SHORT).show();

                    //Button button = (Button)findViewById(R.id.balance);
                    //button.setText(balance);
                }
            }, new Response.ErrorListener() {
                @Override
                public void onErrorResponse(VolleyError error) {
                    Toast.makeText(Settings.this, error.toString().trim(), Toast.LENGTH_SHORT).show();
                    //Toast.makeText(Settings.this, balance, Toast.LENGTH_SHORT).show();

                }
            });

            RequestQueue requestQueue = Volley.newRequestQueue(getApplicationContext());
            requestQueue.add(balanceGetRequest);
    }

    @Override
    public void showError() {
        //Button usernameChange = (Button)findViewById(R.id.changeUsername);
        FloatingActionButton fab = (FloatingActionButton) findViewById(R.id.errorFab);
        fab.setVisibility(View.VISIBLE);
    }

    @Override
    public void hideError() {
        FloatingActionButton fab = (FloatingActionButton) findViewById(R.id.errorFab);
        fab.setVisibility(View.INVISIBLE);
    }

    @Override
    public String getUsername(String username) {
        return username;
    }

    @Override
    public void setError(String error) {
            FloatingActionButton fab = (FloatingActionButton) findViewById(R.id.errorFab);
            fab.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    Snackbar.make(view, error, Snackbar.LENGTH_LONG)
                            .setAction("Action", null).show();
                }
            });
    }

    @Override
    public boolean underscoreStart(String username) {
            if(username.charAt(0) == '_'){
                view.showError();
                view.setError("Username starts with underscore");
                Log.d("underscore", username);
                return true;
            }
            else{
                view.hideError();
                return false;
            }

    }


    public boolean checkUsername(String username){
        FloatingActionButton fab = (FloatingActionButton) findViewById(R.id.errorFab);

        if(UsernamePresenter.emptyUsername(username) == true){
            fab.setVisibility(View.VISIBLE);
            setError("Username field is empty");
            return false;
        }
        if(UsernamePresenter.correctUsername(username) == true){
            fab.setVisibility(View.INVISIBLE);
            return true;
            //setError("Username has more than 15 Characters");
        }

        if(UsernamePresenter.moreThanFifteen(username) == true){
            fab.setVisibility(View.VISIBLE);
            setError("Username has more than 15 Characters");
            return false;
        }

        if(UsernamePresenter.underscoreStart(username) == true){
            fab.setVisibility(View.VISIBLE);
            setError("Username starts with an underscore");
            return false;
        }

        if(UsernamePresenter.specialChar(username) == true){
            fab.setVisibility(View.VISIBLE);
            setError("Username has a special character in it");
            return false;
        }

        return false;

    }

}