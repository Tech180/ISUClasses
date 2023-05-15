package com.example.anotherdemo;

import androidx.appcompat.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.content.Intent;

public class LoginPage extends AppCompatActivity {
    private Button button;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login_page);

        button = findViewById(R.id.button2);
        button.setOnClickListener(new View.OnClickListener() {
            @Override
                    public void onClick(View v) {
                openRegistrationPage();
            }
        });
    }

    public void openRegistrationPage() {
        Intent intent = new Intent(this, RegistrationPage.class);
        startActivity(intent);
    }
}
