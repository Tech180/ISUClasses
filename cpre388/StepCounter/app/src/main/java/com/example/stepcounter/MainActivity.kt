package com.example.stepcounter

import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button
import android.widget.TextView

class MainActivity : AppCompatActivity(), SensorEventListener {

    private lateinit var sensorManager: SensorManager
    private lateinit var stepCountTextView: TextView
    private lateinit var resetButton: Button

    private var stepCount: Int = 0
    private var accelerationValue: Float = 0.0f
    private var isStepDetected: Boolean = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        stepCountTextView = findViewById(R.id.stepCount)
        resetButton = findViewById(R.id.resetButton)

        sensorManager = getSystemService(SENSOR_SERVICE) as SensorManager

        val accelerometer = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)
        if (accelerometer != null) {
            sensorManager.registerListener(this, accelerometer, SensorManager.SENSOR_DELAY_NORMAL)
        }

        /*
        val stepCounterSensor = sensorManager.getDefaultSensor(Sensor.TYPE_STEP_COUNTER)
        if (stepCounterSensor != null) {
            sensorManager.registerListener(this, stepCounterSensor, SensorManager.SENSOR_DELAY_NORMAL)
        }
         */

        resetButton.setOnClickListener {
            resetStepCount()
        }
    }

    override fun onSensorChanged(event: SensorEvent) {
        if (event.sensor.type == Sensor.TYPE_ACCELEROMETER) {
            val currentAccelerationValue = event.values[0] + event.values[1] + event.values[2]

            val threshold = 10.0f

            if (accelerationValue < threshold && currentAccelerationValue >= threshold) {
                // Step detected
                if (!isStepDetected) {
                    stepCount++
                    isStepDetected = true
                    updateStepCount(stepCount)
                }
            } else {
                isStepDetected = false
            }

            accelerationValue = currentAccelerationValue
        }
    }

    /*
    override fun onSensorChanged(event: SensorEvent) {
        if (event.sensor.type == Sensor.TYPE_STEP_COUNTER) {
            stepCount = event.values[0].toInt()
            updateStepCount(stepCount)
        }
    }
     */

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}

    private fun updateStepCount(count: Int) {
        stepCountTextView.text = "Steps: $count"
    }

    private fun resetStepCount() {
        stepCount = 0
        updateStepCount(stepCount)
    }

    override fun onResume() {
        super.onResume()

        val accelerometer = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)
        if (accelerometer != null) {
            sensorManager.registerListener(this, accelerometer, SensorManager.SENSOR_DELAY_NORMAL)
        }


        /*
        val stepCounterSensor = sensorManager.getDefaultSensor(Sensor.TYPE_STEP_COUNTER)
        if (stepCounterSensor != null) {
            sensorManager.registerListener(this, stepCounterSensor, SensorManager.SENSOR_DELAY_NORMAL)
        }
         */
    }

    override fun onPause() {
        super.onPause()
        sensorManager.unregisterListener(this)
    }
}