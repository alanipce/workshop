package com.builtbyalan.basic2dgame;

import android.graphics.Canvas;
import android.view.SurfaceHolder;

public class GameThread extends Thread {
    private boolean running;
    private GameSurface gameSurface;
    private SurfaceHolder surfaceHolder;

    public GameThread(GameSurface gameSurface, SurfaceHolder surfaceHolder) {
        this.gameSurface = gameSurface;
        this.surfaceHolder = surfaceHolder;
    }

    @Override
    public void run() {
        long startTime = System.nanoTime();

        while (running) {
            Canvas canvas = null;

            try {
                canvas = surfaceHolder.lockCanvas();

                synchronized (canvas) {
                    gameSurface.update();
                    gameSurface.draw(canvas);
                }
            } catch (Exception e) {
                // do nothing
            } finally {
                if (canvas != null) {
                    surfaceHolder.unlockCanvasAndPost(canvas);
                }
            }

            long now = System.nanoTime();

            long waitTime = (now - startTime)/1000000;

            if (waitTime < 10) {
                waitTime = 10;
            }

            System.out.print("Wait time = " + waitTime);

            try {
                sleep(waitTime);
            } catch (InterruptedException e) {

            }

            startTime = System.nanoTime();
            System.out.print(".");

        }
    }

    public void setRunning(boolean running) {
        this.running = running;
    }
}
