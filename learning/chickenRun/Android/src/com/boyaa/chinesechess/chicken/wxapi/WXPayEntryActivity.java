package com.boyaa.chinesechess.chicken.wxapi;


import com.boyaa.chinesechess.chicken.Game;
import com.boyaa.chinesechess.chicken.R;
import com.tencent.mm.sdk.constants.ConstantsAPI;
import com.tencent.mm.sdk.modelbase.BaseReq;
import com.tencent.mm.sdk.modelbase.BaseResp;
import com.tencent.mm.sdk.modelmsg.SendAuth;
import com.tencent.mm.sdk.openapi.IWXAPI;
import com.tencent.mm.sdk.openapi.IWXAPIEventHandler;
import com.tencent.mm.sdk.openapi.WXAPIFactory;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;

public class WXPayEntryActivity extends Activity implements IWXAPIEventHandler{
	
	private static final String TAG = "weixinPay";
	
    private IWXAPI api;// = SendToWXUtil.api;

	private int result;
	
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    	api = WXAPIFactory.createWXAPI(this, Constants.APP_ID);
        api.handleIntent(getIntent(), this);
    }

	@Override
	protected void onNewIntent(Intent intent) {
		super.onNewIntent(intent);
		setIntent(intent);
        api.handleIntent(intent, this);
	}

	@Override
	public void onReq(BaseReq req) {
	}

	@Override
	public void onResp(BaseResp resp) {
		Log.d(TAG, "onPayFinish, errCode = " + resp.errCode);

		if (resp.getType() == ConstantsAPI.COMMAND_PAY_BY_WX) {
			switch (resp.errCode) {
			case BaseResp.ErrCode.ERR_OK:
					result = R.string.pay_success;
				break;
			case BaseResp.ErrCode.ERR_USER_CANCEL:
					result = R.string.pay_cancel;
				break;
			case BaseResp.ErrCode.ERR_AUTH_DENIED:
					result = R.string.pay_deny;
				break;
			default:
					result = R.string.pay_unknown;
				break;
			}
			Toast.makeText(this, result, Toast.LENGTH_LONG).show();
			finish();
		}
	}
}