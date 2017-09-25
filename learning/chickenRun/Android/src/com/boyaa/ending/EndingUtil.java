package com.boyaa.ending;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;
import android.content.SharedPreferences;
import android.util.Log;

import com.boyaa.chinesechess.chicken.Game;
import com.boyaa.ending.database.EndingAccountDBManager;
import com.boyaa.ending.database.EndingDBManager;
import com.boyaa.ending.model.EndingAccount;
import com.boyaa.ending.model.Entity;
import com.boyaa.ending.model.Gate;
import com.boyaa.ending.model.SubGate;
import com.boyaa.entity.core.HandMachine;

/**
 * 解析、读取、更新残局数据
 * 
 * 默认assets下的endgate.db有3大关和150小关数据，可用SQLite Developer打开。
 * 当触发残局更新以后（目前可更新到第五大关），从php拉取1到5关的数据（包括原来的3大关）存入endgate.db,再更新到客户端界面。
 */
public class EndingUtil {
	
	public static final String FLAG 				= "flag";
	public static final int FLAG_CODE 				= 10000; 
	public static final String VERSION 				= "version";
	public static final String DATA 				= "data";
	public static final String GATE 				= "gate";
	public static final String CHESSRECORD 			= "chessrecord";
	public static final String TID		 			= "tid";
	public static final String SORT 				= "sort";
	public static final String COUNT 				= "count";
	public static final String DEL	 				= "del";
	public static final String UID	 				= "uid";
	
	/**
	 * 保存版本
	 */
	
	public static void saveEndgateVersion(int version) {
		SharedPreferences preferences = Game.mActivity.getSharedPreferences("endgateVersion", Context.MODE_PRIVATE);
		preferences.edit().putInt("version", version).commit();
	}
		
	/**
	 * 获得版本
	 */
	
	public static int getEndgateVersion() {
		SharedPreferences preferences = Game.mActivity.getSharedPreferences("endgateVersion", Context.MODE_PRIVATE);
		return preferences.getInt("version", 0);
	}
	
