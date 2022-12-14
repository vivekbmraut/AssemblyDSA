.section .data
pfdump: .string "\nDUMP"
pf: .string "\n--------LIST-------\n"
pf1: .string "%d-> "
pf2: .string "[BEG]-> "
pf3: .string "[END]\n"
pf4: .string "\nEMPTY LIST\n"
pf5: .string "Uninitialized List"

.section .text

.globl createList
.type createList,@function
createList:			#createList(int**p)
pushl %ebp
movl %esp,%ebp


pushl $0
call getNode
addl $4,%esp

movl 8(%ebp),%ebx			#ebx=*p
movl %eax,(%ebx)			#(ebx)=*p=eax

# movl -4(%ebp),%ebx 		#ebx=p

movl %ebp,%esp
popl %ebp
ret



.globl insertBeg
.type insertBeg,@function
insertBeg:
pushl %ebp
movl %esp,%ebp
subl $8,%esp

pushl 12(%ebp)				#sending DATA
call getNode
addl $4,%esp

movl %eax,-4(%ebp)			#*p=getNode(data);

pushl -4(%ebp)
pushl 8(%ebp)
call genericInsert
addl $4,%esp

movl %ebp,%esp
popl %ebp
ret


.globl insertLast
.type insertLast,@function 	#insertLast(*plist,data)
insertLast:
pushl %ebp
movl %esp,%ebp
subl $4,%esp

movl 8(%ebp),%ebx
movl 4(%ebx),%ebx

test %ebx,%ebx
jnz nempt
pushl 12(%ebp)
call getNode
addl $4,%esp

pushl %eax
pushl 8(%ebp)
call genericInsert
addl $8,%esp

jmp end0

nempt:
movl %ebx,-4(%ebp)		#next=pList->link

movl -4(%ebp),%ecx
movl 4(%ecx),%ecx		#ecx=next->link

jmp while2
body2:

movl %ecx,-4(%ebp)		#next=next->link
movl -4(%ebp),%ecx
movl 4(%ecx),%ecx		#ecx=next->link

while2:cmpl $0,%ecx		#next->link!=NULL
jne body2

pushl 12(%ebp)
call getNode
addl $4,%esp

pushl %eax
pushl -4(%ebp)
call genericInsert
addl $4,%esp

end0:
movl %ebp,%esp
popl %ebp
ret


.type insertAfter, @function
.globl insertAfter
insertAfter:			#bool insertAfter(struct node *pList,int eData,int nData)
pushl %ebp
movl %esp,%ebp
subl $4,%esp

movl 8(%ebp),%ecx 
movl 4(%ecx),%ecx

cmpl $0,%ecx
je empty3

movl %ecx,-4(%ebp)
jmp while4
body4:
movl (%ecx),%edx
cmpl 12(%ebp),%edx
jne cont
pushl 16(%ebp)
call getNode
addl $4,%esp

pushl %eax
pushl -4(%ebp)
call genericInsert
addl $8,%esp 
movl $1,%eax 				#return true
jmp end3

cont:
movl 4(%ecx),%ecx
movl %ecx,-4(%ebp)
while4:
cmpl $0,%ecx
jne body4

movl $0,%eax 				#return false
jmp end3
empty3:
pushl $pf4
call puts
addl $4,%esp

end3:
movl %ebp,%esp
popl %ebp
ret


.type insertBefore, @function
.globl insertBefore
insertBefore:			#bool insertBefore(struct node* pList,int eData,int nData)
pushl %ebp
movl %esp,%ebp
subl $4,%esp

movl 8(%ebp),%ecx
movl 4(%ecx),%edx

cmpl $0,%edx
je empty4

movl %ecx,-4(%ebp)
jmp while5
body5:
movl (%edx),%edx
cmpl 12(%ebp),%edx
jne cont1
pushl 16(%ebp)
call getNode
addl $4,%esp

pushl %eax
pushl -4(%ebp)
call genericInsert
addl $8,%esp
movl $1,%eax 			#return true
jmp end4
cont1:
movl 4(%ecx),%ecx
movl %ecx,-4(%ebp)
movl 4(%ecx),%edx
while5:
cmpl $0,%edx
jne body5

movl $0,%eax 			#return false

jmp end4
empty4:
pushl $pf4
call puts
addl $4,%esp

end4:
movl %ebp,%esp
popl %ebp
ret






.globl removeBeg
.type removeBeg,@function
removeBeg:						#removeBeg(struct node *pList)
pushl %ebp
movl %esp,%ebp
subl $8,%esp

movl 8(%ebp),%ecx
movl 4(%ecx),%ecx 		#ecx=pList->link

cmpl $0,%ecx
je empty1

movl 8(%ebp),%ecx

pushl %ecx
call genericDelete
addl $8,%esp

jmp end1

empty1:
pushl $pf4
call printf
addl $4,%esp

end1:movl %ebp,%esp
popl %ebp
ret


.globl removeLast
.type removeLast,@function
removeLast:
pushl %ebp
movl %esp,%ebp
subl $12,%esp

