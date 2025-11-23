# 📅 OptimAI - Agente Inteligente de Calendario y CRM

Un agente de IA avanzado con capacidades de transcripción de voz, diarización y gestión inteligente de calendarios y clientes. Desarrollado con Streamlit, Google ADK y AssemblyAI.

## 🚀 Configuración Rápida para Streamlit Cloud

1. **Crear APIs y Base de Datos**:
   - AssemblyAI: Obtén API key → Configurar en secrets
   - Supabase: Crear proyecto → Ejecutar `datos.sql` → Configurar URLs y keys
   - Google AI Studio: Obtener API key → Configurar en secrets
   - Google Calendar: Crear OAuth Web App → Configurar en secrets

2. **Configurar Secrets en Streamlit Cloud**:
   - Copia el contenido de `secrets_template.toml`
   - Pega en **Settings → Secrets** de tu app en Streamlit Cloud
   - Actualiza las API keys con tus credenciales reales

3. **Despliegue**:
   - Subir código a GitHub
   - Conectar repositorio en Streamlit Cloud
   - ¡Listo! La app estará funcionando en minutos

## ✨ Características Principales

### 🎤 **Transcripción y Diarización de Voz**
- Transcripción automática con AssemblyAI
- Detección de múltiples participantes (diarización)
- Extracción inteligente de información: fechas, horas, personas, empresas
- Soporte para grabación directa y subida de archivos .wav

### 📅 **Gestión de Calendario**
- Creación automática de eventos en Google Calendar
- Sincronización con base de datos Supabase
- Soporte para reuniones y citas
- Manejo inteligente de zonas horarias

### 📊 **Análisis de Clientes y Productos**
- Seguimiento de inversiones por cliente
- Análisis de productos y servicios
- Recomendaciones comerciales basadas en historial
- Gestión de información de contacto

### 🤖 **Agentes Especializados**
- **CalendarAgent**: Gestión de eventos y agenda
- **ProductAdvisorAgent**: Análisis de productos y ventas
- **ConversationAgent**: Consultas generales
- **CoreParallelAgent**: Consultas mixtas calendario + productos

## 🔧 Configuración de APIs y Base de Datos

### 1. AssemblyAI – Obtener ASSEMBLYAI_API_KEY

