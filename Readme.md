
# DSA_through_assembly

### implementing Data structures using assembly language AT&T syntax on Linux 4\.15\.0-142-generic \#146\~16\.04\.1-Ubuntu SMP Tue Apr 13 09:26:57 UTC 2021 i686 GNU/Linux   
### intel i386 32-bit architechture  

---
## Build Process
##### Assemble using 'as' 
`as -o custom_object_filename.o assembly_filename.s`

##### Link command if not C library function is used  
`ld -o custom_executable.out object_filename.o `  

##### Link command if C library function is used  
`ld -dynamic-linker /lib/ld-linux.so.2 -lc -o executable_file object_file1.o object_file2.o -e main `  
-e main specifies main is entry point label  
-o tells ld to generate executable as given by user not default by linking all further object files  
-lc tells ld to find dynamic\(runtime\) library file /lib/libc.so where c in -l\(c\) and c in lib\(c\) gets matched   
-dynamic-linker this parameter is not necessary if your dynamic library is loaded in memory but most of the times this wont't happen we have to explicitly load it but by specifying -dynamic-linker you tell ld that "I will provide a program after the -dynamic-linker flag that will load C dynamic library" 

---

### List of Data Structures implemented till now  
1. Doubly Circular LinkedList\([client_code](https://github.com/vivekbmraut/AssemblyDSA/blob/master/dll.s) / [server_code](https://github.com/vivekbmraut/AssemblyDSA/blob/master/dllLib.s)\)
2. Singly LinkedList\([client_code](https://github.com/vivekbmraut/AssemblyDSA/Singly_Circular/blob/master/sll.s) / [server_code](https://github.com/vivekbmraut/AssemblyDSA/Singly_Circular/blob/master/sllLib.s)\)
