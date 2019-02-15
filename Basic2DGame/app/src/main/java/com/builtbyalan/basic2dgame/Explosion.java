package com.builtbyalan.basic2dgame;

import android.graphics.Bitmap;
import android.graphics.Canvas;

public class Explosion extends GameObject {
    private int rowIndex = 0;
    private int colIndex = -1;

    private boolean finish = false;
    private GameSurface gameSurface;

    public Explosion(GameSurface gameSurface, Bitmap image, int x, int y) {
        super(image, 5, 5, x, y);

        this.gameSurface = gameSurface;
    }

    public void update() {
        colIndex++;

        if (colIndex == 0 && rowIndex == 0) {
            gameSurface.playSoundExplosion();
        }

        if (colIndex >= colCount) {
            colIndex = 0;
            rowIndex++;

            if (rowIndex >= rowCount) {
                finish = true;
            }
        }
    }

    public void draw(Canvas canvas) {
        if (!finish) {
            Bitmap bitmap = this.createSubImageAt(rowIndex, colIndex);
            canvas.drawBitmap(bitmap, x, y, null);
        }
    }

    boolean isFinish() {
        return finish;
    }
}
