package edu.iastate.netid.pocketcalculator

import android.os.Bundle
import android.view.View
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity

class MainActivity : AppCompatActivity() {
    /**
     * The instance of the calculator model for use by this controller.
     */
    private val mCalculationStream = CalculationStream()

    /*
     * The instance of the calculator display TextView. You can use this to update the calculator display.
     */
    private var mCalculatorDisplay: TextView? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        /* TODO - uncomment the below line after you make your layout. This line locates
           the instance of the calculator display's TextView.  You need to create this TextView
           and set its ID to CalculatorDisplay in your layout resource file.
         */

        mCalculatorDisplay = findViewById(R.id.CalculatorDisplay)

        val buttonZero = findViewById<View>(R.id.buttonZero)
        buttonZero.setOnClickListener {
            onZeroClicked(it)
        }

        val buttonOne = findViewById<View>(R.id.buttonOne)
        buttonOne.setOnClickListener {
            onOneClicked(it)
        }

        val buttonTwo = findViewById<View>(R.id.buttonTwo)
        buttonTwo.setOnClickListener {
            onTwoClicked(it)
        }

        val buttonThree = findViewById<View>(R.id.buttonThree)
        buttonThree.setOnClickListener {
            onThreeClicked(it)
        }

        val buttonFour = findViewById<View>(R.id.buttonFour)
        buttonFour.setOnClickListener {
            onFourClicked(it)
        }

        val buttonFive = findViewById<View>(R.id.buttonFive)
        buttonFive.setOnClickListener {
            onFiveClicked(it)
        }

        val buttonSix = findViewById<View>(R.id.buttonSix)
        buttonSix.setOnClickListener {
            onSixClicked(it)
        }

        val buttonSeven = findViewById<View>(R.id.buttonSeven)
        buttonSeven.setOnClickListener {
            onSevenClicked(it)
        }

        val buttonEight = findViewById<View>(R.id.buttonEight)
        buttonEight.setOnClickListener {
            onEightClicked(it)
        }

        val buttonNine = findViewById<View>(R.id.buttonNine)
        buttonNine.setOnClickListener {
            onNineClicked(it)
        }

        val buttonMultiply = findViewById<View>(R.id.buttonMultiply)
        buttonMultiply.setOnClickListener {
            onMultiplyClicked(it)
        }

        val buttonDivide = findViewById<View>(R.id.buttonDivide)
        buttonDivide.setOnClickListener {
            onDivideClicked(it)
        }

        val buttonAdd = findViewById<View>(R.id.buttonPlus)
        buttonAdd.setOnClickListener {
            onPlusClicked(it)
        }

        val buttonSubtract = findViewById<View>(R.id.buttonMinus)
        buttonSubtract.setOnClickListener {
            onMinusClicked(it)
        }

        val buttonEquals = findViewById<View>(R.id.buttonEquals)
        buttonEquals.setOnClickListener {
            onEqualClicked(it)
        }

        val buttonClear = findViewById<View>(R.id.buttonClear)
        buttonClear.setOnClickListener {
            onClearClicked(it)
        }

        val buttonDecimal = findViewById<View>(R.id.buttonDecimal)
        buttonDecimal.setOnClickListener {
            onDecimalClicked(it)
        }

    }

    /* TODO - add event listeners for your calculator's buttons. See the model's API to figure out
       what methods should be called. The equals button event listener has been done for you. Once
       you've created the layout, you'll need to add these methods as the onClick() listeners
       for the corresponding buttons in the XML layout. */

    /*
        non-number functions
    */
    fun onEqualClicked(view: View?) {
        try {
            mCalculationStream.calculateResult()
        } finally {
            updateCalculatorDisplay()
        }
    }

    fun onClearClicked(view: View?) {
        mCalculationStream.clear()
        updateCalculatorDisplay()
    }

    fun onDivideClicked(view: View?) {
        mCalculationStream.inputOperation(CalculationStream.Operation.DIVIDE)
    }

    fun onMultiplyClicked(view: View?) {
        mCalculationStream.inputOperation(CalculationStream.Operation.MULTIPLY)
    }

    fun onDecimalClicked(view: View?) {
        val digit = CalculationStream.Digit.DECIMAL
        mCalculationStream.inputDigit(digit)
        updateCalculatorDisplay()
    }

    fun onPlusClicked(view: View?) {
        mCalculationStream.inputOperation(CalculationStream.Operation.ADD)
    }

    fun onMinusClicked(view: View?) {
        mCalculationStream.inputOperation(CalculationStream.Operation.SUBTRACT)
    }

    fun onZeroClicked(view: View?) {
        val digit = CalculationStream.Digit.ZERO
        mCalculationStream.inputDigit(digit)
        updateCalculatorDisplay()
    }

    fun onOneClicked(view: View?) {
        val digit = CalculationStream.Digit.ONE
        mCalculationStream.inputDigit(digit)
        updateCalculatorDisplay()
    }

    fun onTwoClicked(view: View?) {
        val digit = CalculationStream.Digit.TWO
        mCalculationStream.inputDigit(digit)
        updateCalculatorDisplay()
    }

    fun onThreeClicked(view: View?) {
        val digit = CalculationStream.Digit.THREE
        mCalculationStream.inputDigit(digit)
        updateCalculatorDisplay()
    }

    fun onFourClicked(view: View?) {
        val digit = CalculationStream.Digit.FOUR
        mCalculationStream.inputDigit(digit)
        updateCalculatorDisplay()
    }

    fun onFiveClicked(view: View?) {
        val digit = CalculationStream.Digit.FIVE
        mCalculationStream.inputDigit(digit)
        updateCalculatorDisplay()
    }

    fun onSixClicked(view: View?) {
        val digit = CalculationStream.Digit.SIX
        mCalculationStream.inputDigit(digit)
        updateCalculatorDisplay()
    }

    fun onSevenClicked(view: View?) {
        val digit = CalculationStream.Digit.SEVEN
        mCalculationStream.inputDigit(digit)
        updateCalculatorDisplay()
    }

    fun onEightClicked(view: View?) {
        val digit = CalculationStream.Digit.EIGHT
        mCalculationStream.inputDigit(digit)
        updateCalculatorDisplay()
    }

    fun onNineClicked(view: View?) {
        val digit = CalculationStream.Digit.NINE
        mCalculationStream.inputDigit(digit)
        updateCalculatorDisplay()
    }

    /**
     * Call this method after every button press to update the text display of your calculator.
     */
    fun updateCalculatorDisplay() {
        try {
            val result = java.lang.Double.toString(mCalculationStream.currentOperand)
            mCalculatorDisplay?.text = result
        } catch (e: NumberFormatException) {
            mCalculatorDisplay?.text = getString(R.string.error)
        }
    }
}