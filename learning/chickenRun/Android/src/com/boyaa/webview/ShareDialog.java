package com.boyaa.webview;

import java.util.ArrayList;
import java.util.List;
import java.util.TreeMap;

import org.json.JSONException;
import org.json.JSONObject;

import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface.OnCancelListener;
import android.os.Bundle;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.boyaa.chinesechess.chicken.Game;
import com.boyaa.chinesechess.chicken.R;
import com.boyaa.chinesechess.chicken.wxapi.Alert.onAlertItemClick;
import com.boyaa.chinesechess.chicken.wxapi.SendToWXUtil;
import com.boyaa.entity.common.utils.JsonUtil;
import com.boyaa.entity.core.HandMachine;
import com.boyaa.made.AppActivity;
import com.boyaa.qqapi.SendToQQUtil;

public class ShareDialog {

	private static ShareDialog instance = null;
	private static Button mButton;
	private static Button mButton_close;
	private static EditText mQiPuName;
	private static CheckBox mCheckBox;
	private static ShareAdapter shareDialogAdapter;
	private static Dialog dlg;
	private static ShareAdapter adapter;
	private static GridView grid;
	private static LinearLayout titleLayout;
	private static int manual_type;
	private static ImageView mManualTypeView;
	
	private static ShareDialog getInstance(){
		if (instance == null){
			instance = new ShareDialog();
		}
		return instance;
	}
	
	public static Dialog showDialog(final Context context,String json,boolean isNative,OnCancelListener cancelListener) {
		final Bundle bundle = new Bundle();
		try {
			JSONObject jsonObject = new JSONObject(json);
			bundle.putString("manual_type",jsonObject.getString("manual_type"));
			bundle.putString("red_mid",jsonObject.getString("red_mid"));
			bundle.putString("black_mid",jsonObject.getString("black_mid"));
			bundle.putString("win_flag",jsonObject.getString("win_flag"));
			bundle.putString("end_type",jsonObject.getString("end_type"));
			bundle.putString("start_fen",jsonObject.getString("start_fen"));
			bundle.putString("move_list",jsonObject.getString("move_list"));
			bundle.putString("manual_id",jsonObject.getString("manual_id"));
			bundle.putString("mid",jsonObject.getString("mid"));
			// eg.http://192.168.100.153/chess/h5/?method=H5ChessManual.getOneManual&manual_id=7
			String url = jsonObject.getString("h5_developUrl") + "view/replay/replay.php?manual_id="+jsonObject.getString("manual_id");
			bundle.putString("url",url);
			Log.e("ShareDialog", bundle.toString());
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		}
		dlg = new Dialog(context, R.style.MMTheme_DataSheet);
		LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		LinearLayout ll = (LinearLayout) inflater.inflate(R.layout.share_dialog_layout, null);
		titleLayout = (LinearLayout) ll.findViewById(R.id.content_title);
		if(!isNative){
			titleLayout.setVisibility(View.GONE);
		}
		
		mManualTypeView = (ImageView)ll.findViewById(R.id.room_type); 
		grid = (GridView) ll.findViewById(R.id.share_content_grid);
		adapter = new ShareDialog.ShareAdapter(context,isNative);
		grid.setAdapter(adapter);
		grid.setOnItemClickListener(new OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
				//item点击--->回lua上报php--->php返回url--->返回Android--->onResponseItemClick继续响应点击事件。
				ShareAdapter.ShareViewData data = (ShareAdapter.ShareViewData)adapter.getItem(position);
				clossInput(context);
				if (data.type == 1){//博雅棋友
//					bundle.putString("qipuName",editString);
//					data.alertItemClick.onClick(bundle);
//					dlg.dismiss();
//					grid.requestFocus();
				}else if (data.type == 2){//朋友圈
					TreeMap<String, Object> map = new TreeMap<String, Object>();
					map.put("itemPosition",position);
					map.put("manual_type", bundle.getString("manual_type"));
					map.put("red_mid", bundle.getString("red_mid"));
					map.put("black_mid", bundle.getString("black_mid"));
					map.put("win_flag", bundle.getString("win_flag"));
					map.put("end_type", bundle.getString("end_type"));
					map.put("start_fen", bundle.getString("start_fen"));
					map.put("move_list", bundle.getString("move_list"));
					map.put("manual_id", bundle.getString("manual_id"));
					map.put("mid", bundle.getString("mid"));
					// 上报php分享统计
					JsonUtil json = new JsonUtil(map);
					final String str = json.toString();
					Game.mActivity.runOnLuaThread(new Runnable() {
						@Override
						public void run() {
							HandMachine.getHandMachine().luaCallEvent("UpLoadLog", str);
						}
					});
					data.alertItemClick.onClick(bundle);
				}else if(data.type == 3){//微信
					TreeMap<String, Object> map = new TreeMap<String, Object>();
					map.put("itemPosition",position);
					map.put("manual_type", bundle.getString("manual_type"));
					map.put("red_mid", bundle.getString("red_mid"));
					map.put("black_mid", bundle.getString("black_mid"));
					map.put("win_flag", bundle.getString("win_flag"));
					map.put("end_type", bundle.getString("end_type"));
					map.put("start_fen", bundle.getString("start_fen"));
					map.put("move_list", bundle.getString("move_list"));
					map.put("manual_id", bundle.getString("manual_id"));
					map.put("mid", bundle.getString("mid"));
					// 上报php分享统计
					JsonUtil json = new JsonUtil(map);
					final String str = json.toString();
					Game.mActivity.runOnLuaThread(new Runnable() {
						@Override
						public void run() {
							HandMachine.getHandMachine().luaCallEvent("UpLoadLog", str);
						}
					});
					data.alertItemClick.onClick(bundle);
				}else if (data.type == 5){//复制链接
					data.alertItemClick.onClick(bundle);
					dlg.dismiss();
				}else if (data.type == 7){//QQ分享
					TreeMap<String, Object> map = new TreeMap<String, Object>();
					map.put("itemPosition",position);
					map.put("manual_type", bundle.getString("manual_type"));
					map.put("red_mid", bundle.getString("red_mid"));
					map.put("black_mid", bundle.getString("black_mid"));
					map.put("win_flag", bundle.getString("win_flag"));
					map.put("end_type", bundle.getString("end_type"));
					map.put("start_fen", bundle.getString("start_fen"));
					map.put("move_list", bundle.getString("move_list"));
					map.put("manual_id", bundle.getString("manual_id"));
					map.put("mid", bundle.getString("mid"));
					// 上报php分享统计
					JsonUtil json = new JsonUtil(map);
					final String str = json.toString();
					Game.mActivity.runOnLuaThread(new Runnable() {
						@Override
						public void run() {
							HandMachine.getHandMachine().luaCallEvent("UpLoadLog", str);
							
						}
					});
					data.alertItemClick.onClick(bundle);
				}
			}
		});

		// set a large value put it in bottom
		dlg.setContentView(ll);
		Window w = dlg.getWindow();
		WindowManager.LayoutParams lp = w.getAttributes();
		lp.x = 0;
		lp.gravity = Gravity.BOTTOM;
		lp.width = Game.mActivity.mWidth;
		dlg.onWindowAttributesChanged(lp);
		dlg.setCanceledOnTouchOutside(true);
		if (cancelListener != null) {
			dlg.setOnCancelListener(cancelListener);
		}
