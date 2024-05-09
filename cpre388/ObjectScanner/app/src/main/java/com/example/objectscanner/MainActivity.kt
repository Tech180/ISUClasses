package com.example.objectscanner

import android.Manifest
import android.content.pm.PackageManager
import android.os.Bundle
import android.util.Log
import android.util.Size
import android.widget.TextView
import androidx.annotation.OptIn
import androidx.appcompat.app.AppCompatActivity
import androidx.camera.core.CameraSelector
import androidx.camera.core.ExperimentalGetImage
import androidx.camera.core.ImageAnalysis
import androidx.camera.core.ImageProxy
import androidx.camera.core.Preview
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.camera.view.PreviewView
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.lifecycle.LifecycleOwner
import com.google.common.util.concurrent.ListenableFuture
import com.google.mlkit.vision.common.InputImage
import com.google.mlkit.vision.label.ImageLabel
import com.google.mlkit.vision.label.ImageLabeler
import com.google.mlkit.vision.label.ImageLabeling
import com.google.mlkit.vision.label.defaults.ImageLabelerOptions
import com.google.mlkit.vision.objects.ObjectDetection
import java.util.concurrent.Executor
import java.util.concurrent.Executors

class MainActivity : AppCompatActivity() {

    private lateinit var previewView: PreviewView
    private lateinit var cameraProvider: ProcessCameraProvider
    //private lateinit var cameraProvider : ListenableFuture<ProcessCameraProvider>
    private lateinit var cameraSelector: CameraSelector
    private lateinit var executor: Executor
    private lateinit var imageLabeler: ImageLabeler
    private lateinit var objectDetector: ObjectDetection

    private val REQUEST_CAMERA_PERMISSION = 1

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        // Check if the CAMERA permission is granted
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED) {
            // Request CAMERA permission if it's not granted
            ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.CAMERA), REQUEST_CAMERA_PERMISSION)
        }
        else {
            // CAMERA permission is already granted, proceed with camera initialization and ML Kit setup
            //Log.d("Camera Initalized", "processing...")
            //initializeMLKit()
            initializeCamera()
            //initializeMLKit()
        }

        // Initialize preview view
        previewView = findViewById(R.id.previewView)  // Make sure you have a PreviewView with this ID

        // Configure implementation mode (PERFORMANCE or COMPATIBLE) for PreviewView
        previewView.implementationMode = PreviewView.ImplementationMode.PERFORMANCE

        // Configure scale type (FIT_CENTER, FIT_START, FILL_CENTER, FILL_START) for PreviewView
        previewView.scaleType = PreviewView.ScaleType.FIT_CENTER

        // Initialize the executor for image analysis (use a background thread)
        executor = Executors.newSingleThreadExecutor()
    }

    private fun initializeMLKit() {
        // Configure the options for the ImageLabeler (you can adjust these as needed)
        //val labelerOptions = ImageLabelerOptions.Builder() .setConfidenceThreshold(0.8f) .build()
        val labelerOptions = ImageLabelerOptions.DEFAULT_OPTIONS

        try {
            // Initialize the ImageLabeler with the configured options
            imageLabeler = ImageLabeling.getClient(labelerOptions)
        }
        catch (e: Exception) {
            Log.e("LabelerInitialization", "Error initializing ImageLabeler: ${e.message}", e)
        }

    }

    @OptIn(ExperimentalGetImage::class)
    private fun processImage(imageProxy: ImageProxy) {
        val mediaImage = imageProxy.image

        if (mediaImage != null && ::imageLabeler.isInitialized) {
            val rotationDegrees = imageProxy.imageInfo.rotationDegrees
            val inputImage = InputImage.fromMediaImage(mediaImage, rotationDegrees)

            // Use the ImageLabeler to label the image
            imageLabeler.process(inputImage).addOnSuccessListener { labels ->
                processLabels(labels)
            }.addOnFailureListener { e ->
                // Handle the failure of label detection here
                Log.e("LabelDetection", "Error detecting labels: ${e.message}", e)
            }
        }
    }

    /*
    override fun analyze() {

    }
     */

    private fun processLabels(labels: List<ImageLabel>) {
        val labelTextView = findViewById<TextView>(R.id.labelTextView)

        // Process the labels and display them
        val labelString = StringBuilder()
        for (label in labels) {
            val text = label.text
            val confidence = label.confidence
            val index = label.index
            labelString.append("Label: $text\nConfidence: $confidence\nIndex: $index\n\n")
        }

        //background thread
        runOnUiThread {
            labelTextView.text = labelString.toString()
        }
    }



    private fun initializeCamera() {
        val cameraProviderFuture: ListenableFuture<ProcessCameraProvider> = ProcessCameraProvider.getInstance(this)

        cameraProviderFuture.addListener({
            cameraProvider = cameraProviderFuture.get()

            // Set up the camera
            cameraSelector = CameraSelector.DEFAULT_BACK_CAMERA

            // Create and bind the Preview use case to the PreviewView
            val preview = Preview.Builder().build()
            preview.setSurfaceProvider(previewView.surfaceProvider)

            // Set up image analysis
            val imageAnalysis = ImageAnalysis.Builder()
                .setOutputImageFormat(ImageAnalysis.OUTPUT_IMAGE_FORMAT_RGBA_8888)
                .setTargetResolution(Size(1280, 720))
                .setBackpressureStrategy(ImageAnalysis.STRATEGY_KEEP_ONLY_LATEST)
                .build()

            imageAnalysis.setAnalyzer(executor) { imageProxy ->
                processImage(imageProxy)
            }

            // Bind the use cases to the lifecycle
            cameraProvider.bindToLifecycle(this as LifecycleOwner, cameraSelector, preview, imageAnalysis)
        }, ContextCompat.getMainExecutor(this))
    }
}