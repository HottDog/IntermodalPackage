package com.boyaa.chinesechess.chicken.wxapi;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.Map;
import java.util.UUID;

import org.json.JSONException;
import org.json.JSONObject;

import android.annotation.SuppressLint;
import android.annotation.TargetApi;
import android.app.Dialog;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.BitmapFactory.Options;
import android.os.Build;
import android.os.Bundle;
import android.widget.Toast;

import com.boyaa.chinesechess.chicken.Game;
import com.boyaa.chinesechess.chicken.R;
import com.boyaa.chinesechess.chicken.wxapi.Alert.onAlertItemClick;
import com.boyaa.entity.common.SDTools;
import com.boyaa.entity.common.utils.UtilTool;
import com.boyaa.entity.core.HandMachine;
import com.boyaa.made.FileUtil;
import com.boyaa.share.NativeShare;
import com.boyaa.webview.ShareToBoyaaDialog;
import com.tencent.mm.sdk.modelmsg.SendAuth;
import com.tencent.mm.sdk.modelmsg.SendMessageToWX;
import com.tencent.mm.sdk.modelmsg.WXImageObject;
import com.tencent.mm.sdk.modelmsg.WXMediaMessage;
import com.tencent.mm.sdk.modelmsg.WXTextObject;
import com.tencent.mm.sdk.modelmsg.WXWebpageObject;
import com.tencent.mm.sdk.modelpay.PayReq;
import com.tencent.mm.sdk.openapi.IWXAPI;
import com.tencent.mm.sdk.openapi.WXAPIFactory;
//import android.text.ClipboardManager;

@TargetApi(Build.VERSION_CODES.HONEYCOMB)
public class SendToWXUtil {
	
	public static IWXAPI api;
	public static String state;
	protected static String line = "share_to_wechat";
	
	protected static String webpageUrl = null;
	protected static String description = "博雅中国象棋";
	protected static String title = "博雅中国象棋";	
	
    public static void onCreate(Context context) {
    	api = WXAPIFactory.createWXAPI(context, Constants.APP_ID, false);
    	api.registerApp(Constants.APP_ID);
    }
    
    public static WXMediaMessage.IMediaObject getIMediaObjectById(final int type,final Bundle data) {
    	switch(type) {
	    	case WXMediaMessage.IMediaObject.TYPE_IMAGE:{
	    		WXImageObject imageObject = new WXImageObject();
	    		imageObject.imageUrl = data.getString("imageUrl");
	    		return imageObject;
	    	}
//	    	break;
	    	case WXMediaMessage.IMediaObject.TYPE_TEXT:{
	    		WXTextObject textObject = new WXTextObject();
	    		textObject.text = data.getString("text");
	    		return textObject;
	    	}
//	    	break;
	    	case WXMediaMessage.IMediaObject.TYPE_URL:{
	    		WXWebpageObject webpageObject = new WXWebpageObject();
	    		webpageObject.webpageUrl = data.getString("webpageUrl");
	    		return webpageObject;
	    	}
//	    	break;
    	}
    	return null;
    }
    
    @SuppressLint("NewApi")
	public static void WXSend(Bundle data){

		// TODO Auto-generated method stub
		if (isWXAppInstalled()) {
            //提醒用户没有按照微信
            return;
        }
		WXMediaMessage.IMediaObject mediaObject = getIMediaObjectById(data.getInt("type", 0),data);
		if ( mediaObject == null || mediaObject.checkArgs() == false) {
			Game.mActivity.runOnUiThread(new Runnable() {
				@Override
				public void run() {
					// TODO Auto-generated method stub
					Toast.makeText(Game.mActivity, "数据错误,发送失败", Toast.LENGTH_LONG).show();
				}
			});
			return ;
		}
		WXMediaMessage msg = new WXMediaMessage(mediaObject);
		Bitmap thumb = BitmapFactory.decodeResource(Game.mActivity.getResources(), R.drawable.shareicon);
		msg.setThumbImage(thumb);
		msg.description = data.getString("description","");
		msg.title = data.getString("title");
		SendMessageToWX.Req req = new SendMessageToWX.Req();
		req.transaction = buildTransaction("webpage");
		req.message = msg;
		req.scene = data.getInt("isTimeline") == 1 ? SendMessageToWX.Req.WXSceneTimeline : SendMessageToWX.Req.WXSceneSession;
		if (!api.sendReq(req)) {
			Game.mActivity.runOnUiThread(new Runnable() {
				@Override
				public void run() {
					// TODO Auto-generated method stub
					Toast.makeText(Game.mActivity, "发送失败", Toast.LENGTH_LONG).show();
				}
			});
		}
	}
    
