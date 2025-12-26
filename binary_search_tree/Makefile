bst: client.o bst.o
	ld --dynamic-linker /lib/ld-linux.so.2 -lc -o bst client.o bst.o -e main
client.o: client.S
	as -o client.o client.S

bst.o: bst.S
	as -o bst.o bst.S

