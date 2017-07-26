#coding=utf-8
import readLabel
import func
import constant

# 专门处理all时，include和except标签存在的情况下，是否需要采取行动
# 返回的参数
# arg1 如果需要处理则返回true，与当前联运包无关则返回false
def whenAllCheckAction(flag,packName,lists):
    isAction = False
    if flag == constant.INCLUDE:
        if func.isInList(packName,lists):
            isAction =True
    else:
        if not func.isInList(packName,lists):
            isAction = True
    return isAction

# 删除操作
def delete(isEnd,name):
    if isEnd==constant.END:
        return constant.NORMAL_WRITE,name
    else:
        return constant.DELETE_PASS,name

def deleteAction(group,packName):
    if group[1] == packName:
        return delete(group[2],group[3])
    elif group[1] == constant.ALL:
        if whenAllCheckAction(group[4],packName,group[5]):
            return delete(group[2],group[3])
        else:
            return None,""
    else :
        return None,""

def update(isEnd,name):
    if isEnd != None:
        return constant.NORMAL_WRITE,name
    else:
        return constant.UPDATE_WRITE,name

def updateAction(group,packName):
    if group[1] == packName:
        return update(group[2],group[3])
    elif group[1] == constant.ALL:
        if whenAllCheckAction(group[4],packName,group[5]):
            return update(group[2],group[3])
        else:
            return None,""
    else:
        return None,""

def insert(name):
    return constant.INSERT_WRITE,name

def insertAction(group,packName):
    if group[1] == packName:
        return insert(group[3])
    elif group[1] == constant.ALL:
        if whenAllCheckAction(group[4],packName,group[5]):
            return insert(group[3])
        else:
            return None,""
    else:
        return None,""

# 返回的参数
# arg1 文件读写的操作
# arg2 name
def getFileProcessAction(group,packageName):
    if group[0] == constant.DELETE:
        return deleteAction(group,packageName)
    elif group[0] == constant.INSERT:
        return insertAction(group,packageName)
    elif group[0] == constant.UPDATE:
        return updateAction(group,packageName)


# f=func.getFileReadObj(constant.TEST_PATH_HOME+"1.txt")
# s=func.readLineWithoutLineBreak(f)
# if readLabel.isKeySentence(s):
#     arg1,arg2,arg3 = getFileProcessAction(readLabel.getKeyword(s))
#     print("arg1:"+(hex(arg1))+"arg2:"+arg2+"arg3:"+arg3)
# else:
#     print("不匹配")
if __name__ == '__main__' :
    str = "--**update-all**--[name]--<except>[wx][vivo][oppo][baidu]</except>"
    str1 = "--**update-all-end**--[name]--<except>[uc][wx][vivo][oppo][baidu]</except>"
    str2 = "--**delete-uc-end**--[name]"
    str3 = "--**delete-uc**--[name]"
    act,name = getFileProcessAction(readLabel.getParseLabelResult(str3),"uc")
    print(name)
    if act == constant.UPDATE_WRITE:
        print("create.UPDATE_WRITE")
    print(act)
