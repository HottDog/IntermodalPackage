# coding=utf-8
import xmlReader
import readLabel
import func
import constant

DELETE_PASS = 0x100
UPDATE_WRITE = 0x101
INSERT_WRITE = 0x102
NORMAL_WRITE = 0x103
UPDATE_WRITE_END = 0x104

DELETE = "delete"
INSERT = "insert"
UPDATE = "update"
ALL = "all"
END = "end"

def deleteAction(group,packName):
    if group[1] == packName:
        if group[2] ==END :
            return NORMAL_WRITE,group[3]
        else:
            return DELETE_PASS,group[2]
    else :
        return None,""
def updateAction(group,packName):
    if group[1] == packName:
        if group[2]==END:
            return NORMAL_WRITE,group[3]
        else:
            return UPDATE_WRITE,group[2]
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
            return INSERT_WRITE,group[2]
        else:
            return None,""
    elif group[0] == UPDATE:
        return updateAction(group,packageName)

def excuteAction(w,s,isKey,action,name,dict):
    if action == NORMAL_WRITE:
        if not isKey:
            func.writeFileInTheEndByLine(w,s)
    elif action == UPDATE_WRITE:
        if action != UPDATE_WRITE_END:
            if not isKey:
                func.writeFileInTheEndByLines(w,dict["update"][name])
                return UPDATE_WRITE_END
    elif action == INSERT_WRITE:
        func.writeFileInTheEndByLines(w,dict["insert"][name])
        return NORMAL_WRITE
    return None

def processFile(file,package):
    f=func.getFileReadObj(constant.TEST_RESOURCE_PATH+file)
    w=func.getFileWriteObj(constant.TEST_COMBINED_PATH+file)
    action = NORMAL_WRITE
    packageName = package["name"]
    dealContent = package[xmlReader.SCRIPT][file]
    print(dealContent)
    s=func.readLineWithoutLineBreak(f)
    name = ""
    while(s):
        isKeySentence = False
        if readLabel.isKeySentence(s):
            actiomTmp,nameTmp = getFileProcessAction(readLabel.getKeyword(s),packageName)
            if actiomTmp != None:
                action = actiomTmp
                name = nameTmp
            isKeySentence=True
        actiomDealTmp = excuteAction(w,s,isKeySentence,action,name,dealContent)
        if actiomDealTmp!=None:
            action =actiomDealTmp
        s = func.readLineWithoutLineBreak(f)
    f.close()
    w.close()

if __name__ == '__main__':
    package = xmlReader.parseXML(constant.TEST_PATH_HOME+"new.xml")
    processFile("test.txt",package)