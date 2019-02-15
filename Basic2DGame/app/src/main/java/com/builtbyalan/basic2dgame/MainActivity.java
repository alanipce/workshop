package com.builtbyalan.basic2dgame;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.Window;
import android.view.WindowManager;

/*
Following tutorial at
    https://o7planning.org/en/10521/android-2d-game-tutorial-for-beginners
*/
public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // set full screen
        getWindow().setFlags(
                WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_FULLSCREEN
        );

        // hide action bar
        supportRequestWindowFeature(Window.FEATURE_NO_TITLE);

        setContentView(new GameSurface(this));
    }
}
