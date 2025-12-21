.section .rodata

xmmsg1:
    .string "ERROR MEMORY ALLOCATION"
slmsg1:
    .string "[BEG]<->"
slmsg2:
    .string "[END]"
slmsg3:
    .string "[%d]<->"

.section .text
.equ SUCCESS,1
.equ LIST_EMPTY,2
.equ LIST_DATA_NOT_FOUND,3

.equ TRUE, 1
.equ FALSE, 0

.globl createList
.type createList, @function
createList:                                        # prototype: void createList(struct node** pp_list)
    pushl %ebp
    movl %esp, %ebp
    subl $4,%esp
    
    movl $0,-4(%ebp)

    pushl $-1
    call getNode
    addl $4,%esp

    movl %eax, -4(%ebp)

    movl 8(%ebp), %ebx
    movl %eax, (%ebx)

    movl %ebp, %esp
    popl %ebp
    ret

.globl destroyList
.type destroyList, @function
destroyList:                                #protoype: void destroyList(struct node** pp_list)
    pushl %ebp
    movl %esp, %ebp
    subl $12, %esp

    movl $0, -4(%ebp)
    movl $0, -8(%ebp)
    movl $0, -12(%ebp)

    cmpl $0, 8(%ebp)
    je dLend
    
    movl 8(%ebp), %ebx
    movl (%ebx), %ebx
    movl %ebx, -4(%ebp)

    movl %ebx, -8(%ebp)

dLcnd1:
    cmpl $0, -8(%ebp)
    je dLwhileend1
    movl -8(%ebp), %ebx
    movl 8(%ebx), %ebx
    movl %ebx, -12(%ebp)

    pushl -8(%ebp)
    call free
    addl $4,%esp

    movl -12(%ebp), %ebx
    movl %ebx, -8(%ebp)
    jmp dLcnd1

dLwhileend1:
    movl 8(%ebp), %ebx
    movl $0, (%ebx)
dLend:
    movl %ebp, %esp
    popl %ebp
    ret

.globl insertStart
.type insertStart, @function
insertStart:                                   #prototype: int insertStart(struct node* p_list, int new_data)
    pushl %ebp
    movl %esp, %ebp
    
    pushl 12(%ebp)
    call getNode
    addl $4,%esp

    movl 8(%ebp), %ebx

    pushl 8(%ebx)
    pushl %eax
    pushl %ebx
    call genericInsert
    addl $12,%esp

    movl $SUCCESS, %eax

    movl %ebp, %esp
    popl %ebp
    ret

.globl insertEnd
.type insertEnd, @function
insertEnd:
    pushl %ebp
    movl %esp, %ebp
    subl $4, %esp

    movl $0, -4(%ebp)

    pushl 8(%ebp)
    call getLastNode
    addl $4,%esp

    movl %eax, -4(%ebp)

    pushl 12(%ebp)
    call getNode
    addl $4,%esp

    pushl $0
    pushl %eax
    pushl -4(%ebp)
    call genericInsert
    addl $12, %esp

    movl $SUCCESS, %eax

    movl %ebp, %esp
    popl %ebp
    ret

.globl insertAfter
.type insertAfter, @function
insertAfter:
    pushl %ebp
    movl %esp, %ebp
    subl $4, %esp
    movl $0, -4(%ebp)

    pushl 8(%ebp)
    call isEmpty
    addl $4,%esp

    movl $LIST_EMPTY, %ecx
    cmpl $TRUE, %eax
    cmove %ecx, %eax
    je iAend

    pushl 12(%ebp)
    pushl 8(%ebp)
    call searchNode
    addl $8,%esp

    movl %eax, -4(%ebp)
    movl $LIST_DATA_NOT_FOUND, %ecx
    cmpl $0, -4(%ebp)
    cmove %ecx, %eax
    je iAend

    pushl 16(%ebp)
    call getNode
    addl $4,%esp

    movl -4(%ebp), %ebx

    pushl 8(%ebx)
    pushl %eax
    pushl %ebx
    call genericInsert
    addl $12, %esp

    movl $SUCCESS, %eax

