import argparse
import subprocess
import time
import mlflow
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.datasets import load_breast_cancer
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.preprocessing import normalize
from sklearn.metrics import precision_score, recall_score, f1_score
from sklearn.ensemble import GradientBoostingClassifier

# Creamos las funciones en archivo .py. Las llamaremos desde main.py. Repplicamos los pasos hechos en ipynb.
def argumentos():
    print("arrancan argumentos")
    parser = argparse.ArgumentParser(description='__main__ de la aplicación con argumentos de entrada.')
    parser.add_argument('--nombre_job', type=str, help='Valor para el parámetro nombre_documento.')
    parser.add_argument('--n_estimators_list', nargs='+', type=int, help='List of n_estimators values.')
    parser.add_argument('--learning_rate_list', nargs='+', type=float, help='List of lr values.')
    parser.add_argument('--max_depth_list', nargs='+', type=int, help='List of depth values.')
    return parser.parse_args()

def load_dataset():
    df = pd.read_csv('df_sports_outdoors_unigram.csv')
    return df

def data_treatment(df):
    X = df['review_clean']
    y = df['sentiment_label']

    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42, stratify=y)

    def extract_BoW_features(words_train, words_test, vocabulary_size=5000):
        vectorizer = CountVectorizer(max_features=vocabulary_size, analyzer='word', tokenizer=None)

        features_train = vectorizer.fit_transform(words_train).toarray()
        features_test = vectorizer.transform(words_test).toarray()

        vocabulary = vectorizer.vocabulary_

        return features_train, features_test, vocabulary

    features_train, features_test, vocabulary = extract_BoW_features(X_train, X_test)

    features_train = normalize(features_train, axis=1)
    features_test = normalize(features_test, axis=1)

    return features_train, features_test, vocabulary, y_train, y_test

def mlflow_tracking(nombre_job, features_train, features_test, y_train, y_test, n_estimators, learning_rate, max_depth):
    def classify_gboost(features_train, features_test, y_train, y_test, n_estimators, learning_rate, max_depth):
        clf = GradientBoostingClassifier(n_estimators=n_estimators, learning_rate=learning_rate, max_depth=max_depth, random_state=42)

        clf.fit(features_train, y_train)

        print("[{}] Accuracy: train = {}, test = {}".format(
                clf.__class__.__name__,
                clf.score(features_train, y_train),
                clf.score(features_test, y_test)))

        return clf

    mlflow_ui_process = subprocess.Popen(['mlflow', 'ui', '--port', '5000'])
    print(mlflow_ui_process)
    time.sleep(5)
    
    mlflow.set_experiment(nombre_job)

    for n in n_estimators:
        for lr in learning_rate:
            for depth in max_depth:
                with mlflow.start_run(run_name=f"n_estimators={n}_lr={lr}_max_depth={depth}") as run:       
                    clf2 = classify_gboost(features_train, features_test, y_train, y_test, n, lr, depth)

                    y_pred_train = clf2.predict(features_train)
                    y_pred_test = clf2.predict(features_test)

                    precision_train = precision_score(y_train, y_pred_train, average='weighted')
                    recall_train = recall_score(y_train, y_pred_train, average='weighted')
                    f1_train = f1_score(y_train, y_pred_train, average='weighted')

                    precision_test = precision_score(y_test, y_pred_test, average='weighted')
                    recall_test = recall_score(y_test, y_pred_test, average='weighted')
                    f1_test = f1_score(y_test, y_pred_test, average='weighted')

                    mlflow.log_param("n_estimators", n)
                    mlflow.log_param("lr", lr)
                    mlflow.log_param("max_depth", depth)

                    mlflow.log_metric("precision_train", precision_train)
                    mlflow.log_metric("recall_train", recall_train)
                    mlflow.log_metric("f1_train", f1_train)

                    mlflow.log_metric("precision_test", precision_test)
                    mlflow.log_metric("recall_test", recall_test)
                    mlflow.log_metric("f1_test", f1_test)

                    mlflow.sklearn.log_model(clf2, "gradient_boosting")
    
    print("Se ha acabado el entrenamiento del modelo correctamente")

