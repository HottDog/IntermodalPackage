package com.boyaa.chinesechess.chicken.wxapi;


import java.net.URI;

import org.apache.http.client.utils.URIUtils;

import com.boyaa.chinesechess.chicken.Game;
import com.boyaa.chinesechess.chicken.R;
import com.boyaa.entity.core.HandMachine;
import com.tencent.mm.sdk.constants.ConstantsAPI;
import com.tencent.mm.sdk.modelbase.BaseReq;
import com.tencent.mm.sdk.modelbase.BaseResp;
import com.tencent.mm.sdk.modelmsg.SendAuth;
import com.tencent.mm.sdk.openapi.IWXAPI;
import com.tencent.mm.sdk.openapi.IWXAPIEventHandler;
import com.tencent.mm.sdk.openapi.WXAPIFactory;


import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;

public class WXEntryActivity extends Activity implements IWXAPIEventHandler{
	public static Activity app;
    private IWXAPI api;
	
    @Override
    public void onCreate(Bundle savedInstanceState) {
    	api = WXAPIFactory.createWXAPI(this, Constants.APP_ID, false);
    	api.handleIntent(getIntent(), this);
    	app = this;
        super.onCreate(savedInstanceState);
    }

	@Override
	protected void onNewIntent(Intent intent) {
		super.onNewIntent(intent);
		
		setIntent(intent);
        api.handleIntent(intent, this);
	}

	@Override
	public void onReq(BaseReq req) {
		switch (req.getType()) {
		case ConstantsAPI.COMMAND_GETMESSAGE_FROM_WX:
			break;
		case ConstantsAPI.COMMAND_SHOWMESSAGE_FROM_WX:
			break;
		default:
			break;
		}
	}

	@Override
	public void onResp(BaseResp resp) {
		Log.e("weixinonResp",resp.errCode+"+"+resp.getType());
		int result = R.string.errcode_unknown;
		
		switch (resp.errCode) {
		case BaseResp.ErrCode.ERR_OK:
			if (ConstantsAPI.COMMAND_SENDMESSAGE_TO_WX == resp.getType()) {
				result = R.string.share_success;
				Game.mActivity.runOnLuaThread(new Runnable() {
					
					@Override
					public void run() {
						// TODO Auto-generated method stub
						HandMachine.getHandMachine().luaCallEvent(
								HandMachine.kShareSuccessCallBack, "");
					}
				});
			}else if(ConstantsAPI.COMMAND_SENDAUTH == resp.getType()) {
				result = R.string.login_success;
				String code = ((SendAuth.Resp) resp).code; //即为所需的code
				String uri = Constants.url.replace("CODE", code);
				Log.e("COMMAND_SENDAUTH",uri);
				WXHttpGet httpGet  = new WXHttpGet(uri);
				httpGet.Execute();			
			}
			break;
		case BaseResp.ErrCode.ERR_USER_CANCEL:
			if (ConstantsAPI.COMMAND_SENDMESSAGE_TO_WX == resp.getType()) {
				result = R.string.share_cancel;
			}else if(ConstantsAPI.COMMAND_SENDAUTH == resp.getType()) {
				result = R.string.login_cancel;
			}
			break;
		case BaseResp.ErrCode.ERR_AUTH_DENIED:
			if (ConstantsAPI.COMMAND_SENDMESSAGE_TO_WX == resp.getType()) {
				result = R.string.share_deny;
			}else if(ConstantsAPI.COMMAND_SENDAUTH == resp.getType()) {
				result = R.string.login_deny;
				
			}
			break;
		default:
			if (ConstantsAPI.COMMAND_SENDMESSAGE_TO_WX == resp.getType()) {
				result = R.string.share_unknown;
			}else if(ConstantsAPI.COMMAND_SENDAUTH == resp.getType()) {
				result = R.string.login_unknown;
			}
			
			break;
		}
		
		Toast.makeText(this, result, Toast.LENGTH_LONG).show();
		finish();
	}
}