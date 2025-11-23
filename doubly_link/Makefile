dll: client.o dll_lib.o
	ld --dynamic-linker /lib/ld-linux.so.2 -lc -o dll client.o dll_lib.o -e main
client.o: client.S
	as -o client.o client.S
dll_lib.o: dll_lib.S
	as -o dll_lib.o dll_lib.S
