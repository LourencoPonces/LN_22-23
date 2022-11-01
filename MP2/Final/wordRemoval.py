import pandas as pd

test = pd.read_csv('test.txt', sep='\t', usecols=[1], header=None, names=["Review"])

for i, t in test.iterrows():
    print(t['Review'])