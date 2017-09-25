package com.boyaa.qqapi;

import android.widget.Toast;

import com.boyaa.chinesechess.chicken.Game;
import com.boyaa.entity.common.Log;
import com.tencent.tauth.IUiListener;
import com.tencent.tauth.UiError;

public class QQUIListener implements IUiListener  {
	
	private final static int toastTime = 10000;
	
	public void doComplete(Object response) {
		
	}
	
	@Override
	public void onCancel() {
		// TODO Auto-generated method stub
		Log.e("onCancel", "取消QQ分享");
		String str = "分享取消";
		Toast.makeText(Game.mActivity, str, toastTime).show();
	}

	@Override
	public void onComplete(Object response) {
		// TODO Auto-generated method stub
		String str = "分享成功";
		Toast.makeText(Game.mActivity, str, toastTime).show();
		doComplete(response);
	}

	@Override
	public void onError(UiError e) {
		// TODO Auto-generated method stub
		Log.e("onError:", "code:" + e.errorCode + ", msg:"
				+ e.errorMessage + ", detail:" + e.errorDetail);
		String str = "分享失败";
		Toast.makeText(Game.mActivity, str, toastTime).show();
	}
	
}
