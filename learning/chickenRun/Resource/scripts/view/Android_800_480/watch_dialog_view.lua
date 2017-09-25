watch_dialog_view=
{
	name="watch_dialog_view",type=0,typeName="View",time=0,x=0,y=0,width=720,height=1280,visible=1,fillParentWidth=1,fillParentHeight=1,nodeAlign=kAlignBottom,
	{
		name="bg",type=1,typeName="Image",time=97923761,x=102,y=38,width=1,height=1,visible=0,fillParentWidth=1,fillParentHeight=1,nodeAlign=kAlignTopLeft,file="drawable/blank_black.png"
	},
	{
		name="chat_view",type=0,typeName="View",time=110605122,x=0,y=0,width=720,height=150,visible=1,fillParentWidth=1,fillParentHeight=0,nodeAlign=kAlignBottom,
		{
			name="chat_info_view",type=0,typeName="View",time=110605123,x=0,y=86,width=720,height=212,visible=1,fillParentWidth=1,fillParentHeight=0,nodeAlign=kAlignBottom,
			{
				name="chat_bg",type=1,typeName="Image",time=110605124,x=32,y=0,width=617,height=212,visible=1,fillParentWidth=0,fillParentHeight=1,nodeAlign=kAlignCenter,file="common/background/comment_bg.png",gridLeft=50,gridRight=50,gridTop=50,gridBottom=50,
				{
					name="chat_info",type=0,typeName="View",time=110605125,x=0,y=0,width=200,height=150,visible=0,fillParentWidth=1,fillParentHeight=1,nodeAlign=kAlignTopLeft
				},
				{
					name="chat_people",type=0,typeName="View",time=110605126,x=0,y=0,width=617,height=250,visible=0,fillParentWidth=1,fillParentHeight=1,nodeAlign=kAlignTopLeft,
					{
						name="View2",type=0,typeName="View",time=110627419,x=0,y=0,width=200,height=150,visible=1,fillParentWidth=1,fillParentHeight=1,nodeAlign=kAlignTopLeft,
						{
							name="watcher_node",type=0,typeName="View",time=110627514,x=0,y=0,width=155,height=250,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,
							{
								name="icon",type=0,typeName="View",time=110628093,x=0,y=0,width=120,height=120,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTop,
								{
									name="icon_frame",type=1,typeName="Image",time=110628136,x=0,y=0,width=90,height=90,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="userinfo/icon_9090_frame.png"
								},
								{
									name="level",type=1,typeName="Image",time=110628300,x=0,y=9,width=52,height=26,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignBottom,file="common/icon/level_1.png"
								}
							},
							{
								name="name_score",type=0,typeName="View",time=110628103,x=0,y=20,width=155,height=50,visible=1,fillParentWidth=1,fillParentHeight=0,nodeAlign=kAlignCenter,
								{
									name="name",type=4,typeName="Text",time=110628167,x=0,y=0,width=96,height=24,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTop,fontSize=24,textAlign=kAlignCenter,colorRed=80,colorGreen=80,colorBlue=80,string=[[我勒个去]]
								},
								{
									name="score",type=4,typeName="Text",time=110628173,x=0,y=0,width=72,height=24,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignBottom,fontSize=24,textAlign=kAlignCenter,colorRed=125,colorGreen=80,colorBlue=65,string=[[123456]]
								}
							},
							{
								name="add_btn",type=2,typeName="Button",time=110628122,x=0,y=13,width=120,height=51,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignBottom,file="common/button/dialog_btn_3_normal.png",file2="common/button/dialog_btn_3_press.png",
								{
									name="add_txt",type=4,typeName="Text",time=110628193,x=0,y=-2,width=72,height=24,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,fontSize=24,textAlign=kAlignCenter,colorRed=245,colorGreen=235,colorBlue=210,string=[[加关注]]
								}
							}
						},
						{
							name="View31",type=0,typeName="View",time=110628895,x=155,y=0,width=155,height=250,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,
							{
								name="icon",type=0,typeName="View",time=110628896,x=0,y=0,width=120,height=120,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTop,
								{
									name="icon_frame",type=1,typeName="Image",time=110628897,x=0,y=0,width=84,height=84,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="userinfo/icon_8484_mask.png"
								},
								{
									name="level",type=1,typeName="Image",time=110628898,x=0,y=9,width=52,height=26,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignBottom,file="common/icon/level_1.png"
								}
							},
							{
								name="name_score",type=0,typeName="View",time=110628899,x=0,y=20,width=155,height=50,visible=1,fillParentWidth=1,fillParentHeight=0,nodeAlign=kAlignCenter,
								{
									name="name",type=4,typeName="Text",time=110628900,x=0,y=0,width=96,height=24,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTop,fontSize=24,textAlign=kAlignCenter,colorRed=80,colorGreen=80,colorBlue=80,string=[[我勒个去]]
								},
								{
									name="score",type=4,typeName="Text",time=110628901,x=0,y=0,width=72,height=24,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignBottom,fontSize=24,textAlign=kAlignCenter,colorRed=125,colorGreen=80,colorBlue=65,string=[[123456]]
								}
							},
							{
								name="add_btn",type=2,typeName="Button",time=110628902,x=0,y=13,width=120,height=51,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignBottom,file="common/button/dialog_btn_3_normal.png",file2="common/button/dialog_btn_3_press.png",
								{
									name="add_txt",type=4,typeName="Text",time=110628903,x=0,y=-2,width=72,height=24,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,fontSize=24,textAlign=kAlignCenter,colorRed=245,colorGreen=235,colorBlue=210,string=[[加关注]]
								}
							}
						},
						{
							name="View32",type=0,typeName="View",time=110628909,x=310,y=0,width=155,height=250,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,
							{
								name="icon",type=0,typeName="View",time=110628910,x=0,y=0,width=120,height=120,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTop,
								{
									name="icon_frame",type=1,typeName="Image",time=110628911,x=0,y=0,width=84,height=84,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="userinfo/icon_8484_mask.png"
								},
								{
									name="level",type=1,typeName="Image",time=110628912,x=0,y=9,width=52,height=26,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignBottom,file="common/icon/level_1.png"
								}
							},
							{
								name="name_score",type=0,typeName="View",time=110628913,x=0,y=20,width=155,height=50,visible=1,fillParentWidth=1,fillParentHeight=0,nodeAlign=kAlignCenter,
								{
									name="name",type=4,typeName="Text",time=110628914,x=0,y=0,width=96,height=24,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTop,fontSize=24,textAlign=kAlignCenter,colorRed=80,colorGreen=80,colorBlue=80,string=[[我勒个去]]
								},
								{
									name="score",type=4,typeName="Text",time=110628915,x=0,y=0,width=72,height=24,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignBottom,fontSize=24,textAlign=kAlignCenter,colorRed=125,colorGreen=80,colorBlue=65,string=[[123456]]
								}
							},
							{
								name="add_btn",type=2,typeName="Button",time=110628916,x=0,y=13,width=120,height=51,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignBottom,file="common/button/dialog_btn_3_normal.png",file2="common/button/dialog_btn_3_press.png",
								{
									name="add_txt",type=4,typeName="Text",time=110628917,x=0,y=-2,width=72,height=24,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,fontSize=24,textAlign=kAlignCenter,colorRed=245,colorGreen=235,colorBlue=210,string=[[加关注]]
								}
							}
						},
						{
							name="View33",type=0,typeName="View",time=110628918,x=465,y=0,width=155,height=250,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,
							{
								name="icon",type=0,typeName="View",time=110628919,x=0,y=0,width=120,height=120,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTop,
								{
									name="icon_frame",type=1,typeName="Image",time=110628920,x=0,y=0,width=84,height=84,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="userinfo/icon_8484_mask.png"
								},
								{
									name="level",type=1,typeName="Image",time=110628921,x=0,y=9,width=52,height=26,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignBottom,file="common/icon/level_1.png"
								}
							},
							{
								name="name_score",type=0,typeName="View",time=110628922,x=0,y=20,width=155,height=50,visible=1,fillParentWidth=1,fillParentHeight=0,nodeAlign=kAlignCenter,
								{
									name="name",type=4,typeName="Text",time=110628923,x=0,y=0,width=96,height=24,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTop,fontSize=24,textAlign=kAlignCenter,colorRed=80,colorGreen=80,colorBlue=80,string=[[我勒个去]]
								},
								{
									name="score",type=4,typeName="Text",time=110628924,x=0,y=0,width=72,height=24,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignBottom,fontSize=24,textAlign=kAlignCenter,colorRed=125,colorGreen=80,colorBlue=65,string=[[123456]]
								}
							},
							{
								name="add_btn",type=2,typeName="Button",time=110628925,x=0,y=13,width=120,height=51,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignBottom,file="common/button/dialog_btn_3_normal.png",file2="common/button/dialog_btn_3_press.png",
								{
									name="add_txt",type=4,typeName="Text",time=110628926,x=0,y=-2,width=72,height=24,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,fontSize=24,textAlign=kAlignCenter,colorRed=245,colorGreen=235,colorBlue=210,string=[[加关注]]
								}
							}
						}
					},
					{
						name="ScrollView1",type=0,typeName="ScrollView",time=110635713,x=-1,y=-35,width=617,height=250,visible=0,fillParentWidth=1,fillParentHeight=1,nodeAlign=kAlignTopLeft,
						{
							name="watcher_node1",type=0,typeName="View",time=110635736,x=0,y=0,width=155,height=250,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,
							{
								name="icon",type=0,typeName="View",time=110635737,x=0,y=0,width=120,height=120,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTop,
								{
									name="icon_frame",type=1,typeName="Image",time=110635738,x=0,y=0,width=90,height=90,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="userinfo/icon_9090_frame.png"
								},
								{
									name="level",type=1,typeName="Image",time=110635739,x=0,y=9,width=52,height=26,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignBottom,file="common/icon/level_1.png"
								}
							},
							{
								name="name_score",type=0,typeName="View",time=110635740,x=0,y=20,width=155,height=50,visible=1,fillParentWidth=1,fillParentHeight=0,nodeAlign=kAlignCenter,
								{
									name="name",type=4,typeName="Text",time=110635741,x=0,y=0,width=96,height=24,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTop,fontSize=24,textAlign=kAlignCenter,colorRed=80,colorGreen=80,colorBlue=80,string=[[我勒个去]]
								},
								{
									name="score",type=4,typeName="Text",time=110635742,x=0,y=0,width=72,height=24,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignBottom,fontSize=24,textAlign=kAlignCenter,colorRed=125,colorGreen=80,colorBlue=65,string=[[123456]]
								}
							},
							{
								name="add_btn",type=2,typeName="Button",time=110635743,x=0,y=13,width=120,height=51,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignBottom,file="common/button/dialog_btn_3_normal.png",file2="common/button/dialog_btn_3_press.png",
								{
									name="add_txt",type=4,typeName="Text",time=110635744,x=0,y=-2,width=72,height=24,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,fontSize=24,textAlign=kAlignCenter,colorRed=245,colorGreen=235,colorBlue=210,string=[[加关注]]
								}
							}
						},
						{
							name="View311",type=0,typeName="View",time=110635746,x=155,y=0,width=155,height=250,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,
							{
								name="icon",type=0,typeName="View",time=110635747,x=0,y=0,width=120,height=120,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTop,
								{
									name="icon_frame",type=1,typeName="Image",time=110635748,x=0,y=0,width=84,height=84,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="userinfo/icon_8484_mask.png"
								},
								{
									name="level",type=1,typeName="Image",time=110635749,x=0,y=9,width=52,height=26,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignBottom,file="common/icon/level_1.png"
								}
							},
							{
								name="name_score",type=0,typeName="View",time=110635750,x=0,y=20,width=155,height=50,visible=1,fillParentWidth=1,fillParentHeight=0,nodeAlign=kAlignCenter,
								{
									name="name",type=4,typeName="Text",time=110635751,x=0,y=0,width=96,height=24,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTop,fontSize=24,textAlign=kAlignCenter,colorRed=80,colorGreen=80,colorBlue=80,string=[[我勒个去]]
								},
								{
									name="score",type=4,typeName="Text",time=110635752,x=0,y=0,width=72,height=24,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignBottom,fontSize=24,textAlign=kAlignCenter,colorRed=125,colorGreen=80,colorBlue=65,string=[[123456]]
								}
							},
							{
								name="add_btn",type=2,typeName="Button",time=110635753,x=0,y=13,width=120,height=51,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignBottom,file="common/button/dialog_btn_3_normal.png",file2="common/button/dialog_btn_3_press.png",
								{
									name="add_txt",type=4,typeName="Text",time=110635754,x=0,y=-2,width=72,height=24,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,fontSize=24,textAlign=kAlignCenter,colorRed=245,colorGreen=235,colorBlue=210,string=[[加关注]]
								}
							}
						}
					}
				}
			},
			{
				name="chat_info_btn",type=2,typeName="Button",time=110605127,x=-302,y=10,width=71,height=99,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTop,file="common/button/table_chose_3_press.png",
				{
					name="chat_txt1",type=4,typeName="Text",time=110605128,x=0,y=18,width=30,height=30,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTop,fontSize=28,textAlign=kAlignLeft,colorRed=255,colorGreen=255,colorBlue=255,string=[[聊]]
				},
				{
					name="chat_txt2",type=4,typeName="Text",time=110605129,x=0,y=18,width=30,height=30,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignBottom,fontSize=28,textAlign=kAlignLeft,colorRed=255,colorGreen=255,colorBlue=255,string=[[天]]
				}
			},
			{
				name="watch_people_btn",type=2,typeName="Button",time=110605130,x=-307,y=10,width=62,height=96,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignBottom,file="common/button/table_chose_3_nor.png",
				{
					name="chat_txt1",type=4,typeName="Text",time=110605131,x=4,y=18,width=30,height=30,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTop,fontSize=28,textAlign=kAlignLeft,colorRed=255,colorGreen=255,colorBlue=255,string=[[观]]
				},
				{
					name="chat_txt2",type=4,typeName="Text",time=110605132,x=4,y=18,width=30,height=30,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignBottom,fontSize=28,textAlign=kAlignLeft,colorRed=255,colorGreen=255,colorBlue=255,string=[[战]]
				}
			}
		},
		{
			name="send_chat_view",type=0,typeName="View",time=110605133,x=0,y=-490,width=720,height=155,visible=1,fillParentWidth=1,fillParentHeight=0,nodeAlign=kAlignBottom,
			{
				name="chat_bg",type=1,typeName="Image",time=110605134,x=0,y=0,width=720,height=590,visible=1,fillParentWidth=1,fillParentHeight=0,nodeAlign=kAlignBottom,file="online/room/bottom_menu_bg.png",gridLeft=128,gridRight=128,gridTop=55,gridBottom=55
			},
			{
				name="input_view",type=0,typeName="View",time=110605135,x=0,y=0,width=720,height=590,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignBottom,
				{
					name="chat_book",type=2,typeName="Button",time=110605136,x=434,y=33,width=128,height=58,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,file="common/button/dialog_btn_7_normal.png",file2="common/button/dialog_btn_7_press.png",
					{
						name="Text1",type=4,typeName="Text",time=110605137,x=0,y=0,width=102,height=34,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,fontSize=34,textAlign=kAlignCenter,colorRed=245,colorGreen=235,colorBlue=210,string=[[常用语]]
					}
				},
				{
					name="send_btn",type=2,typeName="Button",time=110605138,x=566,y=33,width=128,height=58,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,file="common/button/dialog_btn_3_normal.png",file2="common/button/dialog_btn_3_press.png",
					{
						name="Text11",type=4,typeName="Text",time=110605139,x=0,y=0,width=68,height=34,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,fontSize=34,textAlign=kAlignLeft,colorRed=245,colorGreen=235,colorBlue=210,string=[[发送]]
					}
				},
				{
					name="edit_bg",type=1,typeName="Image",time=110605140,x=24,y=33,width=402,height=62,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,file="common/background/input_bg_2.png",gridLeft=33,gridRight=33,gridTop=31,gridBottom=31,
					{
						name="input_edit",type=6,typeName="EditText",time=110605141,x=13,y=13,width=375,height=36,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,fontSize=32,textAlign=kAlignLeft,colorRed=80,colorGreen=80,colorBlue=80,string=[[]]
					}
				},
				{
					name="chat_book_bg",type=1,typeName="Image",time=110605142,x=0,y=0,width=668,height=478,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignBottom,file="online/room/chat/chat_book_bg.png",gridLeft=64,gridRight=64,gridTop=64,gridBottom=64
				},
				{
					name="chat_book_view",type=0,typeName="ScrollView",time=110605143,x=0,y=0,width=668,height=478,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignBottom
				}
			}
		}
	},
	{
		name="full_screen_view",type=0,typeName="View",time=110712316,x=81,y=513,width=200,height=150,visible=0,fillParentWidth=1,fillParentHeight=1,nodeAlign=kAlignTopLeft,
		{
			name="bg",type=1,typeName="Image",time=110712338,x=0,y=0,width=720,height=1280,visible=1,fillParentWidth=1,fillParentHeight=1,nodeAlign=kAlignTopLeft,file="drawable/blank_black.png"
		},
		{
			name="hidescreen",type=1,typeName="Image",time=110713755,x=0,y=30,width=194,height=30,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignBottom,file="online/watch/hidefullscreen.png"
		},
		{
			name="chat_info",type=0,typeName="View",time=110714275,x=0,y=80,width=617,height=215,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignBottom
		},
		{
			name="chess_board",type=0,typeName="View",time=110715489,x=0,y=0,width=720,height=760,visible=1,fillParentWidth=1,fillParentHeight=0,nodeAlign=kAlignTop
		},
		{
			name="front_bg",type=1,typeName="Image",time=110719404,x=0,y=0,width=720,height=1280,visible=1,fillParentWidth=1,fillParentHeight=1,nodeAlign=kAlignTopLeft,file="drawable/blank.png"
		}
	}
}