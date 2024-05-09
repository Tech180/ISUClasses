package com.example.mapruler

import android.Manifest
import android.content.pm.PackageManager
import android.location.Address
import android.location.Geocoder
import android.location.Location
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.text.InputType
import android.widget.Button
import android.widget.EditText
import android.widget.Toast
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat

import com.google.android.gms.maps.CameraUpdateFactory
import com.google.android.gms.maps.GoogleMap
import com.google.android.gms.maps.OnMapReadyCallback
import com.google.android.gms.maps.SupportMapFragment
import com.google.android.gms.maps.model.LatLng
import com.google.android.gms.maps.model.MarkerOptions
import com.example.mapruler.databinding.ActivityMapsBinding
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationServices
import com.google.android.gms.maps.model.MapStyleOptions
import java.io.IOException

class MapsActivity : AppCompatActivity(), OnMapReadyCallback {

    private lateinit var mMap: GoogleMap
    private lateinit var binding: ActivityMapsBinding

    private lateinit var fusedLocationClient: FusedLocationProviderClient
    private val locationPermissionCode = 123

    private lateinit var locationEditText: EditText
    private lateinit var calculateDistanceButton: Button


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        binding = ActivityMapsBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // Initialize the FusedLocationProviderClient
        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)

        // Check for location permissions
        //checkLocationPermission()

        locationEditText = findViewById(R.id.locationEditText)
        locationEditText.inputType = InputType.TYPE_CLASS_TEXT

        calculateDistanceButton = findViewById(R.id.calculateDistanceButton)

        calculateDistanceButton.setOnClickListener {
            val enteredLocation = locationEditText.text.toString()
            if (enteredLocation.isNotEmpty()) {
                val chosenLocation = address(enteredLocation)
                if (chosenLocation != null) {
                    userLocationandDistance(chosenLocation)
                }
            }
        }

        // Obtain the SupportMapFragment and get notified when the map is ready to be used.
        val mapFragment = supportFragmentManager
            .findFragmentById(R.id.map) as SupportMapFragment
        mapFragment.getMapAsync(this)
    }

    /**
     * Manipulates the map once available.
     * This callback is triggered when the map is ready to be used.
     * This is where we can add markers or lines, add listeners or move the camera. In this case,
     * we just add a marker near Sydney, Australia.
     * If Google Play services is not installed on the device, the user will be prompted to install
     * it inside the SupportMapFragment. This method will only be triggered once the user has
     * installed Google Play services and returned to the app.
     */
    override fun onMapReady(googleMap: GoogleMap) {
        mMap = googleMap

        // Add a marker in Sydney and move the camera
        //val sydney = LatLng(-34.0, 151.0)
        //mMap.addMarker(MarkerOptions().position(sydney).title("Marker in Sydney"))
        //mMap.moveCamera(CameraUpdateFactory.newLatLng(sydney))

        // Get the user's current location and add a marker
        if (checkLocationPermission()) {
            fusedLocationClient.lastLocation.addOnSuccessListener { location -> location?.let {
                    // Create a marker for the user's location
                    val userLocation = LatLng(it.latitude, it.longitude)
                    mMap.addMarker(MarkerOptions().position(userLocation).title("Your Location"))
                    mMap.moveCamera(CameraUpdateFactory.newLatLng(userLocation))

                    // Create a marker for the user's location
                    val chosenLocation = address("Address")

                    chosenLocation?.let {
                        distance(userLocation, it)
                    }
                }
            }
        }

        // Load and apply a custom map style
        var mapStyleOptions = MapStyleOptions.loadRawResourceStyle(this, R.raw.mapstyle_mine)
        mMap.setMapStyle(mapStyleOptions)
    }

    private fun checkLocationPermission(): Boolean {
        val permission = Manifest.permission.ACCESS_FINE_LOCATION
        if (ContextCompat.checkSelfPermission(this, permission) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this, arrayOf(permission), locationPermissionCode)
            return false
        }
        return true
    }

    private fun address(addressString: String): LatLng? {
        val geocoder = Geocoder(this)
        val addresses: List<Address>? = geocoder.getFromLocationName(addressString, 1)

        // Request location permission if not granted
        if (addresses != null && addresses.isNotEmpty()) {
            val latitude = addresses[0].latitude
            val longitude = addresses[0].longitude
            return LatLng(latitude, longitude)
        }

        return null
    }

    //your location
    private fun userLocationandDistance(chosenLocation: LatLng) {
        checkLocationPermission()
        fusedLocationClient.lastLocation.addOnSuccessListener { location ->
            location?.let {
                val userLocation = LatLng(it.latitude, it.longitude)
                mMap.addMarker(MarkerOptions().position(userLocation).title("Your Location"))
                mMap.moveCamera(CameraUpdateFactory.newLatLng(userLocation))
                distance(userLocation, chosenLocation)
            }
        }
    }

    private fun distance(userLocation: LatLng, chosenLocation: LatLng) {
        val results = FloatArray(1)
        Location.distanceBetween(
            userLocation.latitude, userLocation.longitude,
            chosenLocation.latitude, chosenLocation.longitude,
            results
        )

        val meters = results[0]
        val kilometers = meters / 1000
        val miles = meters * 0.000621371
        val distanceMessage = "Distance: ${"%.2f".format(kilometers)} km / ${"%.2f".format(miles)} miles"

        // Display the distance in a Toast
        Toast.makeText(this, distanceMessage, Toast.LENGTH_SHORT).show()
    }

}