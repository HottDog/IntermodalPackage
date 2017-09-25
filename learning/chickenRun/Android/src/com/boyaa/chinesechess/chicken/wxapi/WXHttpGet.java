package com.boyaa.chinesechess.chicken.wxapi;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.json.JSONException;
import org.json.JSONObject;

import com.boyaa.chinesechess.chicken.Game;
import com.boyaa.entity.core.HandMachine;

public class WXHttpGet extends HttpGet implements Runnable{
	
	public WXHttpGet(String uri) {
		// TODO Auto-generated constructor stub
		super(uri);
	}
	
	public void Execute() {
		new Thread(this).start();
	}
	
	@Override
	public void run() {
		// TODO Auto-generated method stub
		HttpClient httpClient = new DefaultHttpClient();
		try {
			HttpResponse httpResponse = httpClient.execute(this);
			int code = httpResponse.getStatusLine().getStatusCode();
			switch(code) {
				case HttpURLConnection.HTTP_OK :
				{
					HttpEntity httpEntity = httpResponse.getEntity();
					InputStream inputStream = httpEntity.getContent();
					BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(inputStream));
					String str = "";
					StringBuffer buffer = new StringBuffer();
					while((str=bufferedReader.readLine())!=null) {
						buffer.append(str);
					}
					inputStream.close();
					String json = buffer.toString();
					sendToLua(json);
				}
				break;
				default :
				{
					sendToLua(null);
				}
				break;
			}
		} catch (ClientProtocolException e) {
			// TODO Auto-generated catch block
			sendToLua(null);
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			sendToLua(null);
			e.printStackTrace();
		}
	}
	public void sendToLua(final String json) {
		Game.mActivity.runOnLuaThread(new Runnable() {
			
			@Override
			public void run() {
				// TODO Auto-generated method stub
				HandMachine.getHandMachine().luaCallEvent("loginWeChat" , json);
			}
		});
	}
}
