.section .data

pf: .string "\n--------LIST-------\n"
pf1: .string "%d-> "
pf2: .string "[BEG]-> "
pf3: .string "[END]\n"
pf4: .string "\nEMPTY LIST\n"
pf5: .string "ADDRESS = %lu\n"
pf6: .string "\ninsertAfter ERR:DATA NOT FOUND"
pf7: .string "\ninsertBefore ERR:DATA NOT FOUND"

.section .text

.globl createList
.type createList,@function
createList:			#createList(int**p)
pushl %ebp
movl %esp,%ebp
subl $40,%esp

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

movl %ebp,%esp
popl %ebp
ret


.type insertAfter, @function
.globl insertAfter
insertAfter:			#insertAfter(struct node *pList,int eData,int nData)
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

movl -4(%ebp),%ecx 			#ecx=curr
movl 4(%ecx),%edx			#edx=ecx->next
movl %edx,4(%eax)			#new_node->next=edx
movl %eax,4(%ecx)			#ecx->next=new_node
jmp end3

cont:
movl 4(%ecx),%ecx
movl %ecx,-4(%ebp)
while4:
cmpl $0,%ecx
jne body4

pushl $pf6
call puts
addl $4,%esp

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
insertBefore:					#insertBefore(struct node* pList,int eData,int nData)
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

movl -4(%ebp),%ecx
movl 4(%ecx),%edx
movl %edx,4(%eax)
movl %eax,4(%ecx)

jmp end4
cont1:
movl 4(%ecx),%ecx
movl %ecx,-4(%ebp)
movl 4(%ecx),%edx
while5:
cmpl $0,%edx
jne body5

pushl $pf7
call puts
addl $4,%esp

jmp end4
empty4:
pushl $pf4
call puts
addl $4,%esp

end4:
movl %ebp,%esp
popl %ebp
ret
.globl delBeg
.type delBeg,@function
delBeg:						#delBeg(struct node *pList)
pushl %ebp
movl %esp,%ebp
subl $8,%esp

movl 8(%ebp),%ecx
movl 4(%ecx),%ecx 		#ecx=pList->link

cmpl $0,%ecx
je empty1

movl 8(%ebp),%ecx

pushl 4(%ecx)
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


.globl delLast
.type delLast,@function
delLast:
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

pushl %ecx
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



.globl showList
.type showList,@function
showList:
pushl %ebp
movl %esp,%ebp
subl $4,%esp


movl 8(%ebp),%ebx 		#ebx=pList
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
empty:
pushl $pf4
call printf
addl $4,%esp			#printing empty and return

end:movl %ebp,%esp
popl %ebp
ret


.globl destroy
.type destroy,@function
destroy:
pushl %ebp
movl %esp,%ebp
subl $40,%esp

movl 8(%ebp),%ebx 	#ebx=plist
movl 4(%ebx),%ecx	#ecx=pList
movl %ecx,-4(%ebp)	#next=pList->link
movl $0,4(%ebx)

movl $0,-8(%ebp)

jmp while1
body1:
movl -4(%ebp),%ebx
movl %ebx,-8(%ebp)		#prev=next

movl 4(%ebx),%ecx
movl %ecx,-4(%ebp)		#next=next->link

pushl -8(%ebp)
call free
addl $4,%esp

while1:cmpl $0,-4(%ebp)	#next!=0
jne body1

movl %ebp,%esp
popl %ebp
ret




#-------------------------------AUXILLIARY ROUTINES-------------------------

.type genericInsert, @function
.globl genericInsert								#8offset		#12offset
genericInsert:				#genericInsert(struct node *beg_node,struct node *after_node)
pushl %ebp
movl %esp,%ebp

movl 8(%ebp),%eax		#eax=beg_node
movl 12(%ebp),%ecx		#ecx=after_node
movl 4(%eax),%eax		#eax=eax->next i.e beg_node->next
movl %eax,4(%ecx)		#ecx->next=eax i.e after_node-next
movl 8(%ebp),%eax 		#eax=beg_node
movl %ecx,4(%eax)		#eax->next i.e beg_node->next=ecx i.e after_node


movl %ebp,%esp
popl %ebp
ret

.type genericDelete, @function
.globl genericDelete								#8offset			#12offset
genericDelete:				#genericDelete(struct node *beg_node,struct node*after_node)
pushl %ebp
movl %esp,%ebp


movl 8(%ebp),%eax 			#eax=beg_node
movl 12(%ebp),%ecx 			#ecx=after_node
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
call malloc			#8bytes allocate
addl $4,%esp


movl 8(%ebp),%ecx
movl %ecx,(%eax)		#p->data=dat
movl $0,4(%eax)			#p->next=0


movl %ebp,%esp
popl %ebp
ret

