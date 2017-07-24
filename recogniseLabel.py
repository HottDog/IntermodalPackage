#coding=utf-8
import readLabel
import create
import func
import constant
DELETE = "delete"
INSERT = "insert"
UPDATE = "update"
ALL = "all"
END = "end"
def deleteAction(group,packName):
    if group[1] == packName:
        if group[2] ==END :
            return create.NORMAL_WRITE,group[3]
        else:
            return create.DELETE_PASS,group[2]
    else :
        return None,""
def updateAction(group,packName):
    if group[1] == packName:
        if group[2]==END:
            return create.NORMAL_WRITE,group[3]
        else:
            return create.UPDATE_WRITE,group[2]
    else:
        return None,""

# 返回的参数
# arg1 文件读写的操作
# arg2 包标识
# arg3 name
def getFileProcessAction(group,packageName):
    if group[0] == DELETE:
        return deleteAction(group,packageName)
    elif group[0] == INSERT:
        if group[1] == packageName:
            return create.INSERT_WRITE,group[2]
        else:
            return None,""
    elif group[0] == UPDATE:
        return updateAction(group,packageName)

f=func.getFileReadObj(constant.TEST_PATH_HOME+"1.txt")
s=func.readLineWithoutLineBreak(f)
if readLabel.isKeySentence(s):
    arg1,arg2,arg3 = getFileProcessAction(readLabel.getKeyword(s))
    print("arg1:"+(hex(arg1))+"arg2:"+arg2+"arg3:"+arg3)
else:
    print("不匹配")