1. **Crear cuenta en AssemblyAI**
   - Regístrate en [AssemblyAI](https://www.assemblyai.com)
   - Verifica tu correo electrónico

2. **Obtener API Key**
   - Inicia sesión en el panel de AssemblyAI
   - Ve a **API Keys** en el menú lateral
   - Copia tu API key

3. **Configurar en la aplicación**
   ```bash
   # Opción A: Archivo .env (local)
   ASSEMBLYAI_API_KEY=tu_api_key_aqui
   
   # Opción B: Streamlit Cloud Secrets
   # En tu app → Settings → Secrets
   ASSEMBLYAI_API_KEY = "tu_api_key_aqui"
   ```

### 2. Supabase – Configurar Base de Datos y API Keys

#### 2.1. Crear Proyecto en Supabase
1. Ve a [Supabase](https://supabase.com) e inicia sesión
2. Crea un nuevo proyecto (elige organización, nombre y región)
3. Espera a que el proyecto se configure (2-3 minutos)

#### 2.2. Obtener Credenciales API
1. Entra a tu proyecto → **Project Settings** → **API KEY** → **Legacy API KEY**

Ahí encontrarás:
   - **anon public key** → `SUPABASE_ANON_KEY`
   - **service_role key** → `SUPABASE_SERVICE_KEY` (¡no publiques nunca!)
3.  Entra a tu proyecto → **Project Settings** → **DataAPI**

Ahí encontrarás:
   - **Project URL** → `SUPABASE_URL`

#### 2.3. Crear Tablas y Datos de Ejemplo
1. En tu proyecto de Supabase, ve a **SQL Editor** → **New query**
2. Copia y pega el contenido del archivo `datos.sql`
3. Haz clic en **Run** para ejecutar el script
4. Verifica en **Table Editor** que existan las tablas:
   - `clients`
   - `products` 
   - `calendar_events`
   - `client_products`

#### 2.4. Configurar Variables de Entorno
```bash
# Archivo .env (local)
SUPABASE_URL=https://tu-proyecto.supabase.co
SUPABASE_ANON_KEY=tu_anon_key_aqui
SUPABASE_SERVICE_KEY=tu_service_key_aqui

# Streamlit Cloud Secrets
SUPABASE_URL = "https://tu-proyecto.supabase.co"
SUPABASE_ANON_KEY = "tu_anon_key_aqui"
SUPABASE_SERVICE_KEY = "tu_service_key_aqui"
```

### 3. Google AI (Gemini) – Obtener GOOGLE_API_KEY

1. **Acceder a Google AI Studio**
   - Ve a [Google AI Studio](https://aistudio.google.com)
   - Inicia sesión con tu cuenta de Google

2. **Crear API Key**
   - Selecciona o crea un proyecto de Google Cloud
   - Haz clic en **Get API key**
   - Genera y copia tu API key

3. **Configurar en la aplicación**
```bash
# Archivo .env (local)
GOOGLE_API_KEY=tu_google_api_key

# Streamlit Cloud Secrets  
GOOGLE_API_KEY = "tu_google_api_key"
```

### 4. Google Calendar – Configuración para Streamlit Cloud

#### 4.1. Habilitar API y Configurar OAuth
1. **Habilitar Google Calendar API**
   - Ve a [Google Cloud Console](https://console.cloud.google.com)
   - Selecciona tu proyecto
   - Ve a **API & Services** → **Library**
   - Busca **Google Calendar API** → **Enable**

2. **Configurar Pantalla de Consentimiento**
   - Ve a **API & Services** → **OAuth consent screen**
   - **User Type**: External
   - Completa los datos básicos de la aplicación
   - Agrega el scope requerido:
     ```
     https://www.googleapis.com/auth/calendar
     ```

3. **Agregar Usuarios de Prueba (Obligatorio en modo Testing)**
   - En **OAuth consent screen** → **Public** → **Test users**
   - Agrega los correos que podrán usar la app
   - Solo estos usuarios podrán autorizar la app en Streamlit Cloud

#### 4.2. Crear Credenciales OAuth (Web Application)
1. **Crear Credenciales**
   - Ve a **Credentials** → **Create Credentials** → **OAuth client ID**
   - **Tipo**: Web application (para streamlit) Desktop Application (para local)
   - **Nombre**: OptimAI Streamlit

2. **Configurar Redirect URI**
   - En **Authorized redirect URIs**, agrega:
   ```
   https://tu-app.streamlit.app
   ```
   (Reemplaza `tu-app` con el nombre de tu app en Streamlit Cloud)

3. **Descargar Credenciales**
   - Haz clic en **Download JSON**
   - Guarda el archivo como `credentials.json`

#### 4.3. Configurar en Streamlit Cloud
1. En tu app de Streamlit Cloud → **Settings** → **Secrets**
2. Copia todo el contenido de tu `credentials.json` descargado
3. Pégalo en el campo `GOOGLE_CREDENTIALS` usando formato multilinea:
```toml
GOOGLE_CREDENTIALS = """
{
  "web": {
    "client_id": "tu_client_id",
    "project_id": "tu_project_id",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "client_secret": "tu_client_secret",
    "redirect_uris": ["https://agente-optimai.streamlit.app"],
    "javascript_origins": ["https://agente-optimai.streamlit.app"]
  }
}
"""
```
4. **Importante**: Reemplaza `https://agente-optimai.streamlit.app` con la URL real de tu app

#### 4.4. Autorización en Streamlit Cloud
1. La primera vez que ejecutes la app, verás "Conectar Google Calendar"
2. El usuario (de la lista de Test users) deberá autorizar la app
3. La app generará automáticamente `token.json` en la nube
4. Los tokens se renuevan solos sin necesidad de intervención manual

## 🚀 Despliegue en Streamlit Cloud

### Configuración del Repositorio

1. **Estructura de archivos**:
```
.
├── agent_streamlit.py          # Aplicación principal
├── requirements.txt            # Dependencias Python
├── datos.sql                   # Script para crear tablas en Supabase
├── secrets_template.toml       # Plantilla para secrets de Streamlit Cloud
├── .env                       # Variables de entorno (local, no subir a Git)
└── README.md                  # Este archivo
```

2. **Crear `requirements.txt`**:
```txt
streamlit>=1.28.0
google-adk>=0.0.1
assemblyai>=0.23.0
supabase>=1.0.0
google-auth>=2.22.0
google-auth-oauthlib>=1.0.0
google-auth-httplib2>=0.1.0
google-api-python-client>=2.95.0
python-dotenv>=1.0.0
aiohttp>=3.8.0
pydantic>=2.0.0
streamlit-mic-recorder>=0.0.7
google-genai>=0.3.0
```

3. **Variables de Entorno en Streamlit Cloud**:

En tu dashboard de Streamlit Cloud, ve a tu app → Settings → Secrets y agrega:

```toml
[secrets]
# Google AI Studio (Gemini)
GOOGLE_API_KEY = "tu_google_api_key"

# AssemblyAI
ASSEMBLYAI_API_KEY = "tu_assemblyai_api_key"

# Supabase
SUPABASE_URL = "https://tu-proyecto.supabase.co"
SUPABASE_ANON_KEY = "tu_supabase_anon_key"
SUPABASE_SERVICE_KEY = "tu_supabase_service_key"

# Google Calendar (credenciales completas)
GOOGLE_CREDENTIALS = """
{
  "web": {
    "client_id": "",
    "project_id": "",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "client_secret": "",
    "redirect_uris": ["https://agente-optimai.streamlit.app"],
    "javascript_origins": ["https://agente-optimai.streamlit.app"]
  }
}
"""
```

## 🚀 Instalación Local

### 1. Clonar el Repositorio
Descarga el archivo adjunto ´OptimAi adk web.zip´ y descromprimelo donde gustes.

### 2. Configurar Variables de Entorno
Sigue los pasos que se encuentran en el README.md que se encuentran ubcados en el archivo adjuntado.

## 📱 Uso de la Aplicación

**Nota:** se debe de dar la indicacióna al incio de la conversación del agente "realiza una sincronización" para conectar con Google Calendar.(en caso de que ya se haya realizado ua vez, no es necesario realizarlo de nuevo)

### Por Voz
1. **Grabar**: Usa el micrófono para grabar instrucciones o reuniones
2. **Subir**: Carga archivos .wav con conversaciones existentes
3. **Procesamiento**: El sistema extrae automáticamente fechas, personas, y acciones

### Por Texto
1. **Escribe consultas**: "Agenda una reunión con Cliente X mañana a las 3pm"
2. **Preguntas**: "¿Qué productos ha comprado el cliente Y?"
3. **Análisis**: "Muéstrame mis eventos de esta semana"

## 📋 Estructura del Código (Versión Limpia)

El archivo `agent_streamlit.py` está organizado en 16 secciones principales para máxima claridad:

### **1. Importaciones y Configuración**
- Todas las librerías necesarias importadas con comentarios
- Configuración de variables de entorno

### **2. Modelos de Datos (Pydantic)**
- `EventModel`: Validación de eventos de calendario
- `ClientModel`: Validación de datos de clientes

### **3. Funciones de Utilidad**
- `format_datetime()`: Formateo de fechas
- `validate_event_data()`: Validación de datos

### **4. Clientes de API**
- `get_supabase_client()`: Conexión a Supabase con caché
- `get_calendar_service()`: Conexión a Google Calendar
- Manejo de errores y reintentos automáticos

### **5. Funciones CRUD (Supabase)**
- `sb_create_event()`: Crear eventos
- `sb_list_events()`: Listar con filtros
- `sb_update_event()`: Actualizar eventos
- `sb_delete_event()`: Eliminar eventos

### **6. Sincronización**
- `sync_event_creation()`: Sincronización bidireccional
- `sync_events_to_google_calendar()`: Recuperación de eventos

### **7. AssemblyAI (Transcripción)**
- `aa_transcribe_note()`: Transcripción con diarización
- `upload_audio_to_assemblyai()`: Subida de archivos

### **8. Prompts de Agentes**
- Prompts detallados y comentados para cada agente
- Instrucciones claras y ejemplos

### **9. Definición de Agentes**
- Configuración completa con Google ADK
- Herramientas y callbacks de seguridad

### **10. Interfaz de Usuario**
- Streamlit UI organizada y comentada
- Manejo de audio y texto

## 🔧 Configuración Avanzada

### Personalizar Prompts
Los prompts de los agentes están claramente documentados:
- `calendar_agent_prompt`: Gestión de calendario y eventos
- `product_agent_prompt`: Análisis de productos y clientes
- `conversation_agent_prompt`: Asistencia general
- `master_router_prompt`: Enrutamiento inteligente

### Ajustar Diarización
```python
# En la función aa_transcribe_note
transcript = transcriber.transcribe(
    audio_url,
    speaker_labels=True,    
    auto_highlights=True,   
    sentiment_analysis=True 
)
```

## 🐛 Solución de Problemas

### Errores Comunes

1. **"Google Calendar API no está habilitada"**:
   - Habilita la API en Google Cloud Console
   - Verifica las credenciales OAuth

2. **"AssemblyAI transcription failed"**:
   - Verifica tu API key de AssemblyAI
   - Asegúrate que el archivo de audio sea accesible

3. **"Supabase connection error"**:
   - Verifica la URL y API key de Supabase
   - Confirma que la tabla `calendar_events` exista
