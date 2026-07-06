================================================================
 Sistemas Distribuidos - Proyecto Final
 Diseño e implementación de un sistema peer-to-peer (P2P)
 Grupo ARCOS - Álvaro García Piqueras (100495760) / Mario Collazo Naranjo (100495949)
================================================================

--------------------------------
1. REQUISITOS PREVIOS
--------------------------------
- Sistema operativo UNIX/Linux (probado en guernika.lab.inf.uc3m.es)
- gcc y make
- Librería tirpc (paquete libtirpc-dev / instalada en guernika)
- Python 3 con las siguientes dependencias:
    pip install zeep

--------------------------------
2. ARCHIVOS DEL PROYECTO
--------------------------------
  Makefile              Compila el servidor (server) y el servidor RPC (servidor-rpc)
  server.c              Servidor central (sockets TCP)
  claves.c / claves.h   Gestión de usuarios y ficheros
  lines.c / lines.h     Funciones auxiliares de envío/recepción por socket
  log.x                 Interfaz RPC (rpcgen)
  log.h                 Cabecera generada por rpcgen a partir de log.x
  log_clnt.c            Stub cliente RPC (generado por rpcgen)
  log_svc.c             Esqueleto servidor RPC (generado por rpcgen -M)
  log_xdr.c             Serialización XDR (generado por rpcgen)
  servidor-rpc.c        Implementación del servicio RPC (registrar_op_1_svc)
  client.py             Cliente P2P (Python)
  datetime_service.py   Servicio web SOAP (fecha y hora)
  autores.txt           Autores de la práctica
  memoria.pdf           Memoria de la práctica

--------------------------------
3. COMPILACIÓN
--------------------------------
Desde el directorio del proyecto, ejecutar:

    $ make

Esto generará dos ejecutables:
  - server          (servidor central de la parte 1/2)
  - servidor-rpc    (servidor RPC de la parte 3)

Nota: log.h, log_clnt.c, log_xdr.c y log_svc.c ya están generados a partir
de log.x mediante "rpcgen -M log.x". No es necesario regenerarlos, pero si
se desea volver a generarlos hay que tener en cuenta que log_svc.c fue
modificado manualmente para gestionar la liberación de memoria
(operacionlog_1_freeresult), ya que rpcgen -M no la implementa
automáticamente.

Para limpiar los binarios compilados:

    $ make clean

--------------------------------
4. ORDEN DE EJECUCIÓN
--------------------------------
Se necesitan 4 terminales (o 4 máquinas distintas):

1) Servicio web (fecha y hora), en la máquina donde se ejecute cada cliente:

    $ python3 datetime_service.py

   El servicio queda escuchando en http://127.0.0.1:8000

2) Servidor RPC (registro de operaciones):

    $ ./servidor-rpc

3) Servidor central. Antes de lanzarlo hay que definir la variable de
   entorno LOG_RPC_IP con la IP o nombre de la máquina donde se ejecuta
   servidor-rpc:

    $ export LOG_RPC_IP=localhost
    $ ./server <puerto>

   Ejemplo:

    $ export LOG_RPC_IP=localhost
    $ ./server 5000

4) Cliente(s):

    $ python3 client.py -s <ip_servidor> -p <puerto_servidor>

   Ejemplo (servidor en local, puerto 5000):

    $ python3 client.py -s localhost -p 5000

--------------------------------
5. USO DEL CLIENTE
--------------------------------
Una vez lanzado el cliente aparece el prompt:

    c>

Comandos disponibles:

    REGISTER <user_name>
    UNREGISTER <user_name>
    CONNECT <user_name>
    DISCONNECT <user_name>
    PUBLISH <file_name> <description>
    DELETE <file_name>
    LIST_USERS
    LIST_CONTENT <user_name>
    GET_FILE <user_name> <remote_file_name> <local_file_name>
    QUIT

QUIT desconecta automáticamente al usuario (si estaba conectado) antes de
cerrar el cliente.

--------------------------------
6. NOTAS
--------------------------------
- Cada máquina cliente debe tener su propio servicio web (datetime_service.py)
  desplegado en local, en el puerto 8000.
- Todos los componentes (cliente, servidor, servidor-rpc, servicio web) pueden
  ejecutarse en máquinas distintas; basta con indicar las IP/puertos correctos
  en la variable LOG_RPC_IP y en los parámetros -s/-p del cliente.
- El servidor central finaliza al recibir SIGINT (Ctrl+C).