iAend:
    movl %ebp, %esp
    popl %ebp
    ret

.globl insertBefore
.type insertBefore, @function
insertBefore:
    pushl %ebp
    movl %esp, %ebp
    subl $4,%esp

    movl $0, -4(%ebp)


    pushl 12(%ebp)
    pushl 8(%ebp)
    call searchNode
    addl $8,%esp

    movl %eax, -4(%ebp)

    movl $LIST_DATA_NOT_FOUND, %ecx
    cmpl $0, -4(%ebp)
    cmove %ecx, %eax
    je iBend

    pushl 16(%ebp)
    call getNode
    addl $4,%esp

    movl -4(%ebp), %ebx
    pushl %ebx
    pushl %eax
    pushl 4(%ebx)
    call genericInsert
    addl $12, %esp

    movl $SUCCESS, %eax
iBend:
    movl %ebp, %esp
    popl %ebp
    ret

.globl getStart
.type getStart ,@function        #prototype: int getStart(struct node* p_list, int* start_data)
getStart:
    pushl %ebp
    movl %esp, %ebp

    pushl 8(%ebp)
    call isEmpty
    addl $4,%esp

    movl $LIST_EMPTY, %ecx
    cmpl $TRUE,%eax
    cmove %ecx, %eax
    je gSend
   
    movl 8(%ebx), %ebx
    movl 12(%ebp), %ecx
    movl (%ebx), %edx
    movl %edx, (%ecx)
    movl $SUCCESS, %eax

gSend:    
    movl %esp, %ebp
    popl %ebp
    ret

.globl getEnd
.type getEnd, @function
getEnd:
    pushl %ebp
    movl %esp, %ebp
    subl $4, %esp
    
    movl $0, -4(%ebp)

    pushl 8(%ebp)
    call isEmpty
    addl $4,%esp

    movl $LIST_EMPTY, %ecx
    cmpl $TRUE, %eax
    cmove %ecx, %eax
    je gEend

    pushl 8(%ebp)
    call getLastNode
    addl $4,%esp

    movl %eax, -4(%ebp)

    movl -4(%ebp), %ebx
    movl 12(%ebp), %ecx
    movl (%ebx), %edx
    movl %edx, (%ecx)
    movl $SUCCESS, %eax

gEend:
    movl %ebp, %esp
    popl %ebp
    ret

.globl popStart
.type popStart, @function
popStart:
    pushl %ebp
    movl %esp, %ebp
    subl $4,%esp
    
    movl $0, -4(%ebp)

    pushl 8(%ebp)
    call isEmpty
    addl $4,%esp

    movl $LIST_EMPTY, %ecx
    cmpl $TRUE, %eax
    cmove %ecx, %eax
    je pSend 
    

    movl 8(%ebp), %ebx
    movl 8(%ebx), %ebx 
    movl %ebx, -4(%ebp)

    movl 12(%ebp), %edx
    movl (%ebx), %ebx
    movl %ebx, (%edx)

    pushl -4(%ebp)
    call genericDelete
    addl $4,%esp
    
    movl $SUCCESS, %eax
pSend:
    movl %ebp, %esp
    popl %ebp
    ret

.globl popEnd
.type popEnd, @function
popEnd:
    pushl %ebp
    movl %esp, %ebp
    subl $4,%esp
    
    movl $0, -4(%ebp)

    pushl 8(%ebp)
    call isEmpty
    addl $4,%esp

    movl $LIST_EMPTY, %ecx
    cmpl $TRUE, %eax
    cmove %ecx, %eax
    je pEend

    pushl 8(%ebp)
    call getLastNode
    addl $4,%esp
    movl %eax, -4(%ebp)

    cmpl 8(%ebp), %eax
    je pEend
    
    movl 12(%ebp), %edx
    movl -4(%ebp), %ebx
    movl (%ebx), %ebx
    movl %ebx, (%edx)

    pushl -4(%ebp)
    call genericDelete
    addl $4,%esp

    movl $SUCCESS, %eax
