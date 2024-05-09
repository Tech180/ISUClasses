package edu.iastate.netid.pocketcalculator

/**
 * A class that represents a left-to-right calculation inputted as a stream, ignoring order
 * of operations.
 */
class CalculationStream internal constructor() {
    /**
     * The operations supported by the calculation stream.
     */
    enum class Operation {
        NONE, ADD, SUBTRACT, MULTIPLY, DIVIDE
    }

    /**
     * The "digits" supported by the operation stream (including decimal point).
     */
    enum class Digit {
        ZERO, ONE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, DECIMAL
    }

    /**
     * A string builder to represent the first number entered in the series of entries
     */
    private var mExpression1: StringBuilder

    /**
     * A string builder to represent the second number entered in the series of entries
     */
    private var mExpression2: StringBuilder

    /**
     * The current operation in the stream, i.e., what operation to perform on the two
     * expressions when the result needs to be calculated.
     */
    private var mCurrentOperation: Operation

    init {
        mExpression1 = StringBuilder()
        mExpression2 = StringBuilder()
        mCurrentOperation = Operation.NONE
    }

    /**
     * Appends a new digit to the active expression in the stream.
     * @param digit the digit to append
     */
    fun inputDigit(digit: Digit?) {
        val expr: StringBuilder
        expr =
            if (mCurrentOperation != Operation.NONE) {
                mExpression2
            } else {
                mExpression1
            }
        when (digit) {
            Digit.ZERO -> expr.append("0")
            Digit.ONE -> expr.append("1")
            Digit.TWO -> expr.append("2")
            Digit.THREE -> expr.append("3")
            Digit.FOUR -> expr.append("4")
            Digit.FIVE -> expr.append("5")
            Digit.SIX -> expr.append("6")
            Digit.SEVEN -> expr.append("7")
            Digit.EIGHT -> expr.append("8")
            Digit.NINE -> expr.append("9")
            Digit.DECIMAL -> {
                if (expr.length == 0) {
                    expr.append("0")
                }
                expr.append(".")
            }

            else -> {}
        }
    }

    /**
     * Sets the current operation. May first calculate the result of the previous current operation,
     * if needed.
     * @param operation the new current operation
     */
    fun inputOperation(operation: Operation) {
        if (mExpression1.length == 0) {
            mCurrentOperation = Operation.NONE
            return
        }
        if (mCurrentOperation != Operation.NONE) {
            calculateResult()
        }
        mCurrentOperation = operation
    }

    /**
     * Calculates the current result of the stream and prepares for a new expression.
     * @throws NumberFormatException
     */
    @Throws(NumberFormatException::class)
    fun calculateResult() {
        try {
            if (mExpression1.length == 0 || mExpression2.length == 0) {
                return
            }
            val op1 = mExpression1.toString().toDouble()
            val op2 = mExpression2.toString().toDouble()
            var result = 0.0
            result = when (mCurrentOperation) {
                Operation.ADD -> op1 + op2
                Operation.SUBTRACT -> op1 - op2
                Operation.MULTIPLY -> op1 * op2
                Operation.DIVIDE -> op1 / op2
                Operation.NONE -> op1
                else -> op1
            }
            clear()
            mExpression1 = StringBuilder(java.lang.Double.toString(result))
        } catch (e: NumberFormatException) {
            throw e
        }
    }

    /**
     * Clears the calculation stream.
     */
    fun clear() {
        mExpression1 = StringBuilder()
        mExpression2 = StringBuilder()
        mCurrentOperation = Operation.NONE
    }

    /**
     * Gets the value of the current operand being entered. More specifically, this is the second
     * operand, if the second operand has a value. If not, this is the first operand. If neither
     * operands have a value, this returns zero. Useful for displaying the calculation stream in
     * a calculator-like format.
     * @return the value of the current operand
     * @throws NumberFormatException
     */ //TODO - add other calculator logic methods you want to use in this calculator model class
    @get:Throws(NumberFormatException::class)
    val currentOperand: Double
        get() = try {
            if (mCurrentOperation == Operation.NONE || mExpression2.toString() === "") {
                if (mExpression1.toString() === "") {
                    0.0
                } else mExpression1.toString().toDouble()
            } else {
                mExpression2.toString().toDouble()
            }
        } catch (e: NumberFormatException) {
            throw e
        }
}