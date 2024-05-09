package edu.iastate.cpre388.memoryleak;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.drawable.ShapeDrawable;
import android.graphics.drawable.shapes.OvalShape;
import android.view.View;
import android.widget.TextView;

public class BigRedButton extends View {
    private final int BUTTON_PADDING = 100;

    private ShapeDrawable drawable;

    public BigRedButton(Context context) {
        super(context);

        drawable = new ShapeDrawable(new OvalShape());
        drawable.getPaint().setColor(Color.RED);
    }

    protected void onDraw(Canvas canvas) {
        int longSide = Math.max(getHeight(), getWidth());
        int shortSide = Math.min(getHeight(), getWidth());
        int start = (longSide - shortSide)/2 + BUTTON_PADDING;
        int stop = longSide - start;
        if(getHeight() > getWidth()) {
            drawable.setBounds(BUTTON_PADDING, start, getWidth() - BUTTON_PADDING, stop);
        } else {
            drawable.setBounds(start, BUTTON_PADDING, stop, getHeight() - BUTTON_PADDING);
        }
        drawable.draw(canvas);
        Paint paint = new Paint();
        paint.setColor(Color.WHITE);
        paint.setStyle(Paint.Style.FILL);
        paint.setTextSize(100);
        paint.setTextAlign(Paint.Align.CENTER);
        canvas.drawText(getResources().getString(R.string.button_text),
                getWidth()/2f, getHeight()/2f, paint);
    }
}
