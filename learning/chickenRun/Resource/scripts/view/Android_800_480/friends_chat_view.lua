friends_chat_view=
{
	name="friends_chat_view",type=0,typeName="View",time=0,x=0,y=0,width=0,height=0,visible=1,fillParentWidth=1,fillParentHeight=1,nodeAlign=kAlignTopLeft,
	{
		name="bg",type=1,typeName="Image",time=86854386,x=0,y=13,width=0,height=0,visible=1,fillParentWidth=1,fillParentHeight=1,nodeAlign=kAlignTopLeft,file="friends/friends_chat_bg.png"
	},
	{
		name="tittle_view",type=0,typeName="View",time=86855429,x=0,y=0,width=480,height=100,visible=1,fillParentWidth=1,fillParentHeight=0,nodeAlign=kAlignTopLeft,
		{
			name="tittle_bg",type=1,typeName="Image",time=86858261,x=0,y=0,width=480,height=95,visible=1,fillParentWidth=1,fillParentHeight=0,nodeAlign=kAlignTopLeft,file="common/activity_center_top_title_bg.png",
			{
				name="back",type=2,typeName="Button",time=86858636,x=0,y=0,width=62,height=62,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,file="common/ending_back.png"
			},
			{
				name="check",type=2,typeName="Button",time=86859371,x=3,y=8,width=54,height=58,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopRight,file="common/tittle_right_btn.png",
				{
					name="send_tips",type=1,typeName="Image",time=86859466,x=0,y=-1,width=44,height=25,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="friends/friend_check.png"
				}
			},
			{
				name="tittle",type=1,typeName="Image",time=86859640,x=0,y=0,width=372,height=65,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTop,file="common/ending_bg.png",
				{
					name="friendName",type=4,typeName="Text",time=87033657,x=0,y=4,width=200,height=50,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTop,fontSize=32,textAlign=kAlignCenter,colorRed=250,colorGreen=230,colorBlue=180,string=[[雄霸天]]
				}
			}
		}
	},
	{
		name="content_view",type=0,typeName="View",time=86855366,x=0,y=68,width=480,height=633,visible=1,fillParentWidth=1,fillParentHeight=0,nodeAlign=kAlignTopLeft
	},
	{
		name="load_view",type=0,typeName="View",time=87028632,x=0,y=68,width=480,height=50,visible=1,fillParentWidth=1,fillParentHeight=0,nodeAlign=kAlignTopLeft
	},
	{
		name="bottom_view",type=0,typeName="View",time=87033967,x=0,y=0,width=480,height=115,visible=1,fillParentWidth=1,fillParentHeight=0,nodeAlign=kAlignBottom,
		{
			name="bottom_bg",type=1,typeName="Image",time=87034025,x=0,y=0,width=480,height=115,visible=1,fillParentWidth=1,fillParentHeight=0,nodeAlign=kAlignBottom,file="friends/friend_chat_bottom.png"
		},
		{
			name="chat_bg",type=1,typeName="Image",time=87034401,x=-50,y=40,width=370,height=60,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTop,file="friends/friend_chat_send_bg.png",gridLeft=10,gridRight=10,gridTop=10,gridBottom=10,
			{
				name="chat_msg",type=7,typeName="EditTextView",time=87034499,x=15,y=6,width=341,height=48,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,fontSize=24,textAlign=kAlignLeft,colorRed=120,colorGreen=120,colorBlue=120,string=[[]]
			},
			{
				name="send",type=2,typeName="Button",time=87034738,x=369,y=-8,width=110,height=77,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,file="friends/friend_chat_send_normal_btn.png",file2="friends/friend_chat_send_press_btn.png",gridLeft=15,gridRight=15,gridTop=15,gridBottom=15,
				{
					name="send_text",type=4,typeName="Text",time=87034873,x=0,y=0,width=110,height=77,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,fontSize=28,textAlign=kAlignCenter,colorRed=250,colorGreen=230,colorBlue=180,string=[[发送]]
				}
			}
		}
	}
}