package com.boyaa.made;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;

import android.app.Activity;
import android.app.AlertDialog;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.os.Message;
import android.util.DisplayMetrics;
import android.view.KeyEvent;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;

import com.boyaa.chinesechess.chicken.Game;
import com.boyaa.chinesechess.chicken.R;

public class AppStartAdDialog extends AlertDialog {

	protected ImageView adImgView;
	protected Button closeButton;
	protected String path;
	protected static double buttonWidth; // button宽度
	protected static double buttonHeight; // button高度
	protected static double scale; // 缩放比例
	protected Activity context;
	Bitmap bm = null;

	public AppStartAdDialog(Activity context) {
		super(context, R.style.CustomDialog);
		// TODO Auto-generated constructor stub
		this.context = context;
	}

	@Override
	public void show() {
		super.show();
		// TODO Auto-generated method stub
		buttonWidth = (double) closeButton.getLayoutParams().width;
		buttonHeight = (double) closeButton.getLayoutParams().height;

		// closeButton.setWidth((int)(buttonWidth *0.5));
		// closeButton.setHeight((int)(buttonHeight *0.5));
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);

		setContentView(R.layout.start_ad_default);

		adImgView = (ImageView) findViewById(R.id.startAdImg);
		closeButton = (Button) findViewById(R.id.closeBtn);
//		closeButton.setText("跳过");
//		closeButton.getBackground().setAlpha(100);// 0~255透明度值
//		windowScreenAdapter(closeButton);
		
		closeButton.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				Message msg = new Message();
				msg.what = Game.HANDLER_CLOSE_START_AD_DIALOG;
				Game.getGameHandler().sendMessage(msg);
			}
		});

		// BitmapFactory.Options options = new BitmapFactory.Options();
		// options.inSampleSize = 2;
		// options.inJustDecodeBounds = true;
		//
		// /* 下面两个字段需要组合使用 */
		// options.inPurgeable = true;
		// options.inInputShareable = true;
		// BitmapFactory.decodeFile(path,options);
		//
		// bm = BitmapFactory.decodeFile(path,options);
		// handleBmp();
		handleBmp2();
		adImgView.setOnClickListener(new View.OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				// 跳转链接
				Message msg = new Message();
				msg.what = Game.HANDLER_START_AD_DIALOG_JUMP_URL;
				Game.getGameHandler().sendMessage(msg);
			}
		});
		//
	}

	@Override
	protected void onStart() {
		// TODO Auto-generated method stub
		super.onStart();
	}

	@Override
	protected void onStop() {
		// TODO Auto-generated method stub
		super.onStop();
	}

	public void setDownloadImg(String imgPath) {
		// adImgView.setImageBitmap(BitmapFactory.decodeFile(imgPath));
	}

	public void setWindowScale(double winscale) {
		scale = winscale;
	}

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if (keyCode == KeyEvent.KEYCODE_BACK && event.getRepeatCount() == 0) {
			return true;
		}

		return super.onKeyDown(keyCode, event);
	}

	@Override
	public void dismiss() {
		// TODO Auto-generated method stub
		super.dismiss();
		recycleBmp();
	}
	/*
	 * bmp图片压缩（暂时不用）,手动分配图片内存
	 */
	public void handleBmp() {
		path = FileUtil.getmStrImagesPath() + "download_ad_start.png";
		BitmapFactory.Options bfOptions = new BitmapFactory.Options();
		bfOptions.inDither = false; /* 不进行图片抖动处理 */
		bfOptions.inPurgeable = true;
		bfOptions.inTempStorage = new byte[24 * 1024];
		File file = new File(path);
		FileInputStream fs = null;
		try {
			fs = new FileInputStream(file);
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
		if (fs != null) {
			try {
				bm = BitmapFactory.decodeFileDescriptor(fs.getFD(), null,
						bfOptions);
			} catch (IOException e) {
				e.printStackTrace();
			} finally {
				if (fs != null) {
					try {
						fs.close();
					} catch (IOException e) {
						e.printStackTrace();
					}
				}
			}
		}
		if (null != bm) {
			adImgView.setImageBitmap(bm);
		}
	}
	/*
	 * bmp图片压缩
	 */
	public void handleBmp2() {
		DisplayMetrics dm = new DisplayMetrics();
		// 获取屏幕信息
		context.getWindowManager().getDefaultDisplay().getMetrics(dm);
		int screenWidth = dm.widthPixels;
		int screenHeigh = dm.heightPixels;

		path = FileUtil.getmStrImagesPath() + "download_ad_start.png";
		BitmapFactory.Options bfOptions = new BitmapFactory.Options();
		bfOptions.inJustDecodeBounds = true; // 设置了此属性一定要记得将值设置为false
		bm = BitmapFactory.decodeFile(path, bfOptions);
		bfOptions.inSampleSize = caculateInSampleSize(bfOptions, screenWidth, screenHeigh);
		bfOptions.inPreferredConfig = Bitmap.Config.ARGB_4444;
		/* 下面两个字段需要组合使用 */
		bfOptions.inPurgeable = true;
		bfOptions.inInputShareable = true;
		bfOptions.inJustDecodeBounds = false;
		try {
			bm = BitmapFactory.decodeFile(path, bfOptions);
		} catch (OutOfMemoryError e) {

		}
		if (null != bm) {
			adImgView.setImageBitmap(bm);
		}
	}
	/*
	 * 计算bmp图片压缩倍数
	 */
	public static int caculateInSampleSize(BitmapFactory.Options options,
			int reqWidth, int reqHeight) {

		int width = options.outWidth;
		int height = options.outHeight;
		int inSampleSize = 1;
		if (width > reqWidth || height > reqHeight) {
			int widthRadio = Math.round(width * 1.0f / reqWidth);
			int heightRadio = Math.round(height * 1.0f / reqHeight);
			inSampleSize = Math.max(widthRadio, heightRadio);
		}
		return inSampleSize;
	}
	/*
	 * 回收bmp
	 */
	public void recycleBmp() {
		if (bm != null && !bm.isRecycled()) {
			bm.recycle();
			bm = null;
		}
		System.gc();
	}
//	
//	/**
//	 * 安卓适配
//	 * @param btn 
//	 */
//	protected void windowScreenAdapter(Button btn) {
//		DisplayMetrics dm = new DisplayMetrics();
//		AppActivity.mActivity.getWindowManager()
//				.getDefaultDisplay().getMetrics(dm);
//		//获取屏幕高度 
//		int srceenHeight = dm.heightPixels; 
//		//获取屏幕宽度 
//		int srceenWidth = dm.widthPixels;
//		//宽高各占50%
//		RelativeLayout.LayoutParamslayoutParams lp = new RelativeLayout.LayoutParams( (int)(srceenWidth*0.5+0.5),(int)(srceenHeight*0.5+0.5));
//		btn.setLayoutParams(lp);
//	}
}
