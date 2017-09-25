package com.boyaa.proxy.share;

import android.widget.Toast;

import com.boyaa.chinesechess.chicken.Game;
import com.boyaa.chinesechess.chicken.wxapi.SendToWXUtil;
import com.boyaa.entity.core.HandMachine;
import com.boyaa.qqapi.SendToQQUtil;
import com.boyaa.share.NativeShare;
import com.boyaa.until.Util;

public class ShareManager {
	private static final int TYPE_PYQ 			= 1;
	private static final int TYPE_WEICHAT 		= 2;
	private static final int TYPE_QQ 			= 3;
	private static final int TYPE_SMS 			= 4;
	private static final int TYPE_WEIBO 		= 5;
	private static final int TYPE_OTHER 		= 6;
	private static final int TYPE_IMG 	    	= 7;
	
	
	public static void share(int type){
		System.out.println("LuaEvent.ShareImgMsg");
		String line = HandMachine.getHandMachine().getParm(HandMachine.kShareTextMsg);
		String line1 = HandMachine.getHandMachine().getParm(HandMachine.kShareImgMsg);
		distributeShare(line,line1,type);
	}

	private static void distributeShare(String data, String imgData,int type) {

		switch(type){
		case TYPE_PYQ: 
			SendToWXUtil.shareToPYQ(data,"");
			break;
		case TYPE_WEICHAT: 
			SendToWXUtil.shareToWECHAT(data,"");
			break;
		case TYPE_QQ: 
			SendToQQUtil.shareToQQ(data,"");
			break;
		case TYPE_WEIBO: 
			NativeShare.shareTextToWeiBo(data);
			break;
		case TYPE_SMS: 
			if (Util.checkoutSimCard()){
				NativeShare.shareTextToSMS(data);
			}
			break;
		case TYPE_OTHER: 
			shareImg(imgData);
			break;
		case TYPE_IMG:
			shareImg(imgData);
			break;
		default:
			Game.mActivity.runOnUiThread(new Runnable() {
				@Override
				public void run() {
					// TODO Auto-generated method stub
					Toast.makeText(Game.mActivity, "分享失败", Toast.LENGTH_LONG).show();
				}
			});
			break;
		}
	}
	
	private static void shareImg(String info) {
		String[] str = info.split(",");

		if (str.length > 1) {
			// Weixin.shareWXImg(str[0],str[1],str[2]);
		} else {
			NativeShare.takeShot(info);
			NativeShare.shareImg(info);
		}
	}
	
}
