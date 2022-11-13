import pandas as pd
import sys

from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn import svm

trainFile = ''
testFile  = ''

if len(sys.argv) > 4:
    for i in range(len(sys.argv)):
        if sys.argv[i] == '-test':
            testFile = sys.argv[i+1]
        elif sys.argv[i] == '-train':
            trainFile = sys.argv[i+1]


train = pd.read_csv(trainFile, sep='\t', usecols=[0,1], header=None, names=["Label", "Review"])
test = pd.read_csv(testFile, sep='\t', usecols=[0], header=None, names=["Review"])


vectorizer = TfidfVectorizer(min_df = 5,
                            max_df = 0.8,
                            sublinear_tf = True,
                            use_idf = True)

train_vectors = vectorizer.fit_transform(train['Review'])

classifier = svm.SVC(kernel='rbf')
classifier.fit(train_vectors, train['Label'])


for i, t in test.iterrows():
    review_vector = vectorizer.transform([t['Review']])
    print(classifier.predict(review_vector)[0])
