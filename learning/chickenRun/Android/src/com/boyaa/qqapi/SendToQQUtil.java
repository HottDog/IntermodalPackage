package com.boyaa.qqapi;

import java.util.List;

import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.widget.Toast;

import com.boyaa.chinesechess.chicken.Game;
import com.boyaa.chinesechess.chicken.R;
import com.boyaa.chinesechess.chicken.wxapi.Alert.onAlertItemClick;
import com.boyaa.entity.common.utils.UtilTool;
import com.tencent.connect.share.QQShare;
import com.tencent.tauth.Tencent;


public class SendToQQUtil {
	
	public static Tencent mTencent;
	protected static String line = "share_to_qq";
    public static void onCreate(Context context) {
    	mTencent = Tencent.createInstance(QQConstants.QQ_APP_ID, context);
    }
    
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
    	if (null != mTencent)
    	mTencent.onActivityResult(requestCode, resultCode, data);
    } 
    /**
     * 判断qq是否可用
     * 
     * @param context
     * @return
     */
    protected static boolean isQQClientAvailable(Context context) {
        final PackageManager packageManager = context.getPackageManager();
        List<PackageInfo> pinfo = packageManager.getInstalledPackages(0);
        if (pinfo != null) {
            for (int i = 0; i < pinfo.size(); i++) {
                String pn = pinfo.get(i).packageName;
                if (pn.equals("com.tencent.mobileqq")) {
                    return true;
                }
            }
        }
        return false;
    }
    
    public static boolean isQQInstalled(){
    	if (!isQQClientAvailable(Game.mActivity)) {
            //提醒用户没有安装QQ
			Game.mActivity.runOnUiThread(new Runnable() {
				@Override
				public void run() {
					// TODO Auto-generated method stub
					Toast.makeText(Game.mActivity, "请先安装QQ", Toast.LENGTH_LONG).show();
				}
			});
            return true;
        }
		return false;	
    }
    
    /**
     * 直接分享文本或链接
     * 
     * @param context
     * @return
     */
    public static void shareTextToQQ(String json,String imgStr) {
    	if (isQQInstalled()) {
            //提醒用户没有安装QQ
            return;
        }
    	
    	String webpageUrl = null;
		String description = "博雅中国象棋";
		try {
			JSONObject jsonObject = new JSONObject(json);
			webpageUrl = jsonObject.getString("download_url");
			description = jsonObject.optString("description","博雅中国象棋");
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			dataNull();
			return;
		}
    	
//    	UtilTool.sendCountToMain(line);
    	
		String path =  Game.mActivity.getResources().getString(R.string.boyaa_qq_share);  //qq分享图片链接地址
		String title = "博雅中国象棋";
		
        final Bundle params = new Bundle();
        params.putInt(QQShare.SHARE_TO_QQ_KEY_TYPE, QQShare.SHARE_TO_QQ_TYPE_DEFAULT);
        params.putString(QQShare.SHARE_TO_QQ_TITLE, title);
        params.putString(QQShare.SHARE_TO_QQ_SUMMARY,  description);
        params.putString(QQShare.SHARE_TO_QQ_TARGET_URL,  webpageUrl);
        params.putString(QQShare.SHARE_TO_QQ_IMAGE_URL,path);
        params.putString(QQShare.SHARE_TO_QQ_APP_NAME, null);
        params.putInt(QQShare.SHARE_TO_QQ_EXT_INT,  QQShare.SHARE_TO_QQ_FLAG_QZONE_ITEM_HIDE);		
        mTencent.shareToQQ(Game.mActivity, params, new QQUIListener());
    }
    
    /**
     * 分享文本或链接
     * 
     * @param context
     * @return
     */
	
	public static class SendWebPageToQQ implements onAlertItemClick{

		@Override
		public void onClick(Bundle bundle) {
			// TODO Auto-generated method stub
			if (isQQInstalled()) {
	            //提醒用户没有安装QQ
	            return;
	        }
			
			UtilTool.sendCountToMain(line);
			
			String webpageUrl = bundle.getString("url");
			String title = bundle.getString("title");
			if ( title == null ) {
				title = "博雅中国象棋";
			}
			
			String path = Game.mActivity.getResources().getString(R.string.boyaa_qq_share);
			
	        final Bundle params = new Bundle();
	        params.putInt(QQShare.SHARE_TO_QQ_KEY_TYPE, QQShare.SHARE_TO_QQ_TYPE_DEFAULT);
	        params.putString(QQShare.SHARE_TO_QQ_TITLE, "残局："+title+"（博雅中国象棋）");
	        params.putString(QQShare.SHARE_TO_QQ_SUMMARY,  "残局："+title+"（博雅中国象棋）");
	        params.putString(QQShare.SHARE_TO_QQ_TARGET_URL,  webpageUrl);
	        params.putString(QQShare.SHARE_TO_QQ_IMAGE_URL,path);
	        params.putString(QQShare.SHARE_TO_QQ_APP_NAME, null);
	        params.putInt(QQShare.SHARE_TO_QQ_EXT_INT,  QQShare.SHARE_TO_QQ_FLAG_QZONE_ITEM_HIDE);		
	        mTencent.shareToQQ(Game.mActivity, params, new QQUIListener());
		}
	}
	
	 /**
     * 分享复盘
     * 
     * @param context
     * @return
     */
	public static class SendFPWebPageToQQ implements onAlertItemClick{

		@Override
		public void onClick(Bundle bundle) {
			// TODO Auto-generated method stub
			if (isQQInstalled()) {
	            //提醒用户没有安装QQ
	            return;
	        }
			
			UtilTool.sendCountToMain(line);
			
			String webpageUrl = bundle.getString("url");
			String title = "复盘演练（博雅中国象棋）";
			String description = "复盘让您回顾精彩对局";
			String path = Game.mActivity.getResources().getString(R.string.boyaa_qq_share);
			
	        final Bundle params = new Bundle();
	        params.putInt(QQShare.SHARE_TO_QQ_KEY_TYPE, QQShare.SHARE_TO_QQ_TYPE_DEFAULT);
	        params.putString(QQShare.SHARE_TO_QQ_TITLE, title);
	        params.putString(QQShare.SHARE_TO_QQ_SUMMARY,  description);
	        params.putString(QQShare.SHARE_TO_QQ_TARGET_URL,  webpageUrl);
	        params.putString(QQShare.SHARE_TO_QQ_IMAGE_URL,path);
	        params.putString(QQShare.SHARE_TO_QQ_APP_NAME, null);
	        params.putInt(QQShare.SHARE_TO_QQ_EXT_INT,  QQShare.SHARE_TO_QQ_FLAG_QZONE_ITEM_HIDE);		
	        mTencent.shareToQQ(Game.mActivity, params, new QQUIListener());
		}
	}
	
	
    public static void shareToQQ(String json,String imgStr) {
    	if (isQQInstalled()) {
            //提醒用户没有安装QQ
            return;
        }
    	
    	String webpageUrl = null;
		String description = "博雅中国象棋";
		String title = "博雅中国象棋";
		
		try {
			JSONObject jsonObject = new JSONObject(json);
			webpageUrl = jsonObject.getString("url");
			description = jsonObject.optString("description","博雅中国象棋");
			title = jsonObject.optString("title","博雅中国象棋");
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			dataNull();
			return;
		}
    	
//    	UtilTool.sendCountToMain(line);
    	
		String path =  Game.mActivity.getResources().getString(R.string.boyaa_qq_share);  //qq分享图片链接地址
		
        final Bundle params = new Bundle();
        params.putInt(QQShare.SHARE_TO_QQ_KEY_TYPE, QQShare.SHARE_TO_QQ_TYPE_DEFAULT);
        params.putString(QQShare.SHARE_TO_QQ_TITLE, title);
        params.putString(QQShare.SHARE_TO_QQ_SUMMARY,  description);
        params.putString(QQShare.SHARE_TO_QQ_TARGET_URL,  webpageUrl);
        params.putString(QQShare.SHARE_TO_QQ_IMAGE_URL,path);
        params.putString(QQShare.SHARE_TO_QQ_APP_NAME, null);
        params.putInt(QQShare.SHARE_TO_QQ_EXT_INT,  QQShare.SHARE_TO_QQ_FLAG_QZONE_ITEM_HIDE);		
        mTencent.shareToQQ(Game.mActivity, params, new QQUIListener());
    }
	
	/**
	 * json解析错误，提示分享失败
	 */
	public static void dataNull(){
		Game.mActivity.runOnUiThread(new Runnable() {
			
			@Override
			public void run() {
				// TODO Auto-generated method stub
				Toast.makeText(Game.mActivity, "分享失败", Toast.LENGTH_LONG).show();
			}
		});
        return;
	}

}
