package edu.iastate.cpre388.memoryleak;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.Toast;

import java.util.ArrayList;
import java.util.List;

public class MainActivity extends AppCompatActivity {

    private static final String TAG = "MainActivity";
    private final int NUM_CATS = 1000000;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        BigRedButton button = new BigRedButton(this);
        button.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    for(int i = 0; i < NUM_CATS; i++) {
                        Cat cat = new Cat(getString(R.string.cat_name),
                                7,
                                getString(R.string.cat_color));
                    }
                    Toast.makeText(getApplicationContext(),
                            getString(R.string.cat_toast, NUM_CATS),
                            Toast.LENGTH_LONG).show();
                }
        });

        LinearLayout layout = findViewById(R.id.linearLayout);
        layout.addView(button);
    }
}