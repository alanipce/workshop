package com.builtbyalan.basic2dgame;

import android.graphics.Bitmap;
import android.graphics.Canvas;

public class ChibiCharacter extends GameObject {
    private static final int ROW_TOP_TO_BOTTOM = 0;
    private static final int ROW_RIGHT_TO_LEFT = 1;
    private static final int ROW_LEFT_TO_RIGHT = 2;
    private static final int ROW_BOTTOM_TO_TOP = 3;

    private int rowUsing = ROW_LEFT_TO_RIGHT;
    private int colUsing;

    private Bitmap[] leftToRights;
    private Bitmap[] rightToLefts;
    private Bitmap[] topToBottoms;
    private Bitmap[] bottomToTops;

    // velocity of game character
    public static final float VELOCITY = 0.1f;

    // defines the direction of the vector at the fixed velocity
    private int movingVectorX = 10;
    private int movingVectorY = 5;

    private long lastDrawNanoTime = -1;

    private GameSurface gameSurface;

    public ChibiCharacter(GameSurface gameSurface, Bitmap image, int x, int y) {
        super(image, 4, 3, x, y);

        this.gameSurface = gameSurface;

        this.topToBottoms = new Bitmap[colCount];
        this.rightToLefts = new Bitmap[colCount];
        this.leftToRights = new Bitmap[colCount];
        this.bottomToTops = new Bitmap[colCount];

        for (int col = 0; col < colCount; ++col) {
            this.topToBottoms[col] = this.createSubImageAt(ROW_TOP_TO_BOTTOM, col);
            this.rightToLefts[col] = this.createSubImageAt(ROW_RIGHT_TO_LEFT, col);
            this.leftToRights[col] = this.createSubImageAt(ROW_LEFT_TO_RIGHT, col);
            this.bottomToTops[col] = this.createSubImageAt(ROW_BOTTOM_TO_TOP, col);
        }
    }


    public Bitmap[] getMoveBitmaps() {
        switch (rowUsing) {
            case ROW_BOTTOM_TO_TOP:
                return bottomToTops;
            case ROW_TOP_TO_BOTTOM:
                return topToBottoms;
            case ROW_RIGHT_TO_LEFT:
                return rightToLefts;
            case ROW_LEFT_TO_RIGHT:
                return leftToRights;
            default:
                return null;

        }
    }

    public Bitmap getCurrentMoveBitmap() {
        Bitmap[] bitmaps = getMoveBitmaps();
        return bitmaps[colUsing];
    }


    public void update() {
        colUsing++;
        colUsing = colUsing % colCount;

        long now = System.nanoTime();

        if (lastDrawNanoTime == -1) {
            lastDrawNanoTime = now;
        }

        int deltaTime = (int)((now - lastDrawNanoTime)/1000000);

        float distance = VELOCITY * deltaTime;

        double movingVectorLength = Math.sqrt(movingVectorX*movingVectorX + movingVectorY*movingVectorY);

        x += (int)(distance * movingVectorX/movingVectorLength);
        y += (int)(distance * movingVectorY/movingVectorLength);

        // when the game character reaches an edge of screen, then change direction
        if (x < 0) {
            x = 0;
            movingVectorX = -movingVectorX;
        } else if (x > gameSurface.getWidth() - width) {
            x = gameSurface.getWidth() - width;
            movingVectorX = -movingVectorX;
        }

        if (y < 0) {
            y = 0;
            movingVectorY = -movingVectorY;
        } else if (y > gameSurface.getHeight() - height) {
            y = gameSurface.getHeight() - height;
            movingVectorY = -movingVectorY;
        }

        // calculate row using from direction vectors
        if (movingVectorX > 0) {
            if (movingVectorY > 0 && Math.abs(movingVectorY) > Math.abs(movingVectorX)) {
                rowUsing = ROW_TOP_TO_BOTTOM;
            } else if (movingVectorY < 0 && Math.abs(movingVectorY) > Math.abs(movingVectorX)) {
                rowUsing = ROW_BOTTOM_TO_TOP;
            } else {
                rowUsing = ROW_LEFT_TO_RIGHT;
            }
        } else {
            if (movingVectorY > 0 && Math.abs(movingVectorY) > Math.abs(movingVectorX)) {
                rowUsing = ROW_TOP_TO_BOTTOM;
            } else if (movingVectorY < 0 && Math.abs(movingVectorY) > Math.abs(movingVectorX)) {
                rowUsing = ROW_BOTTOM_TO_TOP;
            } else {
                rowUsing = ROW_RIGHT_TO_LEFT;
            }
        }
    }

    public void draw(Canvas canvas) {
        Bitmap bitmap = getCurrentMoveBitmap();
        canvas.drawBitmap(bitmap, x, y, null);

        this.lastDrawNanoTime = System.nanoTime();
    }

    public void setMovingVector(int movingVectorX, int movingVectorY) {
        this.movingVectorX = movingVectorX;
        this.movingVectorY = movingVectorY;
    }
}
