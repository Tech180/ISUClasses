package com.example.reline;

import android.graphics.Bitmap;
import android.util.*;
import android.util.LruCache;

import com.android.volley.toolbox.ImageLoader.ImageCache;

public class ImageClass extends LruCache<String, Bitmap> implements
            ImageCache {
    public static int getDefaultLruCacheSize() {
        final int maxMemory = (int) (Runtime.getRuntime().maxMemory()/1024);
        final int cacheSize = maxMemory/8;

        return cacheSize;
    }

    public ImageClass() {
        this(getDefaultLruCacheSize());
    }

    public ImageClass(int sizeInKiloBytes) {
        super(sizeInKiloBytes);
    }

    @Override
    public Bitmap getBitmap(String url) {
        return null;
    }

    @Override
    public void putBitmap(String url, Bitmap bitmap) {
        put(url, bitmap);
    }
}