pEend:
    movl %ebp, %esp
    popl %ebp
    ret

.globl removeStart
.type removeStart, @function
removeStart:
    pushl %ebp
    movl %esp, %ebp
    
    pushl 8(%ebp)
    call isEmpty
    addl $4, %esp

    movl $LIST_EMPTY, %ecx
    cmpl $TRUE, %eax
    cmove %ecx, %eax
    je rSend
    
    movl 8(%ebp), %ebx
    pushl 8(%ebx)
    call genericDelete
    addl $4,%esp
    
    movl $SUCCESS, %eax
rSend:
    movl %ebp, %esp
    popl %ebp
    ret

.globl removeEnd
.type removeEnd, @function
removeEnd:
    pushl %ebp
    movl %esp, %ebp
    subl $4,%esp

    movl $0, -4(%ebp)

    pushl 8(%ebp)
    call isEmpty
    addl $4,%esp
    
    movl $LIST_EMPTY, %ecx
    cmpl $TRUE, %eax
    cmove %ecx, %eax
    je rEend

    pushl 8(%ebp)
    call getLastNode
    addl $4,%esp

    movl %eax, -4(%ebp)
    
    cmpl 8(%ebp), %eax
    je rEend
    
    pushl -4(%ebp)
    call genericDelete
    addl $4,%esp
    
    movl $SUCCESS, %eax
rEend:
    movl %ebp, %esp
    popl %ebp
    ret

.globl removeData
.type removeData, @function
removeData:
    pushl %ebp
    movl %esp,%ebp
    subl $4,%esp
    
    movl $0, -4(%ebp)
    
    pushl 12(%ebp)
    pushl 8(%ebp)
    call searchNode
    addl $8,%esp
    
    movl %eax, -4(%ebp)

    movl $LIST_DATA_NOT_FOUND, %ecx
    cmpl $0, %eax
    cmove %ecx, %eax
    je rDend

    pushl -4(%ebp)
    call genericDelete
    addl $4,%esp
    
rDend:
    movl %ebp, %esp
    popl %ebp
    ret

.globl getLastNode
.type getLastNode, @function
getLastNode:
    pushl %ebp
    movl %esp, %ebp
    subl $4, %esp

    movl $0, -4(%ebp)

    movl 8(%ebp), %ebx
    movl %ebx, -4(%ebp)

gLNcnd1:
    movl -4(%ebp), %ebx
    cmpl $0, 8(%ebx)
    je gLNend1
    
    movl 8(%ebx), %ebx
    movl %ebx, -4(%ebp)
    jmp gLNcnd1

gLNend1:
    movl -4(%ebp), %eax

    movl %ebp, %esp
    popl %ebp
    ret

.globl isEmpty
.type isEmpty, @function
isEmpty:
    pushl %ebp
    movl %esp, %ebp
    
    movl 8(%ebp), %ebx
    cmpl $0, 8(%ebx)
    je iEifend1
    cmpl $0, 4(%ebx)
    je iEifend1
    movl $TRUE , %eax
    jmp iEend

iEifend1:
    movl $FALSE, %eax

iEend:
    movl %ebp, %esp
    popl %ebp
    ret

.globl genericInsert
.type genericInsert, @function
genericInsert:                     #prototype: void genericInsert(struct node* beg, struct node* mid, struct node* end)
    pushl %ebp
    movl %esp, %ebp
    
    movl 8(%ebp), %ebx
    movl 12(%ebp), %ecx
    movl 16(%ebp), %edx

    movl %ecx,8(%ebx)
    movl %edx, 8(%ecx)

    cmpl $0, %edx
    je giifend1
    movl %ecx, 4(%edx)
