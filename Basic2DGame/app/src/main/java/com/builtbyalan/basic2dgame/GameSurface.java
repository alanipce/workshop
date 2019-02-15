package com.builtbyalan.basic2dgame;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.media.AudioAttributes;
import android.media.SoundPool;
import android.view.MotionEvent;
import android.view.SurfaceHolder;
import android.view.SurfaceView;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class GameSurface extends SurfaceView implements SurfaceHolder.Callback {
    private GameThread gameThread;
    private List<ChibiCharacter> chibiList = new ArrayList<>();
    private List<Explosion> explosionList = new ArrayList<>();

    private static final int MAX_STREAMS = 100;
    private int soundIdExplosion;
    private int soundIdBackground;

    private boolean soundPoolLoaded;
    private SoundPool soundPool;

    public GameSurface(Context context) {
        super(context);

        // make game surface focusable so it can handle events
        setFocusable(true);

        getHolder().addCallback(this);
        initSountPool();
    }

    private void initSountPool() {
        AudioAttributes audioAttrib = new AudioAttributes.Builder()
                .setUsage(AudioAttributes.USAGE_GAME)
                .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                .build();

        SoundPool.Builder builder = new SoundPool.Builder();
        builder.setAudioAttributes(audioAttrib)
            .setMaxStreams(MAX_STREAMS);

        soundPool = builder.build();

        soundPool.setOnLoadCompleteListener(new SoundPool.OnLoadCompleteListener() {
            @Override
            public void onLoadComplete(SoundPool soundPool, int sampleId, int status) {
                soundPoolLoaded = true;

                playSoundBackground();
            }
        });

        soundIdBackground = soundPool.load(getContext(), R.raw.background, 1);
        soundIdExplosion = soundPool.load(getContext(), R.raw.explosion, 1);
    }
    public void update() {
        for (ChibiCharacter chibi: chibiList) {
            chibi.update();
        }

        Iterator<Explosion> iterator = explosionList.iterator();

        while (iterator.hasNext()) {
            Explosion explosion = iterator.next();
            explosion.update();

            if (explosion.isFinish()) {
                iterator.remove();
            }
        }
    }

    public void draw(Canvas canvas) {
        super.draw(canvas);

        for (ChibiCharacter chibi: chibiList) {
            chibi.draw(canvas);
        }

        for (Explosion explosion: explosionList) {
            explosion.draw(canvas);
        }

    }

    public void playSoundExplosion() {
        if (soundPoolLoaded) {
            float leftVolume = 0.8f;
            float rightVolume = 0.8f;

            soundPool.play(soundIdExplosion, leftVolume, rightVolume, 1, 0, 1f);
        }
    }

    public void playSoundBackground() {
        if (soundPoolLoaded) {
            float leftVolume = 0.8f;
            float rightVolume = 0.8f;

            soundPool.play(soundIdBackground, leftVolume, rightVolume, 1, -1, 1f);
        }
    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        if (event.getAction() == MotionEvent.ACTION_DOWN) {
            int x = (int) event.getX();
            int y = (int) event.getY();

            Iterator<ChibiCharacter> iterator = chibiList.iterator();

            while (iterator.hasNext()) {
                ChibiCharacter chibi = iterator.next();

                if ( x > chibi.getX() && x < chibi.getX() + chibi.getWidth() &&
                        y > chibi.getY() && y < chibi.getY() + chibi.getHeight()) {
                    iterator.remove();

                    Bitmap bitmap = BitmapFactory.decodeResource(getResources(), R.drawable.explosion);
                    Explosion explosion = new Explosion(this, bitmap, chibi.getX(), chibi.getY());

                    explosionList.add(explosion);
                } else {
                    int movingVectorX = x - chibi.getX();
                    int movingVectorY = y - chibi.getY();

                    chibi.setMovingVector(movingVectorX, movingVectorY);
                }
            }

            return true;
        }

        return false;
    }

    @Override
    public void surfaceCreated(SurfaceHolder holder) {
        Bitmap chibiBitmap1 = BitmapFactory.decodeResource(getResources(), R.drawable.chibi1);
        ChibiCharacter chibi1 = new ChibiCharacter(this, chibiBitmap1, 100, 50);

        Bitmap chibiBitmap2 = BitmapFactory.decodeResource(getResources(), R.drawable.chibi2);
        ChibiCharacter chibi2 = new ChibiCharacter(this, chibiBitmap2, 300, 150);

        chibiList.add(chibi1);
        chibiList.add(chibi2);

        gameThread = new GameThread(this, holder);
        gameThread.setRunning(true);
        gameThread.start();
    }

    @Override
    public void surfaceChanged(SurfaceHolder holder, int format, int width, int height) {

    }

    @Override
    public void surfaceDestroyed(SurfaceHolder holder) {
        boolean retry = true;

        while (retry) {
            try {
                gameThread.setRunning(false);

                gameThread.join();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }

            retry = true;
        }
    }
}
