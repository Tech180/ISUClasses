package com.example.wack_a_mole

import android.view.View
import android.widget.ImageView

/**
 * Represents a mole character in the Wack-a-Mole game.
 * Moles can appear on the screen, be clicked by the player, and be hidden.
 *
 * @param imageView Associated with the mole character.
 */
class Mole(var imageView: ImageView) {

    /** Indicates whether the mole is currently visible on the screen. */
    var visible = false

    /** Indicates whether the mole has been clicked by the player. */
    var clicked = false


    /**
     * Shows the mole on the screen by setting its ImageView's visibility to VISIBLE.
     */
    fun show() {
        imageView.visibility = View.VISIBLE
        visible = true
    }

    /**
     * Hides the mole from the screen by setting its ImageView's visibility to INVISIBLE.
     */
    fun hide() {
        imageView.visibility = View.INVISIBLE
        visible = false
    }
}