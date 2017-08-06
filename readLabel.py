#coding=utf-8
import re
import func
import constant

CHECK_KEY_SENTENCE = "\-{2}\*{2}.+\*{2}\-{2}"
CHECK_ANDROID_KEY_SENTENCE = "\/{2}\*{2}.+\*{2}\/{2}"
GET_KEYWORD = "[0-9a-zA-Z]+"
GET_INCLUDE_LIST = r"(?<=(\<include\>))(.+)(?=(\<\/include\>))"
GET_EXCEPT_LIST = r"(?<=(\<except\>))(.+)(?=(\<\/except\>))"
def rrr(m):
    print(m.group())
# 判断是不是关键句，是为true
def isKeySentence(s):
    re_word = re.compile(CHECK_KEY_SENTENCE)
    re_word_android = re.compile(CHECK_ANDROID_KEY_SENTENCE)
    if re_word.match(s)!=None or re_word_android.match(s)!=None:
        return True
    else:
        return False

# 找到关键句中的关键词
def getKeyword(s):
    re_word = re.compile(GET_KEYWORD)
    group=re_word.findall(s)
    return group

# 获取include标签包含的联运包列表
def getIncludeList(s):
    re_word = re.compile(GET_INCLUDE_LIST)
    group = re_word.search(s)
    if group!=None:
        print(group[0])
        return group[0]
    else:
        return None

# 获取except标签包含的联运包列表
def getExceptList(s):
    re_word = re.compile(GET_EXCEPT_LIST)
    group = re_word.search(s)
    if group!=None:
        print(group[0])
        return group[0]
    else:
        return None
# f=func.getFileReadObj(constant.TEST_PATH_HOME+"1.txt")
# # func.readLineWithoutLineBreak(f)
# s=func.readLineWithoutLineBreak(f)
# re_word = re.compile(CHECK_KEY_SENTENCE)
# if re_word.match(s)!=None:
#     print("匹配成功")
# else:
#     print("匹配失败")
# print(re_word.match(s))
# re_word1 = re.compile(GET_KEYWORD)
# # re_word1.sub(rrr,s,0)
# group=re_word1.findall(s)
# for g in group:
#     print(g)

#返回的参数
# arg1 如果没有结果则为None,
#      如果有结果则是一个group，group是一个列表，
#      第一个元素是update，insert这样的action字段，
#      第二个元素是联运包的标识名，
#      第三个元素如果有end则为end，否则为None,
#      第四个元素是要替换的部分的name，
#      第五个元素如果联运包的标识符是all的话，include或者except标签名，
#      第六个元素是include或者except里面包含的联运包的列表
def getParseLabelResult(s):
    if isKeySentence(s):
        group = getKeyword(s)
        # print(group)
        if group[1] == constant.ALL:
            # 判断有没有end表示符
            if group[2] != constant.END:
                name = group[2]
                group[2] = None
                group[3] = name
            sentence = getIncludeList(s)
            if sentence!=None:
                group[4] = constant.INCLUDE
                group[5] = getKeyword(sentence)
            else:
                sentence = getExceptList(s)
                group[4] = constant.EXCEPT
                group[5] = getKeyword(sentence)
            return group[0:6]
        else:
            # 判断有没有end表示符
            if group[2] != constant.END:
                name = group[2]
                group[2] = None
                group.append(name)
            return group
    else:
        return None

if __name__ == '__main__' :
    str = "//**update-all**//[name]--<except>[uc][wx][vivo][oppo][baidu]</except>"
    str1 = "--**update-all-end**--[name]--<except>[uc][wx][vivo][oppo][baidu]</except>"
    str2 = "--**delete-uc-end**--[name]"
    str3 = "--**delete-uc**--[name]"
    str4 = "//**delete-uc**//[first]"
    print(getParseLabelResult(str))
# group = getExceptList("--**update-all**--[name]--<except>[uc][wx][vivo][oppo][baidu]</except>")
# if group!=None:
#     groups = getKeyword(group)
#     for g in groups:
#         print(g)