giifend1:
    movl %ebx, 4(%ecx)

    movl %ebp, %esp
    popl %ebp
    ret

.globl genericDelete
.type genericDelete, @function
genericDelete:		    #prototype: void genericDelete(struct node* del_node)
    pushl %ebp
    movl %esp, %ebp
    
    movl 8(%ebp), %ebx
    movl 8(%ebx), %ecx
    movl 4(%ebx), %edx
    movl %ecx, 8(%edx)

    cmpl $0, %ecx
    je gDifend1
    movl %edx,4(%ecx)
gDifend1:

    pushl 8(%ebp)
    call free
    addl $4,%esp

    movl %ebp, %esp
    popl %ebp
    ret
    

.globl searchNode
.type searchNode, @function
searchNode:
    pushl %ebp
    movl %esp, %ebp
    subl $4,%esp

    movl $0, -4(%ebp)
    movl 8(%ebp), %ebx
    movl 8(%ebx), %ebx
    movl %ebx, -4(%ebp)

sNcnd1:
    cmpl $0, -4(%ebp)
    je sNloopend1
    movl -4(%ebp), %ebx
    movl (%ebx), %ecx
    cmpl 12(%ebp), %ecx
    je sNloopend1

    movl 8(%ebx), %ebx
    movl %ebx, -4(%ebp)
    jmp sNcnd1

sNloopend1:
    movl -4(%ebp), %eax

    movl %ebp, %esp
    popl %ebp
    ret


.globl showList
.type showList, @function
showList:                                 #prototype: void showList(struct node* p_list, const char* msg)
    pushl %ebp
    movl %esp, %ebp
    subl $4,%esp

    movl $0,-4(%ebp)

    cmpl $0, 12(%ebp)
    je sLifend1
    pushl 12(%ebp)
    call puts
    add $4,%esp

sLifend1:
    pushl $slmsg1
    call printf
    addl $4,%esp
    
    movl 8(%ebp), %ebx
    movl 8(%ebx), %ebx
    movl %ebx, -4(%ebp)

sLcnd1:
    cmpl $0,-4(%ebp)
    je sLwhileend1
    
    movl -4(%ebp), %ebx
    
    pushl (%ebx)
    pushl $slmsg3
    call printf
    addl $8,%esp
    

    movl -4(%ebp),%ebx
    movl 8(%ebx), %ebx
    movl %ebx, -4(%ebp)
    jmp sLcnd1

sLwhileend1:
    
    pushl $slmsg2
    call puts
    addl $4,%esp

    movl %ebp, %esp
    popl %ebp
    ret

.globl getNode
.type getNode, @function
getNode:                                    #prototype: struct node* getNode(int new_data)
    pushl %ebp
    movl %esp, %ebp
    subl $4,%esp
    
    movl $0,-4(%ebp)
    
    pushl $12
    call xmalloc
    addl $4,%esp
    
    movl %eax, -4(%ebp)

    movl -4(%ebp), %ebx
    movl 8(%ebp), %edx

    movl %edx,(%ebx)
    movl $0, 4(%ebx)
    movl $0, 8(%ebx)

    movl -4(%ebp), %eax

    movl %ebp, %esp
    popl %ebp
    ret

.globl xmalloc
.type xmalloc, @function
xmalloc:                                     #prototype: void* xmalloc(unsigned long size)
    pushl %ebp
    movl %esp, %ebp
    subl $4,%esp

    movl $0,-4(%ebp)

    pushl 8(%ebp)
    call malloc
    addl $4,%esp

    movl %eax, -4(%ebp)
    cmpl $0, %eax
    jne xmallocend
    
    pushl $xmmsg1
    call puts
    addl $4,%esp

    pushl $-1
    call exit
    #not adding to esp as call won't return

xmallocend:
    movl -4(%ebp), %eax

    movl %ebp, %esp
    popl %ebp
    ret

