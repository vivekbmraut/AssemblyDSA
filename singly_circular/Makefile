scll: client.o scll_lib.o
	ld -dynamic-linker /lib/ld-linux.so.2 -lc -o scll $^ -e main

client.o: client.S
	as -o client.o client.S

scll_lib.o: scll_lib.S
	as -o scll_lib.o scll_lib.S

clean:
	rm scll
