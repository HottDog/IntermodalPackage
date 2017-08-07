# coding=utf-8
import os
import chardet
import codecs
import shutil

# 判断某项是否在该列表中
# 参数
# arg1 item 某项
# arg2 lists 列表
# return true表示在，false表示不在
def isInList(item,lists):
    for list in lists:
        if list == item:
            return True
    return False

# 字典中是否包含该key
# return true表示包含，false表示不包含
def isInDict(key,dict):
    return key in dict.keys()

# 获取复制过去的路径
# fPath 读取的起始路径
# tPath 复制到的起始路径
# 被复制文件的路径
def getCopyDestination(path,fPath,tPath):
    relPath = os.path.relpath(path,fPath)
    # print(tPath+"\\"+relPath)
    return tPath+"\\"+relPath

# 获取文件名
def getFileNameFromPath(path):
    return os.path.basename(path)

# 获取文件拓展名
def getFileSuffixName(path):
    return os.path.splitext(path)[1]

# 获取文件的编码格式
def getFileFormat(file):
    f=open(file,"rb+")
    result = chardet.detect(f.read())
    # print("文件的编码格式：",result)
    # if result["encoding"] == "ISO-8859-1":
    # print("这个文件是ISO-8859-1")
    f.close()
    return result["encoding"]

# 获取文件的只读对象
def getFileReadObj(path):
    fileFormat = getFileFormat(path)
    # 获取到文件读取对象
    f = codecs.open(path,"r",fileFormat)
    return f

# 获取文件的只写对象
def getFileWriteObj(path):
    # fileFormat = getFileFormat(path)
    f = codecs.open(path,"w","utf8")
    return f

#判断该文件是否是lua后缀的文件,true为是
def isLuaFile(path):
    if getFileSuffixName(path) == ".lua":
        return True
    else:
        return False

# 遍历文件夹中的所有文件,并进行替换操作
# path 需要处理的文件夹的路径
# processFile 处理文件的函数
# processFiles 处理文件夹的函数
def traverse(path,processFile,processFiles):
    #如果是单个文件，则直接处理
    if not os.path.isdir(path):
        processFile(path)
        return
    else:
        if processFiles!=None:
            processFiles(path)
    #如果是文件夹则遍历处理
    files =os.listdir(path)
    for file in files:
        if not os.path.isdir(path+"\\"+file):
            #不是文件夹
            processFile(path+"\\"+file)
        else:
            # print('文件夹:'+path+"\\"+file)
            if processFiles!=None:
                processFiles(path+"\\"+file)
            traverse(path+"\\"+file,processFile,processFiles)

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

# 按行读取，去掉换行符
def readLineWithoutLineBreak(f):
    return f.readline().strip('\n')
#按行写入
def writeFileInTheEndByLine(f,line):
    if line:
        f.write(line+"\n")
    else:
        f.write("\n")
# 多行写入
# lines 是列表，列表每一项是1行
def writeFileInTheEndByLines(f,lines):
    for line in lines:
        writeFileInTheEndByLine(f,line)

# 复制文件或者文件夹
# 复制文件，如果文件存在就覆盖，不存在则创建
# 复制文件夹，如果存在则不管，如果不存在，则创建
def copyFile(fPath,tPath):
    if os.path.exists(tPath) :
        # 存在
        if not os.path.isdir(fPath):
            shutil.copyfile(fPath,tPath)
    else:
        if os.path.isdir(fPath):
            os.makedirs(tPath)
        else:
            shutil.copyfile(fPath,tPath)

# 删除文件
def deleteFile(path):
    if os.path.exists(path):
        shutil.rmtree(path)

# 创建文件
def createFile(path):
    if os.path.exists(path):
        deleteFile(path)
    os.makedirs(path)





