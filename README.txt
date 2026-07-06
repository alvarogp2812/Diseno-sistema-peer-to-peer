Para ejecutar las pruebas debemos tener: 
- Una terminal donde ejecutaremos el WebService mediante: python datetime_service.py 
Una terminal donde ejecutaremos MAKE para la compilación del código, export  LOG_RPC_IP=localhost para la variable de entorno y posteriormente ./server <port>
Una terminal donde después del MAKE ejecutaremos ./servidor-rpc
Una terminal donde ejecutaremos el cliente mediante python client.py -s <ip> -p <port> 
Si se quieren ejecutar los test en vez del cliente se hará python test_n_client.py -s <ip> -p <port> siendo n el número del test deseado el port debe ser el mismo que el del servidor