//		dlg.show();
		return dlg;

	}
	
	public static void onResponseItemClick(String jsonString) {
		int position = 0;
		String title = "";
		String url = "";
		try {
			JSONObject jsonObject = new JSONObject(jsonString);
			position = jsonObject.getInt("itemPosition");
			url = jsonObject.getString("url");
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		Bundle bundle = new Bundle();
		ShareAdapter.ShareViewData data = (ShareAdapter.ShareViewData)adapter.getItem(position);
		bundle.putString("title",title);
		bundle.putString("url",url);
		data.alertItemClick.onClick(bundle);
		dlg.dismiss();
	}
	
	public static void onResponseGetUrlFail() {
		dlg.dismiss();
		Toast.makeText(AppActivity.mActivity, "获取分享数据失败，请重新分享", Toast.LENGTH_LONG).show();
	}
	
	public static void clossInput(Context context){
//		InputMethodManager im = (InputMethodManager)context.getSystemService(Context.INPUT_METHOD_SERVICE); 
// 	   	im.hideSoftInputFromWindow(mQiPuName.getWindowToken(), InputMethodManager.HIDE_NOT_ALWAYS);
	}
	
	static class ShareAdapter extends BaseAdapter {
		private static final String TAG = "ShareAdapter";
		private List<ShareViewData> items;
		private Context context;

		public ShareAdapter(Context context, boolean isNative) {
			this.context = context;
			this.items = new ArrayList<ShareAdapter.ShareViewData>();
			items.add(new ShareViewData(R.drawable.share_pyq,R.string.share_pyq,new SendToWXUtil.SendFPWebPageToPYQ(),2));
			items.add(new ShareViewData(R.drawable.share_wechat,R.string.share_wechat,new SendToWXUtil.SendFPWebPageToWX(),3));
			items.add(new ShareViewData(R.drawable.copy_url,R.string.copy_url,new SendToWXUtil.CopyUrl(),5));
			items.add(new ShareViewData(R.drawable.share_qq,R.string.share_qq,new SendToQQUtil.SendFPWebPageToQQ(), 7));
		}

		@Override
		public int getCount() {
			return items.size();
		}

		@Override
		public Object getItem(int position) {
			return items.get(position);
		}
		
		@Override
		public long getItemId(int position) {
			// TODO Auto-generated method stub
			return 0;
		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			final ShareViewData data = (ShareViewData) getItem(position);
			ViewHolder holder;
			if (convertView == null || convertView.getTag() == null) {
				holder = new ViewHolder();
				convertView = View.inflate(context, R.layout.share_dialog_layout_item, null);
				holder.view = (LinearLayout) convertView.findViewById(R.id.share_layout_item);
				holder.img = (ImageView) convertView.findViewById(R.id.share_item_icon);
				holder.txt = (TextView)convertView.findViewById(R.id.share_title);
				convertView.setTag(holder);
			} else {
				holder = (ViewHolder) convertView.getTag();
			}

			holder.img.setImageResource(data.img);
			holder.txt.setText(data.txt);
			return convertView;
		}

		class ViewHolder {
			LinearLayout view;
			ImageView img;
			TextView txt;
		}
		final class ShareViewData {
			int img;
			onAlertItemClick alertItemClick; 
			int type;
			int txt;
			public ShareViewData(int img,int txtId,onAlertItemClick alertItemClick,int type) {
				// TODO Auto-generated constructor stub
				this.img = img;
				this.txt = txtId;
				this.alertItemClick = alertItemClick;
				this.type = type;
			}
		}
		
	}
	
	
}
