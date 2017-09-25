match_dialog_view=
{
	name="match_dialog_view",type=0,typeName="View",time=0,x=0,y=0,width=720,height=1280,visible=1,fillParentWidth=1,fillParentHeight=1,nodeAlign=kAlignTopLeft,
	{
		name="bg_blank",type=1,typeName="Image",time=98437451,x=0,y=0,width=720,height=1280,visible=1,fillParentWidth=1,fillParentHeight=1,nodeAlign=kAlignCenter,file="drawable/blank_black.png"
	},
	{
		name="anim_view",type=0,typeName="View",time=95911950,x=0,y=-183,width=150,height=150,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,
		{
			name="anim_1",type=1,typeName="Image",time=95911865,x=0,y=0,width=150,height=150,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="online/room/dialog/match_anim.png"
		},
		{
			name="anim_2",type=1,typeName="Image",time=95911868,x=0,y=0,width=150,height=150,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="online/room/dialog/match_anim.png"
		},
		{
			name="anim_3",type=1,typeName="Image",time=95911871,x=0,y=0,width=150,height=150,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="online/room/dialog/match_anim.png"
		}
	},
	{
		name="head_bg",type=1,typeName="Image",time=95911376,x=0,y=-183,width=150,height=150,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="online/room/dialog/head_bg_150.png",
		{
			name="head_btn",type=2,typeName="Button",time=108629929,x=0,y=0,width=170,height=170,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="drawable/blank.png"
		},
		{
			name="head_mask",type=1,typeName="Image",time=95911429,x=0,y=0,width=145,height=145,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="online/room/dialog/head_mask_bg_144.png"
		},
		{
			name="vip_frame",type=1,typeName="Image",time=105782358,x=0,y=0,width=150,height=150,visible=0,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="vip/vip_150.png"
		},
		{
			name="level",type=1,typeName="Image",time=95911464,x=0,y=-10,width=52,height=26,visible=0,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignBottom,file="common/icon/level_1.png"
		}
	},
	{
		name="search_img",type=1,typeName="Image",time=95911497,x=0,y=14,width=408,height=54,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="online/room/dialog/match_text.png"
	},
	{
		name="btn1",type=2,typeName="Button",time=95911537,x=0,y=187,width=571,height=97,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="common/button/dialog_btn_6_normal.png",file2="common/button/dialog_btn_6_press.png",gridLeft=87,gridRight=87,gridTop=0,gridBottom=0,
		{
			name="Text1",type=4,typeName="Text",time=95911657,x=0,y=-2,width=80,height=40,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,fontSize=38,textAlign=kAlignLeft,colorRed=255,colorGreen=255,colorBlue=255,string=[[退出房间]]
		}
	},
	{
		name="search_fail",type=1,typeName="Image",time=104408424,x=0,y=14,width=227,height=51,visible=0,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="online/room/dialog/match_fail.png"
	},
	{
		name="search_success",type=1,typeName="Image",time=104408637,x=0,y=13,width=201,height=49,visible=0,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="online/room/dialog/match_success.png"
	},
	{
		name="btn2",type=2,typeName="Button",time=104408912,x=0,y=309,width=571,height=97,visible=0,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="common/button/dialog_btn_2_normal.png",file2="common/button/dialog_btn_2_press.png",
		{
			name="Text1",type=4,typeName="Text",time=104408967,x=0,y=0,width=200,height=150,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,fontSize=38,textAlign=kAlignCenter,colorRed=255,colorGreen=255,colorBlue=255,string=[[重新匹配]]
		}
	},
	{
		name="userinfo_view",type=0,typeName="View",time=108620762,x=0,y=-237,width=631,height=571,visible=0,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,
		{
			name="userinfo_bg",type=1,typeName="Image",time=108627740,x=0,y=74,width=646,height=515,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTop,file="common/background/dialog_bg_2.png",gridLeft=128,gridRight=128,gridTop=128,gridBottom=128
		},
		{
			name="opp_user_icon_bg",type=1,typeName="Image",time=108627998,x=0,y=6,width=150,height=150,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTop,file="common/background/head_bg_160.png",
			{
				name="opp_user_icon_mask",type=1,typeName="Image",time=108629167,x=0,y=0,width=144,height=144,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="common/background/head_mask_bg_150.png"
			},
			{
				name="vip_frame",type=1,typeName="Image",time=108629213,x=0,y=0,width=150,height=150,visible=0,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="vip/vip_150.png"
			}
		},
		{
			name="opp_user_name",type=4,typeName="Text",time=108628004,x=0,y=119,width=265,height=130,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTop,fontSize=36,textAlign=kAlignCenter,colorRed=80,colorGreen=80,colorBlue=80,string=[[博雅象棋]]
		},
		{
			name="info_bg_line",type=1,typeName="Image",time=108628099,x=0,y=236,width=562,height=221,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTop,file="common/background/line_bg.png",gridLeft=64,gridRight=64,gridTop=64,gridBottom=64
		},
		{
			name="sex",type=4,typeName="Text",time=108628322,x=53,y=260,width=96,height=33,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,fontSize=32,textAlign=kAlignLeft,colorRed=135,colorGreen=100,colorBlue=95,string=[[性别：]]
		},
		{
			name="opp_user_sex",type=4,typeName="Text",time=108628416,x=144,y=263,width=110,height=28,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,fontSize=28,textAlign=kAlignLeft,colorRed=80,colorGreen=80,colorBlue=80,string=[[保密]]
		},
		{
			name="rank",type=4,typeName="Text",time=108628490,x=333,y=260,width=96,height=33,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,fontSize=32,textAlign=kAlignLeft,colorRed=135,colorGreen=100,colorBlue=90,string=[[排名：]]
		},
		{
			name="opp_user_rank",type=4,typeName="Text",time=108628559,x=423,y=263,width=150,height=28,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,fontSize=28,textAlign=kAlignLeft,colorRed=80,colorGreen=80,colorBlue=80,string=[[未上榜]]
		},
		{
			name="title",type=4,typeName="Text",time=108628641,x=52,y=326,width=96,height=33,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,fontSize=32,textAlign=kAlignLeft,colorRed=135,colorGreen=100,colorBlue=90,string=[[棋力：]]
		},
		{
			name="opp_user_title",type=4,typeName="Text",time=108628721,x=148,y=329,width=360,height=28,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,fontSize=28,textAlign=kAlignLeft,colorRed=80,colorGreen=80,colorBlue=80,string=[[九级棋士(1000积分)]]
		},
		{
			name="rate",type=4,typeName="Text",time=108628839,x=54,y=387,width=96,height=33,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,fontSize=32,textAlign=kAlignLeft,colorRed=135,colorGreen=100,colorBlue=90,string=[[胜率：]]
		},
		{
			name="opp_user_rate",type=4,typeName="Text",time=108628890,x=148,y=390,width=390,height=30,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,fontSize=28,textAlign=kAlignLeft,colorRed=80,colorGreen=80,colorBlue=80,string=[[无]]
		},
		{
			name="follow_btn",type=2,typeName="Button",time=108633566,x=0,y=17,width=174,height=85,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignBottom,file="common/button/dialog_btn_1.png",file2="common/button/dialog_btn_1_press.png",gridLeft=64,gridRight=64,gridTop=29,gridBottom=29,
			{
				name="text",type=4,typeName="Text",time=108633662,x=0,y=0,width=200,height=150,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,fontSize=32,textAlign=kAlignCenter,colorRed=240,colorGreen=230,colorBlue=210,string=[[关注]]
			}
		},
		{
			name="opp_user_id",type=4,typeName="Text",time=111741542,x=0,y=187,width=200,height=60,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTop,fontSize=26,textAlign=kAlignCenter,colorRed=80,colorGreen=80,colorBlue=80,string=[[ID：]]
		}
	},
	{
		name="tip_bg",type=1,typeName="Image",time=108629601,x=-1,y=-293,width=404,height=94,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="common/background/tip_bg_2.png",gridLeft=80,gridRight=48,gridTop=45,gridBottom=45,
		{
			name="tip_text",type=4,typeName="Text",time=108629637,x=0,y=-8,width=352,height=81,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,fontSize=32,textAlign=kAlignCenter,colorRed=135,colorGreen=100,colorBlue=90,string=[[点击头像可查看对手详情]]
		}
	}
}