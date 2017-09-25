package com.boyaa.proxy.share;

import android.graphics.BitmapFactory;
import android.os.Bundle;

import com.boyaa.chinesechess.chicken.wxapi.SendToWXUtil;
import com.boyaa.made.FileUtil;
import com.boyaa.proxy.share.ShareProxy.BaseShareCallback;
import com.boyaa.proxy.share.ShareProxy.BaseShareInterface;

public class ShareToPYQ implements BaseShareInterface{
	private int id = 0;
	public ShareToPYQ(int id) {
		this.id = id;
	}
	@Override
	public void share(Bundle bundle, BaseShareCallback baseShareCallback) {
		// TODO Auto-generated method stub
		String  path = FileUtil.getmStrImagesPath() + bundle.getString("icon");
		boolean isSuccess = SendToWXUtil.shareToPYQ1(
								bundle.getString("content"),
								bundle.getString("title"),
								bundle.getString("description"),
								BitmapFactory.decodeFile(path) );
		if(isSuccess) 
			baseShareCallback.success(this);
		else
			baseShareCallback.fail(this);
	}
	@Override
	public int getId() {
		// TODO Auto-generated method stub
		return id;
	}

}
