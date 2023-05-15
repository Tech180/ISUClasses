package com.example.reline;

import androidx.appcompat.app.AppCompatActivity;

import android.app.ProgressDialog;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;
//import com.google.gson.annotations.SerializedName;

import javax.xml.transform.ErrorListener;

/*import retrofit2.Call;
import retrofit2.Callback;
//import retrofit2.Response;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;
import retrofit2.http.GET;*/


public class activity_string extends AppCompatActivity {

    private static final String TAG = activity_string.class.getName();
    private Button btnRequest;

    private RequestQueue mRequestQueue;
    private StringRequest mStringRequest;
    private String url = "https://2ed7ae3b-9ceb-47c9-b2a3-efb212a2e49d.mock.pstmn.io";

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_string);

        btnRequest = (Button) findViewById(R.id.button4);

        btnRequest.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                sendAndRequestResponse();
            }
        }
        );

        /*TextView apiText1 = findViewById(R.id.activity_string_textView1);

        Retrofit retrofit = new Retrofit.Builder()
                .baseUrl("https://jsonplaceholder.typicode.com/")
                .addConverterFactory(GsonConverterFactory.create())
                .build();

        PostApi apiClient = retrofit.create(PostApi.class);

        apiClient.getFirstPost().enqueue(new Callback<Post>() {
            @Override
            public void onResponse(Call<Post> call, Response<Post> response) {
                apiText1.setText(response.body().getBigText());
            }

            @Override
            public void onFailure(Call<Post> call, Throwable t) {
                //used to log failures by using t
            }
        });*/
    }
    private void sendAndRequestResponse() {

        //RequestQueue initialised
        mRequestQueue = Volley.newRequestQueue(this);

        //String Request initialised
        mStringRequest = new StringRequest(Request.Method.GET, url, new Response.Listener<String>() {
            @Override
            public void onResponse(String response) {

                Toast.makeText(getApplicationContext(), "Response : " + response.toString(), Toast.LENGTH_LONG).show(); //display the response on screen

            }
        }, new Response.ErrorListener() {
            @Override
                    public void onErrorResponse(VolleyError error) {

                Log.i(TAG,"Error : " + error.toString());
            }
        }
        );

        mRequestQueue.add(mStringRequest);
    }

}

/*interface PostApi {

    @GET("posts/1")
    Call<Post> getFirstPost();

}

class Post {
    private int userId;
    private int id;
    private String title;

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getBigText() {
        return bigText;
    }

    public void setBigText(String bigText) {
        this.bigText = bigText;
    }

    @SerializedName("body")
    private String bigText;

}*/
