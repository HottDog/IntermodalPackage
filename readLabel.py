#coding=utf-8
import re
import func
import constant

CHECK_KEY_SENTENCE = "\-{2}\*{2}.+\*{2}\-{2}"
GET_KEYWORD = "[0-9a-z]+"
GET_INCLUDE_LIST = r"(?<=(\<include\>))(.+)(?=(\<\/include\>))"
GET_EXCEPT_LIST = r"(?<=(\<except\>))(.+)(?=(\<\/except\>))"
def rrr(m):
    print(m.group())
# 判断是不是关键句，是为true
def isKeySentence(s):
    re_word = re.compile(CHECK_KEY_SENTENCE)
    if re_word.match(s)!=None:
        return True
    else:
        return False

# 找到关键句中的关键词
def getKeyword(s):
    re_word = re.compile(GET_KEYWORD)
    group=re_word.findall(s)
    return group

def getIncludeList(s):
    re_word = re.compile(GET_INCLUDE_LIST)
    group = re_word.search(s)
    if group!=None:
        print(group[0])
        return group[0]
    else:
        return None

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
group = getExceptList("--**update-all**--[name]--<except>[uc][wx][vivo][oppo][baidu]</except>")
if group!=None:
    groups = getKeyword(group)
    for g in groups:
        print(g)