    public static String buildTransaction(final String type) {
		return (type == null) ? String.valueOf(System.currentTimeMillis()) : type + System.currentTimeMillis();
	}

	public static class SendWebPageToWX implements onAlertItemClick{

		@Override
		public void onClick(Bundle bundle) {
			// TODO Auto-generated method stub
			if (isWXAppInstalled()) {
	            //提醒用户没有按照微信
	            return;
	        }

			UtilTool.sendCountToMain(line);

			WXWebpageObject webpage = new WXWebpageObject();
			webpage.webpageUrl = bundle.getString("url");
//			Log.e("SendWebPageToWX",webpage.webpageUrl);
			WXMediaMessage msg = new WXMediaMessage(webpage);
			msg.title = "残局："+bundle.getString("title")+"（博雅中国象棋）";
			msg.description = "残局："+bundle.getString("title")+"（博雅中国象棋）";
			Bitmap thumb = BitmapFactory.decodeResource(Game.mActivity.getResources(), R.drawable.shareicon);
			msg.setThumbImage(thumb);
			SendMessageToWX.Req req = new SendMessageToWX.Req();
			req.transaction = buildTransaction("webpage");
			req.message = msg;
			req.scene = SendMessageToWX.Req.WXSceneSession;
			api.sendReq(req);
			
		}
	}

	
	public static class SendWebPageToPYQ implements onAlertItemClick{

		@Override
		public void onClick(Bundle bundle) {
			// TODO Auto-generated method stub
			if (isWXAppInstalled()) {
	            //提醒用户没有按照微信
	            return;
	        }
			UtilTool.sendCountToMain(line);
			
			WXWebpageObject webpage = new WXWebpageObject();
			webpage.webpageUrl = bundle.getString("url");
//			Log.e("SendWebPageToWX",webpage.webpageUrl);
			WXMediaMessage msg = new WXMediaMessage(webpage);
			msg.title = "残局："+bundle.getString("title")+"（博雅中国象棋）";
			msg.description = "残局："+bundle.getString("title")+"（博雅中国象棋）";
			Options options = new Options();
			Bitmap thumb = BitmapFactory.decodeResource(Game.mActivity.getResources(), R.drawable.shareicon);
			msg.setThumbImage(thumb);
			
			SendMessageToWX.Req req = new SendMessageToWX.Req();
			req.transaction = buildTransaction("webpage");
			req.message = msg;
			req.scene = SendMessageToWX.Req.WXSceneTimeline;
			api.sendReq(req);
		}
	}
	
	// 分享复盘到朋友圈
	public static class SendFPWebPageToPYQ implements onAlertItemClick{

		@Override
		public void onClick(Bundle bundle) {
			// TODO Auto-generated method stub
			if (isWXAppInstalled()) {
	            //提醒用户没有按照微信
	            return;
	        }
			
			UtilTool.sendCountToMain(line);
			
			WXWebpageObject webpage = new WXWebpageObject();
			webpage.webpageUrl = bundle.getString("url");
//			Log.e("SendWebPageToWX",webpage.webpageUrl);
			WXMediaMessage msg = new WXMediaMessage(webpage);
			msg.title = "复盘演练（博雅中国象棋）";
			msg.description = "复盘让您回顾精彩对局";
			Options options = new Options();
			Bitmap thumb = BitmapFactory.decodeResource(Game.mActivity.getResources(), R.drawable.shareicon);
			msg.setThumbImage(thumb);
			
			SendMessageToWX.Req req = new SendMessageToWX.Req();
			req.transaction = buildTransaction("webpage");
			req.message = msg;
			req.scene = SendMessageToWX.Req.WXSceneTimeline;
			api.sendReq(req);
		}
	}
	
