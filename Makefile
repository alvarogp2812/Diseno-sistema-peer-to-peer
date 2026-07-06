all: server servidor-rpc
CC=gcc

CFLAGS=-Wall -fPIC -g -I. -I/usr/include/tirpc
LDFLAGS=-ltirpc

server: server.c log_xdr.c log_clnt.c claves.c lines.c
	$(CC) $(CFLAGS) server.c log_xdr.c log_clnt.c claves.c lines.c -o server $(LDFLAGS) 

servidor-rpc: servidor-rpc.c log_xdr.c log_svc.c log.h
	$(CC) $(CFLAGS)  servidor-rpc.c log_xdr.c log_svc.c log.h -o servidor-rpc $(LDFLAGS) 

clean:
	rm -f *.o server servidor-rpc