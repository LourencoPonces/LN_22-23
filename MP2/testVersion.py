import pandas as pd
import time

from numpy.random import RandomState
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn import svm


textFile = pd.read_csv('train.txt', sep='\t', usecols=[0,1], header=None, names=["Label", "Review"])

total = 0
low = 0
for i in range(100):
    rng = RandomState()
    train = textFile.sample(frac=0.9, random_state=rng)
    test = textFile.loc[~textFile.index.isin(train.index)]


    vectorizer = TfidfVectorizer(min_df = 5,
                                max_df = 0.8,
                                sublinear_tf = True,
                                use_idf = True)

    train_vectors = vectorizer.fit_transform(train['Review'])
    test_vectors = vectorizer.transform(test['Review'])


    #classifier = svm.SVC(kernel='linear')
    classifier = svm.SVC(kernel='rbf')
    #classifier = svm.SVC(kernel='poly')
    #classifier = svm.SVC(kernel='sigmoid')

    t0 = time.time()
    classifier.fit(train_vectors, train['Label'])
    t1 = time.time()
    prediction = classifier.predict(test_vectors)
    t2 = time.time()

    time_train = t1-t0
    time_predict = t2-t1


    print("Training time: %fs; Prediction time: %fs" % (time_train, time_predict))

    count = 0
    for p, t in zip(prediction, test['Label']):
        if p == t:
            count = count + 1

    accuracy = count / len(prediction) * 100
    print("Accuracy:",accuracy,"%")

    
    if accuracy < 45:
        low = low + 1

    total = total + accuracy


print("Accuracy:",total / 100,"%")
print("Low:", low)
