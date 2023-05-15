package com.example.reline;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import com.android.volley.AuthFailureError;
import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;

import java.util.HashMap;
import java.util.Map;


public class Register extends AppCompatActivity {
    private EditText etUsername, etName, etEmail, etPassword, etReenterPassword;
    private TextView tvStatus;
    private Button btnRegister;
    private String URL = "http://3sc1:309_Reline@coms-309-066.cs.iastate.edu:8080/users/";
    private String username, password, reenterPassword;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.register);
        etUsername = findViewById(R.id.etUsernameReg);
        etPassword = findViewById(R.id.etPasswordReg);
        etReenterPassword = findViewById(R.id.etReenterPasswordReg);
        btnRegister = findViewById(R.id.btnRegister);
        //name = email = password = reenterPassword = "";
    }

    public void registerUser(View view) {
        username = etUsername.getText().toString().trim();
        password = etPassword.getText().toString().trim();
        reenterPassword = etReenterPassword.getText().toString().trim();

        if (!password.equals(reenterPassword)) {
            Toast.makeText(Register.this, "Password Mismatch", Toast.LENGTH_SHORT).show();
        }
        else if (password.equals(reenterPassword)) {
            ServerRequest sr = new ServerRequest();
            sr.newUser(username, password, this);
        }
    }

    public void login(View view) {
        Intent intent = new Intent(this, MainActivity.class);
        startActivity(intent);
        finish();
    }
}