	// 分享复盘到微信
	public static class SendFPWebPageToWX implements onAlertItemClick{

		@Override
		public void onClick(Bundle bundle) {
			// TODO Auto-generated method stub
			if (isWXAppInstalled()) {
	            //提醒用户没有按照微信
	            return;
	        }
			
			UtilTool.sendCountToMain(line);
			
			WXWebpageObject webpage = new WXWebpageObject();
			webpage.webpageUrl = bundle.getString("url");
//			Log.e("SendWebPageToWX",webpage.webpageUrl);
			WXMediaMessage msg = new WXMediaMessage(webpage);
			msg.title = "复盘演练（博雅中国象棋）";
			msg.description = "复盘让您回顾精彩对局";
			Bitmap thumb = BitmapFactory.decodeResource(Game.mActivity.getResources(), R.drawable.shareicon);
			msg.setThumbImage(thumb);
			SendMessageToWX.Req req = new SendMessageToWX.Req();
			req.transaction = buildTransaction("webpage");
			req.message = msg;
			req.scene = SendMessageToWX.Req.WXSceneSession;
			api.sendReq(req);
			
		}
		
	}
	
	
	public static class SendWebPageToBoyaa implements onAlertItemClick{

		@Override
		public void onClick(Bundle bundle) {
			// TODO Auto-generated method stub
			Dialog dialog = ShareToBoyaaDialog.showDialog(Game.mActivity,bundle,null);
			if(dialog!=null) {
				dialog.show();
			}
		}
	}
	
	public static class SaveNative implements onAlertItemClick{

		@Override
		public void onClick(Bundle bundle) {
			// TODO Auto-generated method stub
			final JSONObject jsonObject = new JSONObject();
			try {
				jsonObject.put("manual_type",bundle.getString("manual_type"));
				jsonObject.put("red_mid",bundle.getString("red_mid"));
				jsonObject.put("black_mid",bundle.getString("black_mid"));
				jsonObject.put("win_flag",bundle.getString("win_flag"));
				jsonObject.put("end_type",bundle.getString("end_type"));
				jsonObject.put("chess_opening",bundle.getString("chess_opening"));
				jsonObject.put("move_list",bundle.getString("move_list"));
				jsonObject.put("news_pid",bundle.getString("news_pid"));
				jsonObject.put("manual_id",bundle.getString("manual_id"));
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				return;
			}
			Game.mActivity.runOnLuaThread(new Runnable() {
				
				@Override
				public void run() {
					// TODO Auto-generated method stub
					HandMachine.getHandMachine().luaCallEvent("saveChess", jsonObject.toString());
				}
			});
		}
	}
	
	public static class CopyUrl implements onAlertItemClick{

		@Override
		public void onClick(Bundle bundle) {
			// TODO Auto-generated method stub
			ClipboardManager clipboard = (ClipboardManager)Game.mActivity.getSystemService(Context.CLIPBOARD_SERVICE);
			String url = bundle.getString("url");
			if(url != null){
//				clipboard.setText(url);
				clipboard.setPrimaryClip(ClipData.newPlainText("象棋分享链接",url));
				Toast.makeText(Game.mActivity, "已复制到粘贴板", Toast.LENGTH_LONG).show();
			}else{
				Toast.makeText(Game.mActivity, "复制失败", Toast.LENGTH_LONG).show();
			}
			
		}
	}
	
	public static class SendAuthToGetToken implements onAlertItemClick {

