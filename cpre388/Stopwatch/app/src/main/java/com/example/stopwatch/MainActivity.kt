package com.example.stopwatch

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button
import android.widget.TextView
import androidx.lifecycle.Observer
import androidx.lifecycle.ViewModelProvider


class MainActivity : AppCompatActivity() {

    lateinit var viewModel : Timer
    var running = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        viewModel = ViewModelProvider(this).get(Timer::class.java)

        var startButton = findViewById<Button>(R.id.startButton)
        var resetButton = findViewById<Button>(R.id.resetButton)
        var timerText = findViewById<TextView>(R.id.timerText)

        viewModel.time.observe(this, Observer {
            time -> var format = formatTime(time)
            timerText.text = format
        })

        startButton.setOnClickListener {
            if(running) {
                viewModel.stopTimer()
                startButton.text = getString(R.string.start)
            }
            else {
                viewModel.startTimer()
                startButton.text = getString(R.string.stop)
            }

            // Running toggle
            running = !running
        }

        resetButton.setOnClickListener {
            viewModel.resetTimer()
            startButton.text = "Start"
            running = false
        }

        //Handler(Looper.getMainLooper()).postDelayed({

        //}, 3000)
    }

    fun formatTime(time : Long): String {
        var hours = (time / 3600000).toString().padStart(2, '0')
        var min = ((time % 3600000) / 60000).toString().padStart(2, '0')
        var sec = ((time % 60000) / 1000).toString().padStart(2, '0')
        var millis = ((time % 1000) / 100).toString()

        return "$hours:$min:$sec:$millis"
    }
}