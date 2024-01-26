#!/usr/bin/env python
# coding: utf-8

# In[97]:


#importing libraries
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns


# In[98]:


#importing & reading csv files
df = pd.read_csv("C:/Users/Rahul/Downloads/data.csv")
df.head


# In[99]:


df.columns


# In[100]:


df.info()


# In[101]:


df = df.drop('Unnamed: 32',axis=1) # dropping column for Null values present


# In[102]:


df.head


# In[103]:


df.drop('id', axis = 1, inplace = True) #when inplace is true the dataset is modified and nothing is returned


# In[104]:


type(df.columns)


# In[105]:


l = list(df.columns)
print(l)


# In[106]:


#The data is accessed in different parts so we want different start points
features_mean = l[1:11] #all the feature means
features_se = l[11:21] #all the feature se
features_worst = l[21:] #all the feature worst


# In[107]:


print(features_mean)
print(features_se)
print(features_worst)


# In[108]:


df['diagnosis'].unique() #M- malgnant and B- Begin it is the stage of tumor


# In[109]:


sns.countplot(df['diagnosis'], label  ='count')


# In[110]:


df.describe() #statistcal summary


# In[111]:


corr = df.corr() #making the correlation matrix 
corr


# In[112]:


plt.figure(figsize = (10,10)) #adjusting the size
sns.heatmap(corr) #since the table is large and not viable to understand the information within


# In[113]:


# Encoding the labels M and B in diagnosis column to 1 and 0 respectively for scope of analysis
df['diagnosis'] = df['diagnosis'].map({'M':1 , 'B':0})
df['diagnosis'].unique()


# In[128]:


# Making the Labels
x = df.drop('diagnosis',axis = 1) #this is the dataframe without the diagnosis column
y = df['diagnosis'] #diagnosis column
x.head


# In[129]:


# With preprocessing finished we begin wwith training the dataset


# In[130]:


from sklearn.preprocessing import StandardScaler 
from sklearn.model_selection import train_test_split #used to split the dataset to train and test set


# In[131]:


x_train, x_test, y_train, y_test = train_test_split(x, y, test_size = 0.3, random_state = 42) #creating the test and train set


# In[132]:


df.shape


# In[133]:


x_train.shape


# In[134]:


x_test.shape


# In[135]:


y_train.shape


# In[136]:


y_test.shape


# In[137]:


ss = StandardScaler()
x_train = ss.fit_transform(x_train)
x_test = ss.fit_transform(x_test)


# In[138]:


#we get an array for x_train set


# In[141]:


from sklearn.metrics import accuracy_score
from sklearn.ensemble import RandomForestClassifier #For Random Forest Classifier


# In[142]:


rfc = RandomForestClassifier() #an instance of the class
rfc.fit(x_train,y_train) #training the rfc instance with the train data after which prediction is done


# In[143]:


y_pred = rfc.predict(x_test) #predicting the dependent variable value 


# In[162]:


acc_rfc_model = (accuracy_score(y_test,y_pred)*100) #to get the accuracy score for the algorithm
acc_rfc_model


# In[151]:


from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score
from sklearn.tree import DecisionTreeClassifier
from sklearn.neighbors import KNeighborsClassifier
from sklearn.svm import SVC
from sklearn.naive_bayes import GaussianNB


# In[154]:


knn = KNeighborsClassifier(n_neighbors=15) #Going with KNeighboursClassifier
clf = knn.fit(x_train, y_train)
y_pred = clf.predict(x_test)
acc_knb_model= accuracy_score(y_test, y_pred)*100
acc_knb_model


# In[155]:


lr = LogisticRegression(C = 0.2) #Logistic regression
clf1 = lr.fit(x_train, y_train)
y_pred1 = clf1.predict(x_test)
acc_log_reg=accuracy_score(y_test, y_pred1)*100
acc_log_reg


# In[156]:


clf3 = tree.DecisionTreeClassifier().fit(x_train, y_train) #DecisionTreeClassifier
y_pred3 = clf3.predict(x_test)
acc_dt=accuracy_score(y_test, y_pred3)*100
acc_dt


# In[158]:


clf5 = SVC(gamma='auto').fit(x_train, y_train) #SVC- implementation of Support Vector Machine algorithm for classification tasks
y_pred5 = clf5.predict(x_test)
acc_svm_model=accuracy_score(y_test, y_pred5)*100
acc_svm_model


# In[165]:


from sklearn.naive_bayes import GaussianNB #Naive Bayes Classification
nb = GaussianNB()
nb.fit(x_train, y_train)
print("Naive Bayes score: ",nb.score(x_test, y_test)*100)


# In[166]:


#Making a table listing the various ML models and their accuracy scores
results = pd.DataFrame({
    'Model': ['Support Vector Machines', 'KNN', 'Logistic Regression', 
              'Random Forest','Naive Bayes','Decision Tree'],
    'Score': [acc_svm_model, acc_knb_model, acc_log_reg, 
              acc_rfc_model,nb.score(x_test,y_test)*100,acc_dt]})
result_df = results.sort_values(by='Score', ascending=False)
result_df = result_df.set_index('Score')
result_df


# In[ ]:




