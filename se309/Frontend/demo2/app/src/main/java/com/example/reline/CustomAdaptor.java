package com.example.reline;

import android.app.Activity;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.android.volley.toolbox.ImageLoader;
import com.android.volley.toolbox.NetworkImageView;
import com.example.reline.app.AppController;

import java.util.List;

public class CustomAdaptor extends BaseAdapter {
    private Activity activity;
    private LayoutInflater inflater;
    private List modelItems;
    ImageLoader imageLoader = AppController.getInstance().getImageLoader();

    public CustomAdaptor(Activity activity, List modelItems) {
        this.activity = activity;
        this.modelItems = modelItems;
    }

    @Override
    public int getCount() {
        return modelItems.size();
    }

    @Override
    public Object getItem(int location) {
        return modelItems.get(location);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {

        if (inflater == null)
            inflater = (LayoutInflater) activity
                    .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        if (convertView == null)
            convertView = inflater.inflate(R.layout.activity_list_row, null);

        if (imageLoader == null)
            imageLoader = AppController.getInstance().getImageLoader();

        TextView title = (TextView) convertView.findViewById(R.id.title);
        TextView category = (TextView) convertView.findViewById(R.id.category);

        NetworkImageView thumbNail = (NetworkImageView) convertView
                .findViewById(R.id.thumbnail);

        // getting model data for the row
        Model m = (Model) modelItems.get(position);

        // title
        title.setText("Title: " + String.valueOf(m.getTitle()));

        // category
        category.setText("Category: "+ String.valueOf(m.getCategory()));

        // thumbnail image
        thumbNail.setImageUrl(m.getThumbnailUrl(), imageLoader);

        return convertView;
    }
}