movl 8(%ebp),%edx
movl 4(%edx),%ecx

cmpl $0,%ecx
je empty2

#prev is edx
#next is ecx

movl 4(%ecx),%eax
jmp while3
body3:
movl %ecx,%edx
movl 4(%ecx),%ecx

movl 4(%ecx),%eax
while3:
cmpl $0,%eax
jne body3


pushl %edx
call genericDelete
addl $8,%esp

jmp end2

empty2:
pushl $pf4
call puts
addl $4,%esp

end2:
movl %ebp,%esp
popl %ebp
ret


.type removeData, @function
.globl removeData
removeData:							#bool removeData(struct node* pList,int data)
pushl %ebp 
movl %esp,%ebp

movl 8(%ebp),%ecx
movl 4(%ecx),%edx

cmpl $0,%edx
je empty5


jmp while6
body6:
movl (%edx),%edx
cmpl 12(%ebp),%edx
jne cont2

pushl %ecx
call genericDelete
addl $4,%esp

movl $1,%eax
jmp end5

cont2:
movl 4(%ecx),%ecx
movl 4(%ecx),%edx
while6:
cmpl $0,%edx
jne body6

movl $0,%eax
jmp end5
empty5:
pushl $pf4
call puts
addl $4,%esp

end5:
movl %ebp,%esp
popl %ebp
ret


.type getLength,@function
.globl getLength
getLength:			#int getLength(struct node *pList)
pushl %ebp
movl %esp,%ebp

movl 8(%ebp),%edx
movl 4(%edx),%edx

xorl %eax,%eax
jmp while9
body9:
addl $1,%eax
movl 4(%edx),%edx

while9:
cmpl $0,%edx
jne body9


movl %ebp,%esp
popl %ebp
ret



.globl showList
.type showList,@function
showList:
pushl %ebp
movl %esp,%ebp
subl $4,%esp


movl 8(%ebp),%ebx 		#ebx=pList
test %ebx,%ebx
jz unin

movl 4(%ebx),%edx		#edx=pList->link
movl %edx,-4(%ebp)		#next=pList->link

cmpl $0,%edx			#if(next==NULL) return
je empty


pushl $pf2
call printf
addl $4,%esp


jmp while
body:

movl -4(%ebp),%ebx 		#ebx=p
pushl (%ebx)			#ebx->data
pushl $pf1				#%d->
call printf
addl $8,%esp


movl -4(%ebp),%ebx
movl 4(%ebx),%edx
movl %edx,-4(%ebp)		#next=next->link
while:
cmpl $0,-4(%ebp) #next!=0
jne body

pushl $pf3
call printf
addl $4,%esp


jmp end
unin:
pushl $pf5
call puts
addl $4,%esp
jmp end
empty:
pushl $pf4
call printf
addl $4,%esp				#printing empty and return

end:movl %ebp,%esp
popl %ebp
ret

.type concatLists,@function
.globl concatLists				#list* concatList(list* plist1,list* plist2)
concatLists:
pushl %ebp
movl %esp,%ebp
subl $8,%esp

leal -4(%ebp),%ecx
pushl %ecx
call createList
addl $4,%esp

movl 8(%ebp),%ecx 		#ecx=plist1
movl 4(%ecx),%ecx 		#ecx=ecx->next=plist1->next
movl %ecx,-8(%ebp)		#p_run=ecx

jmp while12
body12:
pushl (%ecx)
pushl -4(%ebp)
call insertLast
addl $8,%esp

movl -8(%ebp),%ecx
movl 4(%ecx),%ecx
movl %ecx,-8(%ebp)

while12:cmpl $0,%ecx
jne body12

movl 12(%ebp),%ecx
movl 4(%ecx),%ecx
movl %ecx,-8(%ebp)

jmp while13
body13:
pushl (%ecx)
pushl -4(%ebp)
call insertLast
addl $8,%esp

movl -8(%ebp),%ecx
movl 4(%ecx),%ecx
movl %ecx,-8(%ebp)

while13:cmpl $0,%ecx
jne body13

movl -4(%ebp),%eax

movl %ebp,%esp
pop %ebp
ret




.type listToArray,@function
.globl listToArray
listToArray:					#listToArray(struct node *pList,int **arr,int *size)
pushl %ebp
movl %esp,%ebp
subl $8,%esp
pushl %ebx

pushl 8(%ebp)
call getLength
addl $4,%esp

movl %eax,-4(%ebp)		#length

sall $2,%eax
pushl %eax
call malloc
addl $4,%esp

movl %eax,-8(%ebp)		#array

movl 8(%ebp),%ecx
movl 4(%ecx),%ecx
movl $0,%edx

jmp while10
body10:

movl -8(%ebp),%eax
movl (%ecx),%ebx
movl %ebx,(%eax,%edx,4)

movl 4(%ecx),%ecx
addl $1,%edx
while10:
cmpl $0,%ecx
jne body10

