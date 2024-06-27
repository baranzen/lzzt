# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

# Library Imports
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.impute import SimpleImputer
from sklearn.preprocessing import OneHotEncoder, LabelEncoder
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler

# Data Loading
veriler = pd.read_csv("eksikveriler.csv")
boykilo = veriler[["boy","kilo"]]
print(boykilo)

# Handling Missing Values
imputer = SimpleImputer(missing_values=np.nan, strategy="mean")
yas = veriler.iloc[:,1:4].values
imputer = imputer.fit(yas[:,1:4]) # Fitting the imputer
yas[:,1:4] = imputer.transform(yas[:,1:4]) # Transforming the data

# Encoding Categorical Variables
ulkeler = veriler.iloc[:,0:1].values
le = LabelEncoder()
ulkeler[:,0] = le.fit_transform(veriler.iloc[:,0].values) # Encoding the categorical variable
ohe = OneHotEncoder()
ulkeler = ohe.fit_transform(ulkeler).toarray() 
print(ulkeler)
print(yas)

# Creating DataFrames
sonuc = pd.DataFrame(data=ulkeler, index=range(22), columns=['fr','tr','us'])
print(sonuc)

sonuc2 = pd.DataFrame(data=yas, index=range(22), columns=['boy','kilo','yas'])
s = pd.concat([sonuc, sonuc2], axis=1) # Concatenating the DataFrames

print(s)

# Splitting Data
x_train, x_test, y_train, y_test = train_test_split(s, sonuc2, test_size=0.3, random_state=0)

# Feature Scaling
sc = StandardScaler()
x_train = sc.fit_transform(x_train)
x_test = sc.transform(x_test)