	/**
	 * 解析并保存残局数据
	 * @param endGate_str
	 */
	public static void parseEndGate(final String endGate_str) {
		// TODO Auto-generated method stub
		new Thread(new Runnable() {
			
			@Override
			public void run() {
				// TODO Auto-generated method stub
				final JSONObject result = new JSONObject();
				int uid = -1;
				try {
					JSONObject ret = new JSONObject(endGate_str);
					uid = ret.getInt(UID);
					JSONObject root = ret.getJSONObject(DATA); 
					int flag = root.getInt(FLAG);
					if(flag == FLAG_CODE){
						
						result.put(VERSION, root.getInt(VERSION));//返回版本号
						saveEndgateVersion(root.getInt(VERSION));
						result.put(COUNT,0);
						
						ArrayList<Entity> gateList = new ArrayList<Entity>();
						JSONArray data = root.getJSONArray(DATA);
						for(int i=0;i<data.length();i++){
							JSONObject temp = data.getJSONObject(i);
							JSONObject gateJson = temp.getJSONObject(GATE);
							JSONArray gateArray = temp.getJSONArray(CHESSRECORD);
							
							Gate g = new Gate();
							g.tid = gateJson.getInt(TID);
							g.progress = 0;
							g.subCount = gateArray.length();
							g.str = gateJson.toString();
							gateList.add(g);
							
							for(int j=0;j<gateArray.length();j++){
								JSONObject chessData = gateArray.getJSONObject(j);
								SubGate sg = new SubGate();
								sg.tid = g.tid;
								sg.sort = chessData.getInt(SORT);
								sg.str = chessData.toString();
								
								gateList.add(sg);
							}
						}
						
						if(gateList.size() > 0){
							EndingDBManager.getInstance().insertOrUpdate(gateList);//插入到数据库
							loadEndGateFromDB(uid);     	//有新的数据返回，重新加载以展示最新数据
						}
					}
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				Game.mActivity.runOnLuaThread(new Runnable() {//只返回版本号
					@Override
					public void run() {
						HandMachine.getHandMachine().luaCallEvent(HandMachine.kParseEndGate, 
								(result.toString().equals("{}")) ? null : result.toString());
					}
				});
			}
		}).start();
	}
	
	/**
	 * 加载大关卡
	 */
	public static void loadEndGate(final int uid) {
		// TODO Auto-generated method stub
		new Thread(new Runnable() {
			
			@Override
			public void run() {
				// TODO Auto-generated method stub
				loadEndGateFromDB(uid);
			}
		}).start();
	}
	
	/**
	 * 从数据库读取
	 */
	private synchronized static void loadEndGateFromDB(int uid){
		JSONArray retJson = new JSONArray();
		EndingAccount ea = null;
		try{
			List<Gate> gateList = EndingDBManager.getInstance().findAllGate();
			for(Gate g : gateList){
				JSONObject temp = new JSONObject();
				temp.put("tid", g.tid);
				ea = EndingAccountDBManager.getInstance().findAccountByUidAndTid(uid, g.tid);
				if(ea == null){
					ea = new EndingAccount();
					ea.uid = uid;
					ea.tid = g.tid;
					EndingAccountDBManager.getInstance().insertOrUpdate(ea);
				}
				temp.put("isNeedPay", ea.isNeedPay);
				temp.put("progress", ea.progress);
				temp.put("subCount", g.subCount);
				temp.put("str", new JSONObject(g.str));
				retJson.put(temp);
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		int version = getEndgateVersion();
		JSONObject resultJson = new JSONObject();
		try {
			resultJson.put("gates", retJson);
			resultJson.put("version", version);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		final String result = resultJson.toString();
		Game.mActivity.runOnLuaThread(new Runnable() {
			@Override
			public void run() {
				Log.e("lua","LoadEndGate");
				HandMachine.getHandMachine().luaCallEvent(HandMachine.kLoadEndGate, 
						result);
			}
		});
	}
	
	/**
	 * 读取棋盘信息
	 * @param str
	 */
	public static void loadEndBoard(final String str) {
		// TODO Auto-generated method stub
		new Thread(new Runnable() {
		
			@Override
			public void run() {
				// TODO Auto-generated method stub
				String[] s = str.split(",");
				int tid = Integer.parseInt(s[0]);
				int sortId = Integer.parseInt(s[1]);	
			
				final SubGate sg = EndingDBManager.getInstance().findSubGateByTidAndSort(tid,sortId);
				
				Game.mActivity.runOnLuaThread(new Runnable() {
					@Override
					public void run() {
						HandMachine.getHandMachine().luaCallEvent(HandMachine.kLoadEndBoard, 
								sg == null ? null : sg.str);
					}
				});
			}
		}).start();
	}

	/**
	 * 更新大关卡数据
	 * @param gateStr
	 */
	public static void updateEndGate(final String gateStr) {
		// TODO Auto-generated method stub
		new Thread(new Runnable() {
			
			@Override
			public void run() {
				// TODO Auto-generated method stub
				try {
					Log.e("lua","updateEndGate:"+gateStr);
					JSONObject json = new JSONObject(gateStr);
					Gate gate = new Gate();
					gate.tid = json.getInt("tid");
					gate.isNeedPay = json.getInt("isNeedPay");
					gate.progress = json.getInt("progress");
					
					EndingAccount ea = new EndingAccount();
					ea.uid = json.getInt(UID);
					ea.tid = gate.tid;
					ea.isNeedPay = gate.isNeedPay;
					ea.progress = gate.progress;
					EndingAccountDBManager.getInstance().insertOrUpdate(ea);
					
					EndingDBManager.getInstance().updateGate(gate);
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}).start();
	}
	
	public static void EndGateReplace(final int uid){
		new Thread(new Runnable() {
			
			@Override
			public void run() {
				// TODO Auto-generated method stub
				List<EndingAccount> ealist = EndingAccountDBManager.getInstance().findEndingAccountByUid(uid);
				for(int i=0;i<ealist.size();i++){
					EndingAccount ea = ealist.get(i);
					if(i == 0 && ea.progress <= 5){
						ea.isNeedPay = 1;
						ea.progress = 6;
						EndingAccountDBManager.getInstance().insertOrUpdate(ea);
						
						final int tid = ea.tid;//尼玛
						Game.mActivity.runOnLuaThread(new Runnable() {
							@Override
							public void run() {
								HandMachine.getHandMachine().luaCallEvent(HandMachine.kEndGateReplace, 
										tid+"");
							}
						});
						break;
					}
					if(ea.isNeedPay == 0){
						ea.isNeedPay = 1;
						EndingAccountDBManager.getInstance().insertOrUpdate(ea);
						
						final int tid = ea.tid;
						Game.mActivity.runOnLuaThread(new Runnable() {
							@Override
							public void run() {
								HandMachine.getHandMachine().luaCallEvent(HandMachine.kEndGateReplace, 
										tid+"");
							}
						});
						break;
					}
				}
			}
		}).start();
	}
}
