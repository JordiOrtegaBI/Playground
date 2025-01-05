from funciones import argumentos, load_dataset, data_treatment, mlflow_tracking

# Achivo que ejecuta el modelo (llamando a funciones.py) e itera con MLflow
def main():
    print("Ejecutamos el main")
    
    args_values = argumentos()
    
    df = load_dataset()
    
    features_train, features_test, vocabulary, y_train, y_test = data_treatment(df)
    
    mlflow_tracking(args_values.nombre_job, features_train, features_test, y_train, y_test, args_values.n_estimators_list, args_values.learning_rate_list, args_values.max_depth_list)

if __name__ == "__main__":
    main()