		@Override
		public void onClick(Bundle bundle) {
			// TODO Auto-generated method stub
			if (isWXAppInstalled()) {
	            //提醒用户没有按照微信
	            return;
	        }
			SendAuth.Req req = new SendAuth.Req();
			req.scope = "snsapi_userinfo";
			state = UUID.randomUUID().toString();
			req.state = state;
			api.sendReq(req);
		}
		
	}
	
	public static class SendOther implements onAlertItemClick {

		@Override
		public void onClick(Bundle bundle) {
			// TODO Auto-generated method stub
			Game.mActivity.runOnLuaThread(new Runnable() {
				
				@Override
				public void run() {
					NativeShare.takeShot("share");
					NativeShare.shareImg("share");
					HandMachine.getHandMachine().luaCallEvent(
							HandMachine.kShareSuccessCallBack, ""); //默认分享成功
				}
			});
		}
	}
	
	
	public static boolean isWXAppInstalled() {
		if (!api.isWXAppInstalled()) {
            //提醒用户没有按照微信
			Game.mActivity.runOnUiThread(new Runnable() {
				
				@Override
				public void run() {
					// TODO Auto-generated method stub
					Toast.makeText(Game.mActivity, "请先安装微信", Toast.LENGTH_LONG).show();
				}
			});
            return true;
        }
		return false;
	}
	
	public static Bitmap getBitmap() {
		String  path = FileUtil.getmStrImagesPath()+ "share" + SDTools.JPG_SUFFIX;
		Options options = new Options();
		options.inPreferredConfig =Bitmap.Config.ARGB_4444;
	    return BitmapFactory.decodeFile(path,options);
	}
	
	public static void shareTextToPYQ(String json,String img) {
		if (isWXAppInstalled()) {
            //提醒用户没有按照微信
            return;
        }
		
		String webpageUrl = null;
		String description = "博雅中国象棋";
		try {
			JSONObject jsonObject = new JSONObject(json);
			webpageUrl = jsonObject.getString("download_url");
			description = jsonObject.getString("description");
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			dataNull();
			return;
		}
		
		UtilTool.sendCountToMain(line);
		
		String  path = FileUtil.getmStrImagesPath() + img;
//		Log.i("boyaa","share img:"+path);
		
		WXWebpageObject webpage = new WXWebpageObject();
		webpage.webpageUrl = webpageUrl;
//		Log.e("SendWebPageToWX",webpage.webpageUrl);
		WXMediaMessage msg = new WXMediaMessage(webpage);
		msg.title = "博雅中国象棋";
		msg.description = description;
		Options options = new Options();
		Bitmap thumb = BitmapFactory.decodeFile(path);
		if( thumb == null) thumb = BitmapFactory.decodeResource(Game.mActivity.getResources(), R.drawable.shareicon);
		msg.setThumbImage(thumb);
		
		SendMessageToWX.Req req = new SendMessageToWX.Req();
		req.transaction = buildTransaction("webpage");
		req.message = msg;
		req.scene = SendMessageToWX.Req.WXSceneTimeline;
		if(!api.sendReq(req)) {
			thumb = BitmapFactory.decodeResource(Game.mActivity.getResources(), R.drawable.shareicon);
			msg.setThumbImage(thumb);
			req.transaction = buildTransaction("webpage");
			req.message = msg;
			req.scene = SendMessageToWX.Req.WXSceneTimeline;
			api.sendReq(req);
		}
	}
	
