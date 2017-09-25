package com.boyaa.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.json.JSONException;
import org.json.JSONObject;

import android.util.Log;

import com.boyaa.chinesechess.chicken.Game;
import com.boyaa.entity.core.HandMachine;
import com.boyaa.made.AppActivity;

public class Location {
	
	static String DICT_NAME = "location_dict_name";
	static String DICT_KEY_LOCATION = "Location";
	static String LOCATION_URL = "http://ip.taobao.com/service/getIpInfo2.php";
	static String NAME = "ip";
	static String VALUE = "myip";
	
	public static void init(){
		
		Game.mActivity.runOnLuaThread(new Runnable() {
			
			@Override
			public void run() {
				// TODO Auto-generated method stub
				getJsonByHttp();
			}
		});
		
	}
	private static void getJsonByHttp(){
		NameValuePair pair = new BasicNameValuePair(NAME, VALUE);
        List<NameValuePair> pairList = new ArrayList<NameValuePair>();
        pairList.add(pair);
        HttpEntity requestHttpEntity;
        try {
			requestHttpEntity = new UrlEncodedFormEntity(pairList);
	        // URL使用基本URL即可，其中不需要加参数
	        HttpPost httpPost = new HttpPost(LOCATION_URL);
	        // 将请求体内容加入请求中
	        httpPost.setEntity(requestHttpEntity);
	        // 需要客户端对象来发送请求
	        HttpClient httpClient = new DefaultHttpClient();
	        // 发送请求
			HttpResponse response = httpClient.execute(httpPost);
			if (response.getStatusLine().getStatusCode() == 200){
				HttpEntity httpEntity = response.getEntity();
				InputStream in = httpEntity.getContent();
				BufferedReader br = new BufferedReader(new InputStreamReader(in));
				String result = "";
				String line = "";
				while(null != (line = br.readLine())){
					result += line;
				};
				JSONObject json = new JSONObject(result);
				JSONObject data = json.getJSONObject("data");
				HandMachine.getHandMachine().luaCallEvent("GetCityInfo", data.toString());
			}
		} catch (ClientProtocolException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
//	//省份代号
//	public static String getProvinceId(){
//		String saveLocation = AppActivity.dict_get_string(DICT_NAME,DICT_KEY_LOCATION);
//		if (saveLocation.equals("")){
//			return null;
//		}else{
//			try {
//				JSONObject json = new JSONObject(saveLocation);
//				JSONObject data = json.getJSONObject("data");
//				return data.getString("region_id");
//			} catch (JSONException e) {
//				// TODO Auto-generated catch block
//				e.printStackTrace();
//			}
//			return null;
//		}
//	}
//	//省份
//	public static String getProvinceName(){
//		String saveLocation = AppActivity.dict_get_string(DICT_NAME,DICT_KEY_LOCATION);
//		if (saveLocation.equals("")){
//			return null;
//		}else{
//			try {
//				JSONObject json = new JSONObject(saveLocation);
//				JSONObject data = json.getJSONObject("data");
//				return data.getString("region");
//			} catch (JSONException e) {
//				// TODO Auto-generated catch block
//				e.printStackTrace();
//			}
//			return null;
//		}
//	}
//	
//	//城市代号
//	public static String getCityId(){
//		String saveLocation = AppActivity.dict_get_string(DICT_NAME,DICT_KEY_LOCATION);
//		if (saveLocation.equals("")){
//			return null;
//		}else{
//			try {
//				JSONObject json = new JSONObject(saveLocation);
//				JSONObject data = json.getJSONObject("data");
//				return data.getString("city_id");
//			} catch (JSONException e) {
//				// TODO Auto-generated catch block
//				e.printStackTrace();
//			}
//			return null;
//		}
//	}
//	//城市
//	public static String getCityName(){
//		String saveLocation = AppActivity.dict_get_string(DICT_NAME,DICT_KEY_LOCATION);
//		if (saveLocation.equals("")){
//			return null;
//		}else{
//			try {
//				JSONObject json = new JSONObject(saveLocation);
//				JSONObject data = json.getJSONObject("data");
//				return data.getString("city");
//			} catch (JSONException e) {
//				// TODO Auto-generated catch block
//				e.printStackTrace();
//			}
//			return null;
//		}
//	}
//	
//	//外网ip
//	public static String getIPAddress(){
//		String saveLocation = AppActivity.dict_get_string(DICT_NAME,DICT_KEY_LOCATION);
//		if (saveLocation.equals("")){
//			return null;
//		}else{
//			try {
//				JSONObject json = new JSONObject(saveLocation);
//				JSONObject data = json.getJSONObject("data");
//				return data.getString("ip");
//			} catch (JSONException e) {
//				// TODO Auto-generated catch block
//				e.printStackTrace();
//			}
//			return null;
//		}
//	}
}
