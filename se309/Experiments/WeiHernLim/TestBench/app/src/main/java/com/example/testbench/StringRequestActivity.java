package com.example.testbench;

import static android.content.ContentValues.TAG;

import androidx.appcompat.app.AppCompatActivity;

import android.app.ProgressDialog;
import android.os.Bundle;
import android.util.Log;

import com.android.volley.toolbox.StringRequest;

public class StringRequestActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_string);
    }

    // Tag used to cancel the request String	tag_string_req ="string_req";

    String url = "https://api.androidhive.info/volley/string_response.html";

    ProgressDialog pDialog = newProgressDialog(this); pDialog.setMessage("Loading..."); pDialog.show();

    StringRequest strReq = newStringRequest(Method.GET,
            url, newResponse.Listener <String> () {

        @Override
                publicvoidonResponse(String response) {
        Log.d(TAG, response.toString());
        pDialog.hide();

    }
    },newResponse.ErrorListener()

    {

        @Override publicvoidonErrorResponse(VolleyError error) {
        VolleyLog.d(TAG, "Error: " + error.getMessage());
        pDialog.hide();

    }
    });





AppController.getInstance().addToRequestQueue(strReq, tag_string_req);

}