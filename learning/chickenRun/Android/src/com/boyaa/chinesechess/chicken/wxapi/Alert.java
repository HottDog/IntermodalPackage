package com.boyaa.chinesechess.chicken.wxapi;

import java.util.ArrayList;
import java.util.List;

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
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.boyaa.chinesechess.chicken.Game;
import com.boyaa.chinesechess.chicken.R;
import com.boyaa.qqapi.SendToQQUtil;

public class Alert {
	/**
	 * @param context
	 *            Context.
	 * @param title
	 *            The title of this AlertDialog can be null .
	 * @param items
	 *            button name list.
	 * @param alertDo
	 *            methods call Id:Button + cancel_Button.
	 * @param exit
	 *            Name can be null.It will be Red Color
	 * @return A AlertDialog
	 */
	public static Dialog showAlert(final Context context,final String json,OnCancelListener cancelListener) {
		final Bundle bundle = new Bundle();
		int flag = 0;
		try {
			JSONObject jsonObject = new JSONObject(json);
			bundle.putString("url",jsonObject.optString("url"));
			bundle.putString("title",jsonObject.optString("title"));
			flag = jsonObject.getInt("flag");
			Log.e("share", bundle.toString());
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		}
		final Dialog dlg = new Dialog(context, R.style.MMTheme_DataSheet);
		LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		LinearLayout ll = (LinearLayout) inflater.inflate(R.layout.share_dialog_layout, null);
		final GridView grid = (GridView) ll.findViewById(R.id.share_content_grid);
		final Alert.AlertAdapter adapter = new Alert.AlertAdapter(context,flag);
		grid.setAdapter(adapter);

		grid.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
				AlertAdapter.ViewData data = (AlertAdapter.ViewData)adapter.getItem(position);
				
				data.alertItemClick.onClick(bundle);
				dlg.dismiss();
				grid.requestFocus();
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
		dlg.show();
		return dlg;
	}
	public interface onAlertItemClick {
		public void onClick(Bundle bundle);
	}
	static class AlertAdapter extends BaseAdapter {
		private static final String TAG = "AlertAdapter";
		private List<ViewData> items;
		private Context context;

		public AlertAdapter(Context context,int flag) {
			this.context = context;
			this.items = new ArrayList<AlertAdapter.ViewData>();
			if ( flag != 0 ) {
			items.add(new ViewData(R.drawable.share_wechat,"微信",new SendToWXUtil.SendWebPageToWX()));
			items.add(new ViewData(R.drawable.share_pyq,"朋友圈",new SendToWXUtil.SendWebPageToPYQ()));
			items.add(new ViewData(R.drawable.share_qq,"QQ",new SendToQQUtil.SendWebPageToQQ()));
			}
//			for(int i = 1;i<10;i++)
			items.add(new ViewData(R.drawable.share_other,"其他",new SendToWXUtil.SendOther()));
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
			final ViewData data = (ViewData) getItem(position);
			ViewHolder holder;
			if (convertView == null || convertView.getTag() == null) {
				holder = new ViewHolder();
				convertView = View.inflate(context, R.layout.share_dialog_layout_item, null);
				holder.view = (LinearLayout) convertView.findViewById(R.id.share_layout_item);
				holder.img = (ImageView) convertView.findViewById(R.id.share_item_icon);
				holder.title = (TextView) convertView.findViewById(R.id.share_title);
				convertView.setTag(holder);
			} else {
				holder = (ViewHolder) convertView.getTag();
			}

			holder.img.setImageResource(data.img);
			holder.title.setText(data.title);
			return convertView;
		}

		class ViewHolder {
			LinearLayout view;
			ImageView img;
			TextView title;
		}
		final class ViewData {
			int img;
			String title;
			onAlertItemClick alertItemClick; 
			public ViewData(int img,String title,onAlertItemClick alertItemClick) {
				// TODO Auto-generated constructor stub
				this.img = img;
				this.title = title;
				this.alertItemClick = alertItemClick;
			}
		}
		
	}
}
