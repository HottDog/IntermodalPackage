#coding=utf-8
import re
import constant
# android那边java代码的包名替换
IS_PACKAGE_SENTENCE = ""
MATCH_PACKAGE = "\s*import\s+com.wgy"   #原包名
def isPackageSentence(s):
    re_word = re.compile(IS_PACKAGE_SENTENCE)
    # print (re_word.match(s))
    if re_word.match(s)!=None:
        return True
    else:
        return False

def rrr(m,s="com.yjc"):
    print (m.group)
    if m.group(0)!=None:
        return s

def replacePackage(str,package):
    re_word = re.compile(MATCH_PACKAGE)
    replaceStr = constant.IMPORT + package
    process_str = re_word.sub(replaceStr,str,0)
    # print(process_str)
    return process_str

if __name__ == '__main__':
    str = "import   com.wgy.cigaretteentry.data.bean.Case;\n"
    str1 = "import com.wgy.cigaretteentry.data.bean.Case;"
    package = "com.yjc"
    print(replacePackage(str+str1,package))