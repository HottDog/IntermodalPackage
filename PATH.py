# coding=utf-8
import os
current_workspace = os.getcwd()   #脚本当前所在的工作目录
current_workspace_top = os.path.abspath(os.path.join(os.path.dirname(__file__), os.pardir))   #脚本上一层的工作路径
GENERATE = current_workspace_top+"\\generate\\"
RESOURCE_SCRIPTS = current_workspace_top+"\\release\\xiangqi_android\\Resource\\scripts"
XML_CONFIG = current_workspace_top+"\\config\\"
SCRIPTS = "\\scripts"