package org.linaro.glmark2;

import android.app.Activity;
import android.os.Bundle;
import android.opengl.GLSurfaceView;
import android.app.Dialog;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Context;
import android.os.PowerManager;
import android.os.PowerManager.WakeLock;
import android.view.WindowManager;
import android.view.View;
import android.view.MotionEvent;
import android.util.Log;

public class Glmark2Activity extends Activity {
    public static final int DIALOG_EGLCONFIG_FAIL_ID = 0;
    public static final String TAG = "GLMark2";
    private WakeLock mWakeLock;

    @Override
    protected void onDestroy() {
        super.onDestroy();
        mWakeLock.release();
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        PowerManager pm = (PowerManager) getSystemService(Context.POWER_SERVICE);
        mWakeLock = pm.newWakeLock(PowerManager.SCREEN_DIM_WAKE_LOCK, TAG);
        mWakeLock.acquire();

	final int flags = View.SYSTEM_UI_FLAG_LAYOUT_STABLE
	    | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
	    | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
	    | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
	    | View.SYSTEM_UI_FLAG_FULLSCREEN
	    | View.SYSTEM_UI_FLAG_IMMERSIVE;
	getWindow().getDecorView().setSystemUiVisibility(flags);
	final View decorView = getWindow().getDecorView();
        decorView.setOnSystemUiVisibilityChangeListener(new View.OnSystemUiVisibilityChangeListener()
            {

                @Override
                public void onSystemUiVisibilityChange(int visibility)
                {
                    if((visibility & View.SYSTEM_UI_FLAG_FULLSCREEN) == 0)
                    {
                        decorView.setSystemUiVisibility(flags);
                    }
                }
            });


        mGLView = new Glmark2SurfaceView(this);
        setContentView(mGLView);
    }

@Override
    public boolean onTouchEvent(MotionEvent event) {
	Log.w("glmark2", "events disscard");
	return super.onTouchEvent(event);
    }

    @Override
public void onWindowFocusChanged(boolean hasFocus)
{
    super.onWindowFocusChanged(hasFocus);
        getWindow().getDecorView().setSystemUiVisibility(
            View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
                | View.SYSTEM_UI_FLAG_FULLSCREEN
                | View.SYSTEM_UI_FLAG_IMMERSIVE);
}

    @Override
    protected void onPause() {
        super.onPause();
        mGLView.onPause();
        Glmark2Activity.this.finish();
        android.os.Process.killProcess(android.os.Process.myPid());
    }

    @Override
    protected void onResume() {
        super.onResume();
        mGLView.onResume();
    }

    @Override
    protected Dialog onCreateDialog(int id) {
        Dialog dialog;
        switch (id) {
            case DIALOG_EGLCONFIG_FAIL_ID:
                AlertDialog.Builder builder = new AlertDialog.Builder(this);
                builder.setMessage("Glmark2 cannot run because it couldn't find a suitable EGLConfig for GLES2.0. Please check that proper GLES2.0 drivers are installed.");
                builder.setCancelable(false);
                builder.setPositiveButton("Quit",
                    new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {
                            Glmark2Activity.this.finish();
                            /*
                             * Force process shutdown. There is no safer way to
                             * do this, as we have open threads we can't close
                             * when we fail to get an EGLConfig
                             */
                            android.os.Process.killProcess(android.os.Process.myPid());
                        }
                    });

                dialog = builder.create();
                break;
            default:
                dialog = null;
                break;
        }

        return dialog;
    }


    private GLSurfaceView mGLView;

    static {
        System.loadLibrary("glmark2-android");
    }
}

