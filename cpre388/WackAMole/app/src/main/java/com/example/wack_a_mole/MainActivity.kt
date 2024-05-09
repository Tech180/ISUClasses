package com.example.wack_a_mole

import android.content.Context
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.os.Handler
import android.view.View
import android.widget.Button
import android.widget.ImageView
import android.widget.TextView
import android.media.MediaPlayer

/**
 * The main activity for Riley's Whac-A-Mole Game.
 * This activity manages the game's logic, user interface, and high score.
 */

class MainActivity : AppCompatActivity() {

    // List to store active and dead moles
    var moleMap: MutableList<Mole> = mutableListOf()
    var deadMoleMap: MutableList<Mole> = mutableListOf()

    // Track which dead mole to show next for the amount of misses you have made
    var deadMoleIndex = 1

    // View the current score
    lateinit var scoreText: TextView
    // View the current high score
    lateinit var highScoreText: TextView

    // The Current Score
    var score = 0
    // The Current High Score
    var highScore = 0

    // The number of misses when a mole isn't clicked goes up by one
    var miss = 0
    // The Maximum amount of misses allowed
    var maxMisses = 3

    // Handler for scheduling actions in the game
    var handler = Handler()

    // A flag that indicated whether the game is being played or not
    var game = false

    // Spawn Rate of each mole
    var spawnRate = 2000L

    // Extra Credit
    var mediaPlayer: MediaPlayer? = null

    // Moles
    // Stores resource IDs for active mole images
    var moles = mutableListOf<Int>()
    // Stores resource IDs for dead mole images
    var deadMoles = mutableListOf<Int>()

    // Stores resource IDs for lump images (not used in the code)
    var lumps = mutableListOf<Int>()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        mediaPlayer = MediaPlayer.create(this, R.raw.thud)

        displayScores()

        println("here123")

        buttonPress()

    }


    /**
     * Starts the game by scheduling the appearance of moles and handling user clicks on the mole images.
     * Randomly selects a mole to show, handles clicks, and schedules mole hiding.
     * Also adjusts the spawn rate as the game progresses.
     */
    fun start() {
        handler.postDelayed({
            if (!game) {
                return@postDelayed
            }

            // Randomly select a mole to show
            var randIndex = (0 until moleMap.size).random()
            var moleOut = moleMap[randIndex]

            moleOut.show()

            moleOut.imageView.setOnClickListener {
                moleOut.hide()
                score++

                updateScore()

                println("clicked")

                println("score: " + score)

                moleOut.clicked = true

                mediaPlayer?.start()

                spawnRate -= 100

            }

            println("moleOut.clicked: " + moleOut.clicked)

            // Schedule hiding the mole after a short duration
            handler.postDelayed({

                if(moleOut.clicked == false) {
                    miss++

                    if (deadMoleIndex <= deadMoleMap.size) {
                        var deadMole = deadMoleMap[deadMoleIndex - 1]
                        deadMoleIndex++
                        deadMole.show()
                    }

                    println("dead Index: $deadMoleIndex")
                    println("miss: $miss")
                    println("maxMissed: $maxMisses")


                    if (miss == maxMisses) {
                        gameOver()
                    }
                }

                moleOut.hide()
            }, spawnRate)

            // Schedule the next mole appearance
            start()
        }, spawnRate)
    }


    /**
     * Handles the game over condition, updates scores, and resets the game.
     */
    fun gameOver() {

        game = false

        destroyMedia()

        //println("highscore: " + highScore)
        //print("score: " + score)

        saveCurrent(score)

        if (score > highScore) {

            println("here")

            highScore = score

            saveHigh(highScore)

            updateScore()
        }

        //var highScoreNumber = findViewById<TextView>(R.id.highScoreNumber)

        //highScoreNumber.text = highScore.toString()

        handler.postDelayed({
              resetGame()
              return@postDelayed
        }, 1000)
    }

    /**
     * Updates the displayed score on the UI.
     */
    fun updateScore() {
        var currentScore = findViewById<TextView>(R.id.currentScoreNumber)

        currentScore.text = score.toString()
    }

    /**
     * Loads the high score from shared preferences.
     *
     * @return The high score.
     */
    fun loadHigh(): Int {
        var sharedPreferences = getSharedPreferences("HighScorePrefs", Context.MODE_PRIVATE)

        return sharedPreferences.getInt("highScore", 0)
    }

    /**
     * Loads the current score from shared preferences.
     *
     * @return The current score.
     */
    fun loadCurrent(): Int {
        var sharedPreferences = getSharedPreferences("ScorePrefs", Context.MODE_PRIVATE)

        return sharedPreferences.getInt("score", 0)
    }


    /**
     * Saves the high score to shared preferences.
     *
     * @param highScore The high score to be saved.
     */
    fun saveHigh(highScore: Int) {
        var sharedPreferences = getSharedPreferences("HighScorePrefs", Context.MODE_PRIVATE)
        var editor = sharedPreferences.edit()

        //editor.putInt("highScore", Integer.parseInt(highScoreNumber.getText().toString()))
        editor.putInt("highScore", highScore)
        editor.apply()
    }
    /**
     * Saves the current score to shared preferences.
     *
     * @param Score The current score to be saved.
     */
    fun saveCurrent(score: Int) {
        var sharedPreferences = getSharedPreferences("ScorePrefs", Context.MODE_PRIVATE)
        var editor = sharedPreferences.edit()

        //editor.putInt("highScore", Integer.parseInt(highScoreNumber.getText().toString()))
        editor.putInt("score", score)
        editor.apply()
    }

    /**
     * Resets the game by clearing mole maps and resetting variables
     */
    fun resetGame() {
        moleMap.clear()
        deadMoleMap.clear()

        deadMoleIndex = 1

        miss = 0
        game = false
        spawnRate = 2000L

        mediaPlayer = MediaPlayer.create(this, R.raw.thud)


        // Reset the layout to the game layout
        setContentView(R.layout.activity_main)

        displayScores()

        buttonPress()
    }

    /**
     * Handles button press to start the game and initialize the game elements.
     */
    fun buttonPress() {
        var clickButton: Button = findViewById(R.id.clickToPlay)

        clickButton.setOnClickListener {
            setContentView(R.layout.activity_grid)

            for (i in 1 until 13) {
                var id = resources.getIdentifier("mole$i", "id", packageName)
                moles.add(id)
            }

            for (i in 1 until 4) {
                var id = resources.getIdentifier("deadMole$i", "id", packageName)
                deadMoles.add(id)
            }

            for (i in 1 until 13) {
                var id = resources.getIdentifier("lump$i", "id", packageName)
                lumps.add(id)
            }

            for (id in moles) {
                val moleView = findViewById<ImageView>(id)
                val mole = Mole(moleView)
                moleMap.add(mole)
                mole.hide()
            }

            for (id in deadMoles) {
                val moleView = findViewById<ImageView>(id)
                val deadMole = Mole(moleView)
                deadMoleMap.add(deadMole)
                deadMole.hide()
            }

            println("initial click")

            if (!game) {
                game = true
                score = 0
                start()
            }
        }
    }

    /**
     * Displays scores on the UI.
     */
    fun displayScores() {

        //reinitialize
        scoreText = findViewById(R.id.previousScoreNumber)
        highScoreText = findViewById(R.id.highScoreNumber)

        println("score: " + score)
        println("high score: " + highScore)

        score = loadCurrent()
        scoreText.text = score.toString()

        highScore = loadHigh()
        highScoreText.text = highScore.toString()
    }

    /**
     * Releases the media player resources.
     */
    fun destroyMedia() {
        mediaPlayer?.release()
    }

}