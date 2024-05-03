#!/usr/bin/env python
# coding: utf-8

# In[ ]:


import pandas as pd
import math
import numpy as np
测试集 = pd.read_excel('测试集.xlsx',sheet_name=0)
车辆系数 = pd.read_excel('两个系数.xlsx',sheet_name=0)
驾驶员系数 = pd.read_excel('两个系数.xlsx',sheet_name=1)
R型平均索赔 = pd.read_excel('Regular的保费.xlsx',sheet_name=0)
R型平均索赔 = R型平均索赔.fillna(0)#替换为0
R型暴露 = pd.read_excel('Regular的保费.xlsx',sheet_name=1)
R型暴露 = R型暴露.fillna(0)#替换为0
NR型平均索赔 = pd.read_excel('NRegular的保费.xlsx',sheet_name=0)
NR型平均索赔 = NR型平均索赔.fillna(0)#替换为0
NR型暴露 = pd.read_excel('NRegular的保费.xlsx',sheet_name=1)
NR型暴露 = NR型暴露.fillna(0)#替换为0
NR_max = 2902
R_max = 2068


# In[ ]:


df = pd.read_excel("保费制定Final.xlsx")


# In[ ]:


最佳n1 = 0
最佳n2 = 0
最佳x = 0
最佳q = 0
最优设定值 = 0


# In[ ]:


for n1 in [4,6,8,10,12]:         
    for n2 in [4,6,8,10,12]:
        for x in [6,4,2,1,1/2,1/4,1/6,1/8,1/10]:
            for q in [0,100,500,1000,5000,10000]:
                df = 测试集
                车辆系数['系数'] = np.power(车辆系数['车辆系数'],1/n1)
                驾驶员系数['系数'] = np.power(驾驶员系数['驾驶员系数'],1/n2)
                制定NR型 = NR型平均索赔.iloc[:,:2].join(NR型平均索赔.iloc[:,2:]*np.power((NR型暴露.iloc[:,2:]/(NR_max+q)),x)+202*(1-np.power((NR型暴露.iloc[:,2:]/(NR_max+q)),x)))
                制定R型 = R型平均索赔.iloc[:,:2].join(R型平均索赔.iloc[:,2:]*np.power((R型暴露.iloc[:,2:]/(R_max+q)),x)+202*(1-np.power((R型暴露.iloc[:,2:]/(q+R_max)),x)))
                #check方法返回地区；动力；品牌
                def check(x):
                    return [df["Power"][x],df["Brand"][x],df["Gas"][x],df["Region"][x],df["CarAge"][x],df["DriverAge"][x]]

                def 使用制定R型(x1,x2,x3,x4,x5):
                    return (制定R型[x3] *(制定R型["Power"]== x1 )*(制定R型["Brand"]== x2 )).sum()*(车辆系数['系数']*(车辆系数['CarAge']== x4)).sum()*(驾驶员系数['系数']*(驾驶员系数['DriverAge']== x5)).sum()

                def 使用制定NR型(x1,x2,x3,x4,x5):
                    return (制定NR型[x3] *(制定NR型["Power"]== x1 )*(制定NR型["Brand"]== x2 )).sum()*(车辆系数['系数']*(车辆系数['CarAge']== x4)).sum()*(驾驶员系数['系数']*(驾驶员系数['DriverAge']== x5)).sum()


                a = [0]*len(df)
                for i in range(0,len(df)):
                    if(check(i)[2] == 'Regular'):#查找表格Regular
                        a[i] = 使用制定R型(check(i)[0],check(i)[1],check(i)[3],check(i)[4],check(i)[5])
                    else:#查找表格NRegular
                        a[i] = 使用制定NR型(check(i)[0],check(i)[1],check(i)[3],check(i)[4],check(i)[5])

                #对照模型
                设定值 = 0
                while(设定值<220):
                    对照模型 = (df["Pure Premium"]<(202-设定值))*(202-设定值)+(df["Pure Premium"]>(202+设定值))*(202+设定值)+(df["Pure Premium"]>(202-设定值))*(df["Pure Premium"]<(202+设定值))*202
                    if(sum((a<对照模型)*(a*df["Exposure"]-df["Claim Amount"]))>0):
                        设定值 = 设定值+1
                        #print(sum((a<对照模型)*(a*df["Exposure"]-df["Claim Amount"])))
                    else:
                        print(n1,n2,x,q,设定值)
                        if(设定值>最优设定值):
                            最佳n1 = n1
                            最佳n2 = n2
                            最佳x = x
                            最佳q = q
                            最优设定值 = 设定值
                        break


# In[ ]:




