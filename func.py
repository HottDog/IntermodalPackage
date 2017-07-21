# coding=utf-8
import os
import chardet
import codecs
# 获取文件的编码格式
def getFileFormat(file):
    f=open(file,"rb+")
    result = chardet.detect(f.read())
    # print("文件的编码格式：",result)
    # if result["encoding"] == "ISO-8859-1":
    # print("这个文件是ISO-8859-1")
    f.close()
    return result["encoding"]

# 获取文件的读写对象
def getFileRWObj(path):
    fileFormat = getFileFormat(path)
    # 获取到文件读取对象
    f = codecs.open(path,"r+",fileFormat)
    return f

#判断该文件是否是lua后缀的文件,true为是
def isLuaFile(path):
    if os.path.splitext(path)[1] == ".lua":
        return True
    else:
        return False

#遍历文件夹中的所有文件,并进行替换操作
#path 需要处理的文件夹的路径
def traverse(path):
    #如果是单个文件，则直接处理
    if not os.path.isdir(path):
        # processFile(path)
        return
    #如果是文件夹则遍历处理
    files =os.listdir(path)
    for file in files:
        if not os.path.isdir(path+"\\"+file):
            #不是文件夹
            # processFile(path+"\\"+file)
            return
        else:
            # print('文件夹:'+path+"\\"+file)
            traverse(path+"\\"+file)

#处理单个文本函数
def processFile(file):
    if not isLuaFile(file):
        return
    try:
        fileFormat = getFileFormat(file)
        # 获取到文件读取对象
        f = codecs.open(file,"r+",fileFormat)
        # f = codecs.open(file,"r+",'utf-8')
        # s1 = f.read()
    except OSError:
        print("file's format is not utf-8")

#按行写入
def writeFileByLine(f,line):
    f.write(line+"\n")

