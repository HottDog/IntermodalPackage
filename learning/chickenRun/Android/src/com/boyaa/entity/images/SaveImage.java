package com.boyaa.entity.images;

import org.json.JSONException;
import org.json.JSONObject;

import android.content.Intent;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.provider.MediaStore;
import android.util.Log;

import com.boyaa.chinesechess.chicken.Game;
import com.boyaa.entity.common.SDTools;
import com.boyaa.entity.core.HandMachine;
import com.boyaa.made.FileUtil;

public class SaveImage {
	
	private Game activity;
	private String strDicName;
	private boolean isFBimage;
	public SaveImage(){
		
	}
	public SaveImage(Game activity , String strDicName){
		this.activity = activity;
		this.strDicName = strDicName;
	}
	
	private String  imageName= "headIcon03";
	private String Api = "";
	private String Url = "";
	private static boolean savesucess = false;
	/** 用来标识请求gallery的activity */
	public static final int PHOTO_PICKED_WITH_DATA = 1001;
	private static final int MAXSIZE = 128;   //图片的长、宽最大长度
	
	
	/**
	 * 请求Gallery程序
	 * @param isFBimg,是否是反馈里面截图
	 */
	public void doPickPhotoFromGallery(String imageNamePar,boolean isFBimg) {
		Log.i("SaveImage","doPickPhotoFromGallery ");
		isFBimage = isFBimg;
		JSONObject jsonResult = null;
		try {
			jsonResult = new JSONObject(imageNamePar);
			imageName = jsonResult.getString("ImageName");
			Api = jsonResult.getString("Api");
			Url = jsonResult.getString("Url");
			Log.i("SaveImage","doPickPhotoFromGallery imageName = " + imageName);
			Log.i("SaveImage","doPickPhotoFromGallery Api = " + Api);
			Log.i("SaveImage","doPickPhotoFromGallery Url = " + Url);
			Log.i("SaveImage","doPickPhotoFromGallery Url = " + Url);
		} catch (JSONException e) {
			Log.i("SaveImage","doPickPhotoFromGallery JSONException e = " + e.getMessage());
			Log.i("SaveImage","doPickPhotoFromGallery JSONException e = " + e.getStackTrace());
		}
//		ACTION_PICK直接“选取图片”,ACTION_GET_CONTENT会有几种图片可供选择，为了避免onSaveBitmap返回的data为空,所以选择ACTION_PICK方式。
//		Intent intent = new Intent(Intent.ACTION_PICK,
//                android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
		Intent intent = new Intent();
		intent.setType("image/*");
		intent.setAction(Intent.ACTION_PICK);
		intent.putExtra("crop", "true");
		intent.putExtra("aspectX", 1);
		intent.putExtra("aspectY", 1);
		intent.putExtra("outputX", 300);
		intent.putExtra("outputY", 300);
		intent.putExtra("return-data", true);
//		activity.startActivityForResult(Intent.createChooser(intent, "请选择头像"),
//				PHOTO_PICKED_WITH_DATA);
		activity.startActivityForResult(intent,
				PHOTO_PICKED_WITH_DATA);
		

//		Intent intent = new Intent();
//		intent.setType("image/*");
//		intent.setAction(Intent.ACTION_GET_CONTENT);
//		intent.putExtra("crop", "true");
//		intent.putExtra("aspectX", 1);
//		intent.putExtra("aspectY", 1);
//		intent.putExtra("outputX", 300);
//		intent.putExtra("outputY", 300);
//		intent.putExtra("return-data", true);
//		activity.startActivityForResult(Intent.createChooser(intent, "请选择头像"),
//				PHOTO_PICKED_WITH_DATA);

	}
	
	public void onSaveBitmap(Intent data){
		
		Bitmap photo = data.getParcelableExtra("data");
		if (photo != null) {
		
			Log.d("DEBUG", "big width = " + photo.getWidth()
					+ " height = " + photo.getHeight());
		

			savesucess = SDTools.saveBitmap(
					activity, FileUtil.getmStrImagesPath(), imageName , photo);
			photo.recycle();
			photo = null;
		} else {
			Uri uri = data.getData();
			if (uri != null) {
				String path = getPath(uri);
				if(path == null){
					savesucess = false;
				}
				BitmapFactory.Options options = new BitmapFactory.Options();
				options.inJustDecodeBounds = true;
				BitmapFactory.decodeFile(path, options);
				int maxlen = (options.outHeight > options.outWidth) ? options.outHeight
						: options.outWidth;
				options.inSampleSize = maxlen / MAXSIZE;
				options.inJustDecodeBounds = false;
				photo = BitmapFactory.decodeFile(path, options);
				if (null != photo) {
					Log.d("DEBUG", "big width = " + photo.getWidth()
							+ " height = " + photo.getHeight());
					savesucess = SDTools.saveBitmap(
							activity, FileUtil.getmStrImagesPath(), imageName , photo);
					photo.recycle();
					photo = null;
				}
			}
		}
		
		
		if (savesucess){
			if (!isFBimage){//反馈只是选中截图，不需要上传
				// 生成新的
				String fullPath = FileUtil.getmStrImagesPath() + imageName + SDTools.PNG_SUFFIX;
				Log.i("uploadPhoto", "uploadPhoto url = " + Url);
				
				UploadImage.uploadPhoto(activity, photo , fullPath , Api , Url , strDicName,false);				
			}else{
				final JSONObject ret = new JSONObject();
				try {
					ret.put("imageName", imageName);
					// 保存本地成功后，返回反馈界面，设置截图				
					activity.runOnLuaThread(new Runnable() {

						@Override
						public void run() {
							HandMachine.getHandMachine().luaCallEvent(strDicName , ret.toString());
						}
					});	
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}

		}else{
			activity.runOnLuaThread(new Runnable() {
				@Override
				public void run() {
					HandMachine.getHandMachine().luaCallEvent(strDicName , null);
				}
			});
			
		} 


	}
	
	private String getPath(Uri uri) {
		if(uri == null){
			Log.e(this+"", "null uri!");
			return null;
		}
		String[] projection = { MediaStore.Images.Media.DATA };
		Cursor cursor = activity.managedQuery(uri, projection, null, null, null);
		if(cursor == null){
			//当使用第三方资源管理选择照片的时候
			String uriString = uri.toString();
			Log.d("DEBUG", "uri = "+uriString);
			uriString = uriString.replace("file://", "");
			Log.d("DEBUG", "uri2 = "+uriString);
			
			return uriString;
		}
		int column_index = cursor
				.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
		cursor.moveToFirst();
		return cursor.getString(column_index);

	}
	
}