	public static void shareTextToWeichat(String json,String img) {
		if (isWXAppInstalled()) {
            //提醒用户没有按照微信
            return;
        }
		String webpageUrl = null;
		String description = "博雅中国象棋";
		try {
			JSONObject jsonObject = new JSONObject(json);
			webpageUrl = jsonObject.getString("download_url");
			description = jsonObject.getString("description");
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			dataNull();
			return;
		}
		UtilTool.sendCountToMain(line);
		
		String  path = FileUtil.getmStrImagesPath() + img;
//		Log.i("boyaa","share img:"+path);
		
		WXWebpageObject webpage = new WXWebpageObject();
		webpage.webpageUrl = webpageUrl;
//		Log.e("SendWebPageToWX",webpage.webpageUrl);
		WXMediaMessage msg = new WXMediaMessage(webpage);
		msg.title = "博雅中国象棋";
		msg.description = description;
		Options options = new Options();
		Bitmap thumb = BitmapFactory.decodeFile(path);
		if( thumb == null) thumb = BitmapFactory.decodeResource(Game.mActivity.getResources(), R.drawable.shareicon);
		msg.setThumbImage(thumb);
		
		SendMessageToWX.Req req = new SendMessageToWX.Req();
		req.transaction = buildTransaction("webpage");
		req.message = msg;
		req.scene = SendMessageToWX.Req.WXSceneSession;
		if(!api.sendReq(req)) {
			thumb = BitmapFactory.decodeResource(Game.mActivity.getResources(), R.drawable.shareicon);
			msg.setThumbImage(thumb);
			req.transaction = buildTransaction("webpage");
			req.message = msg;
			req.scene = SendMessageToWX.Req.WXSceneSession;
			api.sendReq(req);
		}
	}
	
