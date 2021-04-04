package com.example.phoso;

import io.flutter.embedding.android.FlutterActivity;
import android.os.Bundle;
import androidx.annotation.Nullable;
import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {
    @java.lang.Override
    protected void onCreate(@Nullable android.os.Bundle savedInstanceState) {
        getIntent().putExtra("enable-software-rendering", true);

        super.onCreate(savedInstanceState);
    }
}
