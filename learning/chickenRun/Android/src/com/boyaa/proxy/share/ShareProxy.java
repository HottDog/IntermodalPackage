package com.boyaa.proxy.share;

import org.json.JSONException;
import org.json.JSONObject;

import com.boyaa.chinesechess.chicken.Game;
import com.boyaa.entity.core.HandMachine;

import android.os.Bundle;
import android.widget.Toast;

public class ShareProxy {
	private static final int TYPE_PYQ 			= 1;
	private static final int TYPE_WEICHAT 		= 2;
	private static final int TYPE_QQ 			= 3;
	private static final int TYPE_SMS 			= 4;
	private static int id = 0;
	public static void share(String jsonStr) {
		id++;
		try {
			JSONObject jsonObject = new JSONObject(jsonStr);
			Bundle bundle = new Bundle();
			bundle.putString("content", jsonObject.optString("content",""));
			bundle.putString("title", jsonObject.optString("title",""));
			bundle.putString("description", jsonObject.optString("description",""));
			bundle.putString("icon", jsonObject.optString("icon",""));
			
			int type = jsonObject.getInt("type");
			BaseShareInterface baseShareInterface = getShareByType(type);
			baseShareInterface.share(bundle, callback);
		} catch (JSONException e) {
			Toast.makeText(Game.mActivity, "分享失败", Toast.LENGTH_SHORT).show();
		}
	}
	
	public static BaseShareInterface getShareByType(int type) {
		switch (type) {
		case TYPE_PYQ:
			return new ShareToPYQ(id);
		default:
			break;
		}
		return null;
	}
	
	public static BaseShareCallback callback = new BaseShareCallback() {
		
		@Override
		public void success(BaseShareInterface baseShareInterface) {
			// TODO Auto-generated method stub
			final JSONObject jsonObject = new JSONObject();
			try {
				jsonObject.put("id", baseShareInterface.getId());
				jsonObject.put("isSuccess", 1);
				Game.mActivity.runOnLuaThread(new Runnable() {
					public void run() {
						// TODO Auto-generated method stub
						HandMachine.getHandMachine().luaCallEvent(
								"ShareProxy", jsonObject.toString());
					}
				});
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		@Override
		public void fail(BaseShareInterface baseShareInterface) {
			final JSONObject jsonObject = new JSONObject();
			try {
				jsonObject.put("id", baseShareInterface.getId());
				jsonObject.put("isSuccess", 0);
				Game.mActivity.runOnLuaThread(new Runnable() {
					public void run() {
						// TODO Auto-generated method stub
						HandMachine.getHandMachine().luaCallEvent(
								"ShareProxy", jsonObject.toString());
					}
				});
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	};
	
	public interface BaseShareInterface {
		public void share(Bundle bundle,BaseShareCallback baseShareCallback);
		public int getId();
	}
	
	public interface BaseShareCallback {
		public void success(BaseShareInterface baseShareInterface);
		public void fail(BaseShareInterface baseShareInterface);
	}
}
