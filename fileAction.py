# coding=utf-8
import func
import constant
import xmlReader
import recogniseLabel
import readLabel

# 文件写操作
# args说明
# w 写文件的对象
# s 被读取的文件当前行的内容
# isKey 当前行是否是特定注释行
# action 写文件的操作
# name 在配置表中要被修改部分的内容的名称
# dict 为当前联运包配置表中所有要被修改的内容的列表，目前主要包含两部分update和insert
def excuteAction(w,s,isKey,action,name,dict):
    if action == constant.NORMAL_WRITE:
        if not isKey:
            func.writeFileInTheEndByLine(w,s)
    elif action == constant.UPDATE_WRITE:
        if action != constant.UPDATE_WRITE_END:
            if not isKey:
                func.writeFileInTheEndByLines(w,dict[constant.UPDATE][name])
                return constant.UPDATE_WRITE_END
    elif action == constant.INSERT_WRITE:
        func.writeFileInTheEndByLines(w,dict[constant.INSERT][name])
        return constant.NORMAL_WRITE
    return None

# 根据配置表和注释内容决定文件当前如何进行写操作
# dealContent 具体的某个name的那部分内容,eg.package[xmlReader.SCRIPT][fileName]
def modifyFile(rPath,wPath,packageName,dealContent):
    f=func.getFileReadObj(rPath)
    w=func.getFileWriteObj(wPath)
    action = constant.NORMAL_WRITE
    # packageName = package[constant.NAME]
    # dealContent = package[xmlReader.SCRIPT][fileName]
    print(dealContent)
    s=func.readLineWithoutLineBreak(f)
    name = ""
    while(s):
        isKeySentence = False
        groupTemp = readLabel.getParseLabelResult(s)
        # print(groupTemp)
        if groupTemp!= None:
            actiomTmp,nameTmp = recogniseLabel.getFileProcessAction(groupTemp,packageName)
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
