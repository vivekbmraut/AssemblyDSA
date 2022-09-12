.section .data
lf: .string "\nList1:\n"
lf1: .string "\nList after deletion Beg\n"
lf2: .string "\nList after destruction\n"
lf3: .string "\nList after insertion last\n"
lf4: .string "\nList after deletion last\n"
lf5: .string "\nList after insert after"
lf6: .string "\nList after insert before"
lf7: .string "\nList after remove Data"
lf8: .string "\nInsertAfter unsuccessful"
lf9: .string "\nInsertBefore unsuccessful"
lf10: .string "\nRemoveData unsuccessful"
lf11: .string "\nList Reversal"
lf12: .string "\nList2:"
lf13: .string "\nList1 after List2 append:"
lf14: .string "\nLength :%d\n"
lf15: .string "\n---------------Array----------------"
lf16: .string "%d  "
#pf1: .string "%d->\n"

.section .text

.globl main
.type main,@function
main:
pushl %ebp
movl %esp,%ebp
subl $40,%esp

#-4(%ebp)=plist
#-8(%ebp)=i
#-12(%ebp)=plist2
#-16(%ebp)=array
#-20(%ebp)=size

leal -4(%ebp),%ebx
pushl %ebx
call createList		#dummy NODE
addl $4,%esp


movl $1,-8(%ebp)
jmp for
body:

pushl -8(%ebp)
pushl -4(%ebp)
call insertBeg
addl $8,%esp

addl $1,-8(%ebp)

for:cmpl $5,-8(%ebp)
jle body

pushl $lf
call printf
addl $4,%esp

pushl -4(%ebp)
call showList
addl $4,%esp

pushl -4(%ebp)
call removeBeg		#delete ONE ELEMENT
addl $4,%esp

pushl $lf1
call printf
addl $4,%esp

pushl -4(%ebp)
call showList
addl $4,%esp


movl $1,-8(%ebp)
jmp for1
body1:

movl -8(%ebp),%ecx
addl $10,%ecx

pushl %ecx
pushl -4(%ebp)
call insertLast
addl $8,%esp

addl $1,-8(%ebp)

for1:cmpl $5,-8(%ebp)
jle body1

pushl $lf3
call printf
addl $4,%esp

pushl -4(%ebp)
call showList
addl $4,%esp

pushl $201
pushl $12
pushl -4(%ebp)
call insertAfter
addl $12,%esp

test %eax,%eax
jz err1
pushl $lf5
call puts
addl $4,%esp

pushl -4(%ebp)
call showList
addl $4,%esp
jmp scs1
err1:
pushl $lf8
call puts
addl $4,%esp

scs1:
pushl $200
pushl $201
pushl -4(%ebp)
call insertBefore
addl $12,%esp

test %eax,%eax
jz err2
pushl $lf6
call puts
addl $4,%esp

pushl -4(%ebp)
call showList
addl $4,%esp
jmp scs2

err2:
pushl $lf9
call puts
addl $4,%esp

scs2:
pushl -4(%ebp)
call reverseList
addl $4,%esp

pushl $lf11
call puts
addl $4,%esp

pushl -4(%ebp)
call showList
addl $4,%esp


pushl -4(%ebp)
call removeLast
addl $4,%esp


pushl $lf4
call printf
addl $4,%esp

pushl -4(%ebp)
call showList
addl $4,%esp


pushl $12
pushl -4(%ebp)
call removeData
addl $8,%esp

test %eax,%eax
jz err3
pushl $lf7
call puts
addl $4,%esp

pushl -4(%ebp)
call showList
addl $4,%esp
jmp scs3

err3:
pushl $lf10
call puts
addl $4,%esp

scs3:
leal -12(%ebp),%ecx
pushl %ecx
call createList
addl $4,%esp

movl $0,-8(%ebp)
jmp for2
body2:
movl -8(%ebp),%ecx
addl $100,%ecx 

pushl %ecx
pushl -12(%ebp)
call insertLast
addl $8,%esp

addl $1,-8(%ebp)

for2:cmpl $5,-8(%ebp)
jl body2

pushl $lf12
call puts
addl $4,%esp

pushl -12(%ebp)
call showList
addl $4,%esp

pushl -12(%ebp)
pushl -4(%ebp)
call appendList
addl $8,%esp

movl $0,-12(%ebp) 	#List2=NULL

pushl $lf13
call puts
addl $4,%esp

pushl -4(%ebp)
call showList
addl $4,%esp


leal -20(%ebp),%ecx
leal -16(%ebp),%edx
pushl %ecx
pushl %edx
pushl -4(%ebp)
call listToArray
addl $12,%esp

pushl $lf15
call puts
addl $4,%esp


movl $0,-8(%ebp)
movl $0,%ecx
jmp for3
body3:
movl -16(%ebp),%edx
pushl (%edx,%ecx,4)
pushl $lf16
call printf
addl $8,%esp

addl $1,-8(%ebp)
movl -8(%ebp),%ecx

for3:cmpl -20(%ebp),%ecx
jl body3

pushl -16(%ebp)
call free
addl $4,%esp
movl $0,-16(%ebp)

leal -4(%ebp),%ebx
pushl %ebx
call destroy
addl $4,%esp	

pushl $lf2
call printf
addl $4,%esp

pushl -4(%ebp)
call showList
addl $4,%esp


movl %ebp,%esp
popl %ebp
pushl $0
call exit

