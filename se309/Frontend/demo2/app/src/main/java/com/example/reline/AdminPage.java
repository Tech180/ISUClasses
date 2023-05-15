package com.example.reline;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;

import android.content.Intent;
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
import com.example.reline.databinding.ActivityAdminPageBinding;
import com.example.reline.databinding.ActivityHomeBinding;
import com.google.android.material.appbar.CollapsingToolbarLayout;

import org.json.JSONArray;
import org.json.JSONException;

public class AdminPage extends AppCompatActivity {

    private String URL ="http://coms-309-066.cs.iastate.edu:8080/users/";
    private ActivityAdminPageBinding binding;
    private String[] arr;

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
        setContentView(R.layout.activity_admin_page);

        //set toolbar to admin
        Toolbar toolbar = findViewById(R.id.toolBar);
        getSupportActionBar().setTitle("Admin");


        //getIds
        JsonArrayRequest idsGetRequest = new JsonArrayRequest(Request.Method.GET, URL,null, new Response.Listener<JSONArray>() {
            @Override
            public void onResponse(JSONArray response) {

                LinearLayout linearLayout = findViewById(R.id.userLayout);

                for( int i = 0; i < response.length(); i++ )
                {
                    //String id = arr[i];
                    //String username = getUsername(id);
                    TextView textView = new TextView(AdminPage.this);
                    //textView.setText(arr[i]);
                    textView.setText(response.optJSONObject(i).optString("username") + " ID: " + response.optJSONObject(i).optString("id"));
                    linearLayout.addView(textView);
                    textView.setTextSize(24);
                    textView.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View view) {
                            //ServerRequest.idHard = textView.getText().toString();
                           // Toast.makeText(AdminPage.this, textView.getText().toString(), Toast.LENGTH_SHORT).show();
                            String str = textView.getText().toString();
                            Toast.makeText(AdminPage.this, "Loading ID: " + str.substring(Math.max(str.length() - 2, 0)) + " Profile", Toast.LENGTH_SHORT).show();
                            ServerRequest.idHard = str.substring(Math.max(str.length() - 2, 0));
                            startActivity(new Intent(AdminPage.this, Profile.class));
                        }
                    });
                }
            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                Toast.makeText(AdminPage.this, error.toString().trim(), Toast.LENGTH_SHORT).show();
            }
        });

        RequestQueue idsRequestQueue = Volley.newRequestQueue(getApplicationContext());
        idsRequestQueue.add(idsGetRequest);
    }

    /* Use for Home Page as well
    public void createTextViews(String[] arr){

        LinearLayout linearLayout = findViewById(R.id.userLayout);

        for( int i = 0; i < arr.length; i++ )
        {
            //String id = arr[i];
            //String username = getUsername(id);
            TextView textView = new TextView(this);
            textView.setText(arr[i]);
            linearLayout.addView(textView);
            textView.setTextSize(24);
            textView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    //ServerRequest.idHard = arr[i];
                    //ServerRequest.idHard = textView.getText().toString();
                    Toast.makeText(AdminPage.this, textView.getText().toString(), Toast.LENGTH_SHORT).show();
                    startActivity(new Intent(AdminPage.this, Profile.class));
                }
            });
        }

    }

     */

}
