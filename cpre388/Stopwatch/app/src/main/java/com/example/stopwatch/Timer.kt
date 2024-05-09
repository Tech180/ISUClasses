package com.example.stopwatch

import android.os.Handler
import android.os.Looper
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel

class Timer : ViewModel() {

    var start : Long = 0;
    var running = false

    var update = 10
    //var elapsed : Long = 0;

    var elapsed = MutableLiveData<Long>()
    val time : LiveData<Long>
        get() = elapsed

    var handler = Handler(Looper.getMainLooper())

    var runnable : Runnable = object : Runnable {
        override fun run() {
            if(running) {
                elapsed.value = System.currentTimeMillis() - start
                handler.postDelayed(this, update.toLong())
            }
        }
    }

    init {
        elapsed.value = 0
    }

    fun startTimer() {
        if(!running) {
            start = System.currentTimeMillis() - (elapsed.value ?: 0)
            running = true
            handler.post(runnable)
        }
    }

    fun stopTimer() {
        if(running) {
            running = false
            handler.removeCallbacks(runnable)
        }
    }

    fun resetTimer() {
        running = false
        start = 0
        elapsed.value = 0
        handler.removeCallbacks(runnable)
    }
}