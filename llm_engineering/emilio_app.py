##################################################################################################################
############################## LLM ENGINEERING: Jordi Ortega - IA2 ###############################################
##################################################################################################################


# GenAI Project Lifecycle. Se desarrolla la app, desplegada en local.
# Nota. Con el propósito de conseguir un flujo completo la app se desplegó con el modelo antiguo (v2). Conviene pasarla a v3 para tener
# las respuestas precisas sobre sallud mental. 

from huggingface_hub import login
import streamlit as st
import random
import string
from transformers import pipeline, set_seed, GenerationConfig, AutoTokenizer, AutoModelForCausalLM

# Usamos token de perfil propio para descarga del modelo en HF
login(token="hf_RDUAAxxxxxxxxxxxxxxxxxxnCvKANYKB")

# Cargamos el modelo
tokenizer = AutoTokenizer.from_pretrained("JordiOrtega/finetuned_mental_health_distilgpt2")
model = AutoModelForCausalLM.from_pretrained("JordiOrtega/finetuned_mental_health_distilgpt2")

# Definimos el prompt template de inferencia
SYSTEM_MESSAGE= "You are a personal assistant expert in mental health issues that responds concisely based on the given context in order to help people. You receive a context and you must provide a concrete and helpful answer."

INFERENCE_PROMPT_TEMPLATE = """\
{bos_token}
{system_message}

### Context:
{Context}

### Response:
{eos_token}
"""

def create_prompt_and_response(sample):
  full_prompt = INFERENCE_PROMPT_TEMPLATE.format(
      bos_token = "<|startoftext|>",
      eos_token = "<|endoftext|>",
      system_message = SYSTEM_MESSAGE,
      Context = sample["Context"],
  )

  return {"full_prompt" : full_prompt}

# Generamos el pipeline
generator = pipeline('text-generation', model=model, tokenizer=tokenizer)

set_seed(42)

def generate_sample(sample):
    prompt_package = create_prompt_and_response(sample)

    generation_config = GenerationConfig(
        max_new_tokens=50,  
        do_sample=False,      
        top_k=100,            
        temperature=1e-4,     
        eos_token_id=model.config.eos_token_id,
    )

    generation = generator(prompt_package["full_prompt"], generation_config=generation_config)
    
    return generation, prompt_package

st.markdown(
    """
    <style>
    .col-container {
        display: flex;
        justify-content: space-between;
        gap: 20px;
    }
    .col {
        flex: 1; /* Aumenta la flexibilidad de las columnas */
        padding: 20px;
    }
    .right-col {
        max-width: 700px; /* Ensancha el ancho máximo de la columna derecha */
    }
    .chat-box {
        border: 1px solid #ddd;
        padding: 10px;
        max-height: 400px;
        overflow-y: scroll;
        margin-bottom: 20px;
    }
    .user-message {
        background-color: #e0f7fa;
        padding: 8px;
        border-radius: 8px;
        margin-bottom: 10px;
    }
    .bot-message {
        background-color: #e1bee7;
        padding: 8px;
        border-radius: 8px;
        margin-bottom: 10px;
    }
    </style>
    """,
    unsafe_allow_html=True,
)


st.markdown('<div class="col-container">', unsafe_allow_html=True)

st.markdown('<div class="col">', unsafe_allow_html=True)
st.image(
    "emilio_head.png",
    use_container_width=True
)
st.markdown('</div>', unsafe_allow_html=True)

st.markdown('<div class="col right-col">', unsafe_allow_html=True)
st.title("Robot Emilio 2.0.")
st.write("Soy Emilio, tu asistente personal. ¿En qué puedo ayudarte hoy?")

chat_box = st.empty()

user_input = st.text_area("Escribe tu mensaje", "", height=150)

def remove_redundant_phrases(response):
    words = response.split()
    unique_words = []
    for word in words:
        if word not in unique_words:
            unique_words.append(word)
    return " ".join(unique_words)

# Al presionar el botón, enviamos el mensaje y mostramos la respuesta
if st.button("Enviar"):
    if user_input:
        with chat_box.container():
            st.markdown(f'<div class="user-message">{user_input}</div>', unsafe_allow_html=True)
        
        generation, prompt_package = generate_sample({"Context": user_input})
        
        with chat_box.container():
            response = generation[0]["generated_text"].replace(prompt_package["full_prompt"], "")
            cleaned_response = remove_redundant_phrases(response)
            st.markdown(f'<div class="bot-message">{cleaned_response}</div>', unsafe_allow_html=True)

    else:
        st.warning("Por favor ingresa un mensaje.")

st.markdown('</div>', unsafe_allow_html=True)
st.markdown('</div>', unsafe_allow_html=True)