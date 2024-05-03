# -*-coding:utf-8-*-
import numpy as np
from sklearn import metrics
import matplotlib.pyplot as plt
from sklearn.metrics import auc

# %%
X = np.array([1, 2, 2, 1, 2, 1, 0])
Y = np.array([2, 1, 2, 1, 2, 1, 0])
fpr, tpr, thresholds = metrics.roc_curve(X, Y, pos_label=1)

plt.plot(fpr, tpr, marker='o')
plt.show()

AUC = auc(fpr, tpr)
print(AUC)

mess = metrics.confusion_matrix(X, Y, labels=[0, 1, 2])
print(mess)

score = metrics.accuracy_score(X, Y)
print(score)

