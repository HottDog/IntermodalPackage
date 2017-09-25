package com.boyaa.share;

import java.io.File;

import org.json.JSONException;
import org.json.JSONObject;

import android.content.ActivityNotFoundException;
import android.content.ComponentName;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.util.Log;
import android.widget.Toast;

import com.boyaa.chinesechess.chicken.Game;
import com.boyaa.chinesechess.chicken.R;
import com.boyaa.entity.common.SDTools;
import com.boyaa.made.FileUtil;
import com.boyaa.until.ScreenShot;

public class NativeShare {
	
	
	/**
	 * 截屏
	 */
	public static void takeShot(String img_name){
		System.out.println("NativeShare.takeShot");
		int left = 0;
		int top = 0;
		int mHeight = Game.mActivity.mHeight;
		int mWidth = Game.mActivity.mWidth;
		int w = mHeight *480 / 800;
		int h = mWidth * 800 /480;
		if (w > mWidth){
			w = mWidth;
			top = (mHeight - h)/2;
		}else if (h > mHeight){
			h = mHeight;
			left = (mWidth - w)/2;
		}
		
		//只截棋盘

		Bitmap bmp = ScreenShot.createBitmapFromGLSurface(left,top,w,h);
		SDTools.saveBitmapJPG(Game.mActivity, FileUtil.getmStrImagesPath(), img_name, bmp);
	}
	
	public static void shareImg(String img_name){
		
	      Intent intent=new Intent(Intent.ACTION_SEND);
	      
	      intent.setType("image/*");

	      String  path = FileUtil.getmStrImagesPath()+ img_name + SDTools.JPG_SUFFIX;
	      File f = new File(path);
	      Uri uri = Uri.fromFile(f);
	      
	      intent.putExtra(Intent.EXTRA_STREAM, uri);

//	      intent.putExtra(Intent.EXTRA_SUBJECT, "博雅中国象棋");
//	      intent.putExtra(Intent.EXTRA_TEXT, "博雅中国象棋");
//	      intent.putExtra(Intent.EXTRA_TITLE, "我是标题");  
	      Game.mActivity.startActivityForResult(Intent.createChooser(intent,"博雅中国象棋"),11);
		
	}

	public static void shareText(String text) {
		Intent intent=new Intent(Intent.ACTION_SEND);
		intent.setType("text/plain");
		intent.putExtra(Intent.EXTRA_SUBJECT, "博雅中国象棋");
		intent.putExtra(Intent.EXTRA_TEXT, text); 
		intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK); 
		Game.mActivity.startActivity(Intent.createChooser(intent,"博雅中国象棋"));
	}
	public static void shareTextAndImg(String text,String img_name) {
		Intent intent=new Intent(Intent.ACTION_SEND);
		intent.setType("image/*");
		String  path = FileUtil.getmStrImagesPath()+ img_name + SDTools.JPG_SUFFIX;
	    File f = new File(path);
	    Uri uri = Uri.fromFile(f);
	    intent.putExtra(Intent.EXTRA_STREAM, uri);
		intent.putExtra(Intent.EXTRA_SUBJECT, "博雅中国象棋");
		intent.putExtra(Intent.EXTRA_TEXT, text); 
		intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK); 
		Game.mActivity.startActivity(Intent.createChooser(intent,"博雅中国象棋"));
	}
	
	public static void shareTextToWeiBo(String json) {
		String webpageUrl = null;
		String description = "";
		try {
			JSONObject jsonObject = new JSONObject(json);
			webpageUrl = jsonObject.getString("url");
			description = jsonObject.optString("description","");
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		String str = description + "  " + webpageUrl;
		
		Intent intent=new Intent(Intent.ACTION_SEND);
		intent.setType("text/plain");
		intent.putExtra(Intent.EXTRA_SUBJECT, "博雅中国象棋");
		intent.putExtra(Intent.EXTRA_TEXT, str); 
		intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK); 
		intent.setPackage("com.sina.weibo");
		Game.mActivity.startActivity(Intent.createChooser(intent,"博雅中国象棋"));
	}
	
	public static void shareTextToSMS(String json) {
		String webpageUrl = null;
		String description = "";
		try {
			JSONObject jsonObject = new JSONObject(json);
			webpageUrl = jsonObject.getString("url");
			description = jsonObject.optString("description", "");
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		String str = description + "  " + webpageUrl;
		
		Uri smsToUri = Uri.parse("smsto:");
		Intent intent=new Intent(Intent.ACTION_VIEW,smsToUri);
		intent.putExtra("sms_body", str); 
		intent.setType("vnd.android-dir/mms-sms");
//		intent.setType("text/plain");
//		intent.putExtra(Intent.EXTRA_SUBJECT, "博雅中国象棋");
//		intent.putExtra(Intent.EXTRA_TEXT, text); 
		intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
		Game.mActivity.startActivity(Intent.createChooser(intent,"博雅中国象棋"));
	}
	
	public static void shareTextToPYQ(String text,String img) {
		Intent intent=new Intent(Intent.ACTION_SEND);
		ComponentName comp = new ComponentName("com.tencent.mm",                              
				   "com.tencent.mm.ui.tools.ShareToTimeLineUI");
		intent.setType("image/*");
		String  path = FileUtil.getmStrImagesPath() + img;
		Log.i("boyaa","share img:"+path);
		File f = new File(path);
		intent.putExtra(Intent.EXTRA_SUBJECT, "博雅中国象棋");
		intent.putExtra(Intent.EXTRA_TEXT, text); 
		intent.putExtra(Intent.EXTRA_STREAM, Uri.fromFile(f));
		intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK); 
		intent.setComponent(comp);
		Game.mActivity.startActivity(Intent.createChooser(intent,"博雅中国象棋"));
	}
	
	public static void shareTextToWeichat(String text,String img) {
		Intent intent=new Intent(Intent.ACTION_SEND);
		String  path = FileUtil.getmStrImagesPath() + img;
		Log.i("boyaa","share img:"+path);
		intent.setType("text/plain");
		File f = new File(path);
		
		ComponentName comp = new ComponentName("com.tencent.mm",                              
				   "com.tencent.mm.ui.tools.ShareImgUI");
		intent.putExtra(Intent.EXTRA_SUBJECT, "博雅中国象棋");
		intent.putExtra(Intent.EXTRA_TEXT, text);
//		if( f.exists() ) {
//			intent.putExtra(Intent.EXTRA_STREAM, Uri.fromFile(f));
//		}
		intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK); 
		intent.setComponent(comp);
		Game.mActivity.startActivity(Intent.createChooser(intent,"博雅中国象棋"));
	}
}
