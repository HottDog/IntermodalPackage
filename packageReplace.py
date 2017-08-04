#coding=utf-8
import re
# android那边java代码的包名替换
IS_PACKAGE_SENTENCE = "\s*import\s+"
MATCH_PACKAGE = "com.wgy"   #原包名
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
    if isPackageSentence(str):
        re_word = re.compile(MATCH_PACKAGE)
        process_str = re_word.sub(package,str,0)
        print(process_str)
        return process_str

str = "import   com.wgy.cigaretteentry.data.bean.Case;"
str1 = "importcom.wgy.cigaretteentry.data.bean.Case;"
package = "com.yjc"

replacePackage(str,package)