movl 12(%ebp),%ecx
movl -8(%ebp),%edx
movl %edx,(%ecx)

movl 16(%ebp),%ecx
movl -4(%ebp),%edx
movl %edx,(%ecx)

movl $1,%eax

popl %ebx
movl %ebp,%esp
popl %ebp
ret


.type arrayToList, @function
.globl arrayToList
arrayToList:		#struct node *arrayToList(int *p,int size)
pushl %ebp
movl %esp,%ebp
subl $8,%esp

leal -4(%ebp),%ecx
pushl %ecx
call createList
addl $4,%esp


movl $0,%ecx
movl %ecx,-8(%ebp)
jmp while11
body11:
movl 8(%ebp),%edx

pushl (%edx,%ecx,4)
pushl -4(%ebp)
call insertLast
addl $4,%esp

addl $1,-8(%ebp)
movl -8(%ebp),%ecx

while11:cmpl 12(%ebp),%ecx
jl body11

movl -4(%ebp),%eax

movl %ebp,%esp
popl %ebp
ret


.type appendList,@function
.globl appendList
appendList:					#appendList(struct node *plist1,struct node *plist2)
pushl %ebp
movl %esp,%ebp

movl 8(%ebp),%ecx

jmp while8
body8:
movl 4(%ecx),%ecx
while8:
movl 4(%ecx),%edx
cmpl $0,%edx
jne body8

movl 12(%ebp),%eax
movl 4(%eax),%eax
movl %eax,4(%ecx)

pushl 12(%ebp)
call free
addl $4,%esp

movl %ebp,%esp
popl %ebp
ret



.type reverseList,@function
.globl reverseList
reverseList:				#reverseList(struct node* pList)
pushl %ebp
movl %esp,%ebp

movl $0,%eax 				#p1=eax
movl 8(%ebp),%edx
movl 4(%edx),%edx			#p3=edx

test %edx,%edx
jz empty6
movl %edx,%ecx 				#p2=ecx

jmp while7
body7:
movl 4(%edx),%edx

movl %eax,4(%ecx)
movl %ecx,%eax
movl %edx,%ecx

while7:
cmpl $0,%ecx
jne body7

movl 8(%ebp),%ecx
movl %eax,4(%ecx)
jmp end6

empty6:
pushl $pf4
call puts
addl $4,%esp

end6:
movl %ebp,%esp
pop %ebp
ret



.globl destroy
.type destroy,@function
destroy:
pushl %ebp
movl %esp,%ebp
subl $40,%esp

movl 8(%ebp),%ebx 			#ebx=plist
movl (%ebx),%ebx 			#ebx=*plist
movl 4(%ebx),%ecx			#ecx=pList
movl %ecx,-4(%ebp)			#next=pList->link
movl $0,4(%ebx)

movl $0,-8(%ebp)

jmp while1
body1:
movl -4(%ebp),%ebx
movl %ebx,-8(%ebp)			#prev=next

movl 4(%ebx),%ecx
movl %ecx,-4(%ebp)			#next=next->link

pushl -8(%ebp)
call free
addl $4,%esp

while1:cmpl $0,-4(%ebp)		#next!=0
jne body1

movl 8(%ebp),%ebx
movl $0,(%ebx)

movl %ebp,%esp
popl %ebp
ret




#-------------------------------AUXILLIARY ROUTINES-------------------------

.type genericInsert, @function
.globl genericInsert								#8offset		#12offset
genericInsert:				#genericInsert(struct node *beg_node,struct node *mid_node)
pushl %ebp
movl %esp,%ebp

movl 8(%ebp),%eax			#eax=beg_node
movl 12(%ebp),%ecx			#ecx=after_node
movl 4(%eax),%eax			#eax=eax->next i.e beg_node->next
movl %eax,4(%ecx)			#ecx->next=eax i.e mid_node-next
movl 8(%ebp),%eax 			#eax=beg_node
movl %ecx,4(%eax)			#eax->next i.e beg_node->next=ecx i.e mid_node


movl %ebp,%esp
popl %ebp
ret


.type genericDelete, @function
.globl genericDelete
genericDelete:				#genericDelete(struct node *beg_node)
pushl %ebp
movl %esp,%ebp


movl 8(%ebp),%eax 			#eax=beg_node
movl 4(%eax),%ecx 			#ecx=after_node
movl 4(%ecx),%edx			#edx=after_node->next
movl %edx,4(%eax)			#eax->next=edx
movl $0,4(%ecx)				#after_node->next=0

pushl %ecx
call free
addl $4,%esp


movl %ebp,%esp
popl %ebp
ret


.globl getNode
.type getNode,@function
getNode:
pushl %ebp
movl %esp,%ebp
subl $4,%esp

pushl $8
call malloc				#8bytes allocate
addl $4,%esp


movl 8(%ebp),%ecx
movl %ecx,(%eax)		#p->data=dat
movl $0,4(%eax)			#p->next=0


movl %ebp,%esp
popl %ebp
ret

