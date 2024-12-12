from fastapi import FastAPI
from fastapi.security import HTTPBasic, HTTPBasicCredentials
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from fastapi import status, Depends
import mysql.connector
from mysql.connector import Error
import hashlib  # Usaremos hashlib para crear MD5

app = FastAPI()

security = HTTPBasic()
securityBearer = HTTPBearer()

# Función para crear el hash MD5 de la contraseña
def hash_password_md5(password: str) -> str:
    return hashlib.md5(password.encode('utf-8')).hexdigest()

def get_db_connection():
    try:
        connection = mysql.connector.connect(
            host='localhost',
            database='contactos',  # Nombre de la base de datos que quieres usar
            user='root',        # Nombre de usuario de la base de datos
            password='12345'    # Contraseña de la base de datos
        )
        return connection
    except Error as e:
        print(f"Error en la conexión a la base de datos: {e}")
        return None

@app.get(
    "/token/",
    status_code=status.HTTP_202_ACCEPTED,
    summary="Regresa el token de un usuario",
    description="Valida username y password con los usuarios registrados",
    tags=["token"],
)
def getToken(credentials: HTTPBasicCredentials = Depends(security)):
    try:
        connection = get_db_connection()
        cursor = connection.cursor(dictionary=True)
        cursor.execute("SELECT * FROM usuarios WHERE username = %s", (credentials.username,))
        user = cursor.fetchone()
        
        if user is None:
            return {"message": "El usuario no existe"}

        # Verificar la contraseña usando MD5
        hashed_input_password = hash_password_md5(credentials.password)
        if hashed_input_password == user["hashed_password"]:
            return {"token": user["token"]}
        else:
            return {"message": "Error en la contraseña"}
        
    except Exception as e:
        print(f"Error interno: {e}")
        return {"error": str(e)}
    finally:
        if connection:
            cursor.close()
            connection.close()

@app.get("/", status_code=status.HTTP_202_ACCEPTED)
async def read_root(credentials: HTTPAuthorizationCredentials = Depends(securityBearer)):
    token = credentials.credentials
    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)
    cursor.execute("SELECT * FROM usuarios WHERE token = %s", (token,))
    user = cursor.fetchone()
    
    if user:
        return {"mensaje": f"Bienvenido {user['full_name']}"}
    else:
        return {"mensaje": "MMM algo fallo"}