	@SuppressLint("DefaultLocale")
	public static void weixinPay (Map content){
		if (isWXAppInstalled()) {
            //提醒用户没有按照微信
            return;
        }
    	JSONObject json;
		try {
			json = new JSONObject(content);
//			Log.i("weixinPay--start",json.toString());
			String appId 		=  json.getString("appId");
			String partnerId 	=  json.getString("partnerId");
			String prepayId 	=  json.getString("prepayId");
			String nonceStr 	=  json.getString("nonceStr");
			String timeStamp 	=  json.getString("timeStamp");
			String packageValue =  json.getString("packageValue");
			String extData 		=  json.getString("extData");
			String sign 		=  json.getString("sign");
			PayReq req = new PayReq();
			req.appId			= appId;
			req.partnerId		= partnerId;
			req.prepayId		= prepayId;
			req.nonceStr		= nonceStr;
			req.timeStamp		= timeStamp;
			req.packageValue	= packageValue;
			req.extData			= "";
			req.sign			= sign;
			api.sendReq(req);		
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
	}
	
	/**
	 * 分享微信好友
	 * @param json
	 * @param imgStr
	 * @data 2016.6.12
	 * @return
	 */
	public static boolean shareToWECHAT(String json,String imgStr) {
		if (isWXAppInstalled()) {
            //提醒用户没有按照微信
            return false;
        }
		if (!analyzeJsonData(json)){
			return false;
		}
		String  path = FileUtil.getmStrImagesPath() + imgStr;
		Bitmap thumb = BitmapFactory.decodeFile(path);
		String type = "weixin";
		weixinApi(thumb,setShareData(thumb),type);
		return true;
	}
	
	/**
	 * 分享朋友圈
	 * @param json
	 * @param imgStr
	 * @return
	 */
	public static boolean shareToPYQ(String json,String imgStr) {
		if (isWXAppInstalled()) {
            //提醒用户没有按照微信
            return false;
        }		
		if (!analyzeJsonData(json)){
			return false;
		}
		String  path = FileUtil.getmStrImagesPath() + imgStr;
		Bitmap thumb = BitmapFactory.decodeFile(path);
		String type = "pyq";
		weixinApi(thumb,setShareData(thumb),type);
		return true;
	}
	
	/**
	 * json数据解析并赋值
	 */
	protected static boolean analyzeJsonData(String jsonData){
		try {
			JSONObject jsonObject = new JSONObject(jsonData);
			webpageUrl = jsonObject.optString("url",""); //getString("url");
			description = jsonObject.optString("description", "博雅中国象棋"); //getString("description");
			title = jsonObject.optString("title","博雅中国象棋"); //getString("title");
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			dataNull();
			return false;
		}
		return true;
	}
	
	/**
	 * 分享数据内容
	 * @return 
	 */
	protected static WXMediaMessage setShareData(Bitmap thumb){
		WXWebpageObject webpage = new WXWebpageObject();
		webpage.webpageUrl = webpageUrl;
		WXMediaMessage msg = new WXMediaMessage(webpage);
		msg.title = title;
		msg.description = description;
		Options options = new Options();
		if( thumb == null) thumb = BitmapFactory.decodeResource(Game.mActivity.getResources(), R.drawable.shareicon);
		msg.setThumbImage(thumb);
		return msg;
	}
	
	/**
	 * 微信api
	 */
	protected static void weixinApi(Bitmap thumb,WXMediaMessage msg,String type){
		int temp = SendMessageToWX.Req.WXSceneSession;
		if (type == "weixin"){
			temp = SendMessageToWX.Req.WXSceneSession;
		}else if (type == "pyq"){
			temp = SendMessageToWX.Req.WXSceneTimeline;
			msg.title = description;
		}
		
		SendMessageToWX.Req req = new SendMessageToWX.Req();
		req.transaction = buildTransaction("webpage");
		req.message = msg;
		req.scene = temp;
		if(!api.sendReq(req)) {
			thumb = BitmapFactory.decodeResource(Game.mActivity.getResources(), R.drawable.shareicon);
			msg.setThumbImage(thumb);
			req.transaction = buildTransaction("webpage");
			req.message = msg;
			req.scene = temp;
			api.sendReq(req);
		}
	}
		
	/**
	 * json解析错误，提示分享失败
	 */
	protected static void dataNull(){
		Game.mActivity.runOnUiThread(new Runnable() {
			
			@Override
			public void run() {
				// TODO Auto-generated method stub
				Toast.makeText(Game.mActivity, "分享失败", Toast.LENGTH_LONG).show();
			}
		});
        return;
	}
	/**
	 *  下面的都是bearluo 用于重构分享接口的 不要自己修改  如有一样功能 请自己重写
	 * 
	 */
	public static Bitmap compressBitmap(Bitmap bmp) throws IOException {
		int IMAGE_SIZE=32768;//微信分享图片大小限制 
		ByteArrayOutputStream output = new ByteArrayOutputStream();
		bmp.compress(Bitmap.CompressFormat.JPEG, 100, output);  
		int options = 100;
		while (output.toByteArray().length > IMAGE_SIZE && options != 10) {   
            output.reset(); //清空baos  
            bmp.compress(Bitmap.CompressFormat.PNG, options, output);//这里压缩options%，把压缩后的数据存放到baos中    
            options -= 10;  
        }
        bmp.recycle();  
        byte[] result = output.toByteArray();  
        output.close(); 
        return BitmapFactory.decodeByteArray(result, 0, result.length);
	}
	
	
	public static boolean shareToPYQ1(String content,String title,String description,Bitmap thumb) {
		boolean ret = false;
		if (isWXAppInstalled())return false;
		if (description == null || "".equals(description))description = "博雅中国象棋";
		if (title == null || "".equals(title))description = "博雅中国象棋";
		WXWebpageObject webpage = new WXWebpageObject();
		webpage.webpageUrl = content;
		WXMediaMessage msg = new WXMediaMessage(webpage);
		msg.title = title;
		msg.description = description;
		if( thumb == null) thumb = BitmapFactory.decodeResource(Game.mActivity.getResources(), R.drawable.shareicon);
		try {
			thumb = compressBitmap(thumb);
		} catch (IOException e) {
			thumb = BitmapFactory.decodeResource(Game.mActivity.getResources(), R.drawable.shareicon);
		}
		msg.setThumbImage(thumb);
		SendMessageToWX.Req req = new SendMessageToWX.Req();
		req.transaction = buildTransaction("webpage");
		req.message = msg;
		req.scene = SendMessageToWX.Req.WXSceneTimeline;
		ret = api.sendReq(req);
		if(!ret) {
			msg.setThumbImage(null);
			req.transaction = buildTransaction("webpage");
			req.message = msg;
			req.scene = SendMessageToWX.Req.WXSceneTimeline;
			ret = api.sendReq(req);
		}
		return ret;
	}
	
	
}
