FROM python:3.11.2-slim  
  
# Seteamos el directorio
WORKDIR /app  
  
# Instalamos las librerías mediante requirements.txt
COPY requirements.txt .  
RUN pip install --no-cache-dir -r requirements.txt  
  
# Copiamos todo el contenido
COPY . .  
  
# Selecionamos el puerto
EXPOSE 8080  
  
# Runeamos la app
CMD ["streamlit", "run", "app.py", "--server.port=8080", "--server.enableCORS=false", "--server.enableXsrfProtection=false"]