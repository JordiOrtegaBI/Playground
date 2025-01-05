import streamlit as st
import random
import string

# Seleccionamos la función de las definidas anteriormente
def generate_password(length: int) -> str:
    if length < 6:
        st.error("La longitud de la contraseña debe ser al menos 6.")
        return ""
    characters = string.ascii_letters + string.digits + string.punctuation
    password = ''.join(random.choice(characters) for _ in range(length))
    return password

# Creamos el título
st.title("Generador de Contraseñas")

# Creamos un slider con st
length = st.slider("Selecciona la longitud de la contraseña", min_value=6, max_value=64, value=12)

# Creamos el botón para ejecutar
if st.button("Generar Contraseña"):
    password = generate_password(length)
    if password:
        st.success("¡Contraseña generada!")
        st.code(password)
