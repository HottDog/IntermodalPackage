package com.boyaa.chinesechess.chicken;


import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.KeyEvent;
import android.view.Window;
import android.webkit.CookieManager;
import android.webkit.CookieSyncManager;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import com.boyaa.chinesechess.chicken.R;
import com.boyaa.snslogin.SinaMethod;

public class SinaAuthActivity extends Activity {
	private WebView webView = null;
	private WebViewHandler handler = null;
	private String verifier = null;
	private String access_token = "access_token=";
	private String expires_in = "expires_in=";
	private String uid = "uid=";


	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		requestWindowFeature(Window.FEATURE_PROGRESS);
		setContentView(R.layout.auth_activity);
		setTitle(getString(R.string.weibo));
		init();
		getRequestUrlTask();
	}

	private void getRequestUrlTask(){
		new Thread(){
			{setDaemon(true);}
			public void run() {
				try {
					Message msg = handler.obtainMessage(2, getRequestUrl());
					handler.sendMessage(msg);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}.start();
	}
	
	@Override
	protected void onStart() {
		super.onStart();
		if(webView != null){
			webView.clearHistory();
			webView.clearFormData();
		}
	}
	
	private String getRequestUrl() {
		StringBuffer sb = new StringBuffer();
		sb.append("https://api.weibo.com/oauth2/authorize?display=mobile&client_id=");
		sb.append(SinaMethod.kAppKey);
		sb.append("&response_type=token");
		sb.append("&redirect_uri=");
		sb.append(SinaMethod.kAppRedirectURI);
		return sb.toString();
	}

	public void init() {
		webView = (WebView) findViewById(R.id.webview);
		webView.getSettings().setJavaScriptEnabled(true);
		webView.getSettings().setJavaScriptCanOpenWindowsAutomatically(true);
		webView.getSettings().setCacheMode(WebSettings.LOAD_NO_CACHE);
		webView.setScrollBarStyle(0);
		CookieSyncManager.createInstance(this);    
		CookieSyncManager.getInstance().startSync();    
		CookieManager.getInstance().removeSessionCookie();  
		  
		webView.clearCache(true);    
		webView.clearHistory();  

		handler = new WebViewHandler();
		webView.setWebViewClient(new WebViewClient() {
			@Override
			public boolean shouldOverrideUrlLoading(final WebView view,
					final String url) {
				loadurl(view, url);
				return true;
			}

			@Override
			public void onPageStarted(WebView view, String url, Bitmap favicon) {
				super.onPageStarted(view, url, favicon);
				verifier= url;
	    		if (verifier != null && !"".equals(verifier)) {
	    			if(verifier.contains(access_token)){
						int start = verifier.indexOf(access_token) + access_token.length();
						int end = verifier.indexOf("&", start);
						String access_token = null;
						if (start!=-1 && end!=-1) {
							access_token = verifier.substring(start, end);
						}else if(start!=-1){
							access_token = verifier.substring(start);
						}
						
						start = verifier.indexOf(expires_in) + expires_in.length();
						end = verifier.indexOf("&", start);
						String expires_in=null;
						if (start!=-1 && end!=-1) {
							 expires_in = verifier.substring(start, end);
						}else if(start!=-1){
							 expires_in = verifier.substring(start);
						}
						
						start = verifier.indexOf(uid) + uid.length();
						end = verifier.indexOf("&", start);
						String uid=null;
						if (start!=-1 && end!=-1) {
							uid = verifier.substring(start, end);
						}else if(start!=-1){
							uid = verifier.substring(start);
						}

						
						Intent intent = new Intent();
						intent.setAction(SinaMethod.WEIBO_AUTH_ACTION);
						intent.putExtra("access_token", access_token);
						intent.putExtra("expires_in", expires_in);
						intent.putExtra("uid", uid);
						
						sendBroadcast(intent);
					
						SinaAuthActivity.this.finish();
	    			}
	    		}
			}
			
			@Override
			public void onPageFinished(WebView view, String url) {
				super.onPageFinished(view, url);
			}


		});
		webView.setWebChromeClient(new WebChromeClient() {
			@Override
			public void onProgressChanged(WebView view, int progress) {
				super.onProgressChanged(view, progress);
				if (progress == 100) {
					handler.sendEmptyMessage(1);
				}
				setProgress(progress * 100);
			}
		});
	}


	class WebViewHandler extends Handler {

		@Override
		public void handleMessage(Message msg) {
			if (!Thread.currentThread().isInterrupted()) {
				switch (msg.what) {
				case 0:
					SinaAuthActivity.this.setProgressBarVisibility(true);
					webView.loadUrl((String) msg.obj);
					break;
				case 1:
					SinaAuthActivity.this.setProgressBarVisibility(false);
					break;
				case 2:
					loadurl(webView, (String)msg.obj);
					break;
				}
			}
			super.handleMessage(msg);
		}
	}
	
	public void loadurl(final WebView view, final String url) {
		new Thread() {
			@Override
			public void run() {
				handler.sendMessage(handler.obtainMessage(0, url));
			}
		}.start();
	}

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if (keyCode == KeyEvent.ACTION_DOWN) {
			SinaAuthActivity.this.finish();
		}
		return super.onKeyDown(keyCode, event);
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
	}
}
