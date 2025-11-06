.section .rodata
str1:
    .string "[BEG]->"
str2:
    .string "[%d]->"
str3:
    .string "[END]"

mem_err:
    .string "ERROR IN MEMORY ALLOCATION"

.globl addr
addr:
    .string "addr: %p\n"
.globl value
value:
    .string "value: %d\n"

.equ SUCCESS,0
.equ LIST_DATA_NOT_FOUND,1
.equ LIST_EMPTY,2

.equ TRUE,1
.equ FALSE, 0


.section .text

.globl createList
.type createList, @function
createList:
    pushl %ebp
    movl %esp, %ebp
    subl $4, %esp

    movl $0, -4(%ebp)

    pushl $-1
    call getNode
    addl $4,%esp

    movl %eax, -4(%ebp)
    movl -4(%ebp), %ebx
    movl %ebx, 4(%ebx)

    movl 8(%ebp), %ecx
    movl %ebx,(%ecx)


    movl %ebp, %esp
    popl %ebp
    ret

.globl insertStart
.type insertStart, @function
insertStart:
    pushl %ebp
    movl %esp,%ebp
    
    pushl 12(%ebp)
    call getNode
    addl $4,%esp
    
    movl 8(%ebp),%ebx

    pushl 4(%ebx)
    pushl %eax
    pushl 8(%ebp)
    call genericInsert
    addl $12, %esp

    movl $SUCCESS, %eax
    movl %ebp,%esp
    popl %ebp
    ret

.globl insertEnd
.type insertEnd, @function
insertEnd:
    pushl %ebp
    movl %esp, %ebp
    subl $4,%esp

    pushl $0
    pushl 8(%ebp)
    call getLastNode
    addl $8,%esp
    
    movl %eax, -4(%ebp)
    
    pushl 12(%ebp)
    call getNode
    addl $4,%esp

    pushl 8(%ebp)
    pushl %eax
    pushl -4(%ebp)
    call genericInsert
    addl $12,%esp

    movl $SUCCESS,%eax
    movl %ebp, %esp
    popl %ebp
    ret

.globl insertAfter
.type insertAfter, @function
insertAfter:
    pushl %ebp
    movl %esp, %ebp
    subl $4, %esp
    
    movl $0, -4(%ebp)               # existing_node
    
    pushl $0
    pushl 12(%ebp)
    pushl 8(%ebp)
    call searchNode
    addl $12, %esp

    movl $LIST_DATA_NOT_FOUND, %ecx
    cmpl $0,%eax
    cmovz %ecx, %eax
    je iAend

    movl %eax, -4(%ebp)

    pushl 16(%ebp)
    call getNode
    addl $4,%esp

    movl -4(%ebp), %ebx
    movl 4(%ebx), %ecx

    pushl %ecx
    pushl %eax
    pushl %ebx
    call genericInsert
    addl $12,%esp
    
    movl $SUCCESS, %eax
iAend:
    movl %ebp,%esp
    popl %ebp
    ret

.globl insertBefore
.type insertBefore, @function
insertBefore:
    pushl %ebp
    movl %esp,%ebp
    subl $8,%esp

    leal -8(%ebp), %ebx

    pushl %ebx
    pushl 12(%ebp)
    pushl 8(%ebp)
    call searchNode
    addl $12,%esp

    movl $LIST_DATA_NOT_FOUND, %ecx
    cmpl $0,%eax
    cmovz %ecx,%eax
    je iBend

    movl %eax, -4(%ebp)

    pushl 16(%ebp)
    call getNode
    addl $4,%esp

    pushl -4(%ebp)
    pushl %eax
    pushl -8(%ebp)
    call genericInsert
    addl $12, %esp

    movl $SUCCESS, %eax
iBend: 
    movl %ebp,%esp
    popl %ebp
    ret

.globl getStart
.type getStart, @function
getStart:
    pushl %ebp
    movl %esp, %ebp

    pushl 8(%ebp)
    call isEmpty
    addl $4,%esp
    
    movl $LIST_EMPTY, %ecx
    cmpl $TRUE, %eax
    cmovz %ecx, %eax 
    je gSend

    movl 12(%ebp), %ecx
    movl 8(%ebp), %ebx
    movl 4(%ebx), %ebx
    movl (%ebx), %ebx
    movl %ebx, (%ecx)
    
    movl $SUCCESS, %eax
gSend:
    movl %ebp, %esp
    popl %ebp
    ret

.globl getEnd
.type getEnd, @function
getEnd:
    pushl %ebp
    movl %esp, %ebp
    subl $4, %esp

    pushl 8(%ebp)
    call isEmpty
    addl $4,%esp
    
    movl $LIST_EMPTY, %ecx
    cmpl $TRUE, %eax
    cmovz %ecx, %eax
    je gEend

    pushl $0
    pushl 8(%ebp)
    call getLastNode
    addl $8,%esp

    movl %eax, -4(%ebp)
    movl (%eax), %ebx
    movl 12(%ebp), %ecx
    movl %ebx, (%ecx)

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
    
    pushl 8(%ebp)
    call isEmpty
    addl $4,%esp

    movl $LIST_EMPTY, %ecx
    cmpl $TRUE, %eax
    cmovz %ecx, %eax
    je pSend

    movl 12(%ebp),%ecx
    movl 8(%ebp), %ebx
    movl 4(%ebx), %ebx
    movl (%ebx), %ebx
    movl %ebx, (%ecx)
    
    movl 8(%ebp), %ebx
    movl 4(%ebx), %ebx
    
    pushl 8(%ebp)
    pushl %ebx
    call genericDelete
    addl $8,%esp
    
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
    subl $8,%esp

    pushl 8(%ebp)
    call isEmpty
    addl $4,%esp

    movl $LIST_EMPTY, %ecx
    cmpl $TRUE, %eax
    cmovz %ecx, %eax
    je pEend

    leal -8(%ebp),%ebx
    pushl %ebx
    pushl 8(%ebp)
    call getLastNode
    addl $8,%esp

    movl %eax, -4(%ebp)
    
    movl 12(%ebp), %ecx
    movl -4(%ebp), %ebx
    movl (%ebx), %ebx
    movl %ebx, (%ecx)

    pushl -8(%ebp)
    pushl -4(%ebp)
    call genericDelete
    addl $8,%esp

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
    addl $4,%esp

    movl $LIST_EMPTY, %ecx
    cmpl $TRUE, %eax
    cmovz %ecx, %eax
    je rSend

    movl 8(%ebp), %ebx
    pushl 8(%ebp)
    pushl 4(%ebx)
    call genericDelete
    addl $8,%esp
    
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
    subl $8,%esp

    pushl 8(%ebp)
    call isEmpty
    addl $8,%esp
    
    movl $LIST_EMPTY, %ecx
    cmpl $TRUE, %eax
    cmovz %ecx, %eax
    je rEend

    leal -8(%ebp), %ebx
    pushl %ebx
    pushl 8(%ebp)
    call getLastNode
    addl $8,%esp
    
    movl %eax, -4(%ebp)
    pushl -8(%ebp)
    pushl -4(%ebp)
    call genericDelete
    addl $8,%esp
    
    movl $SUCCESS, %eax
rEend:
    movl %ebp, %esp
    popl %ebp
    ret

.globl removeData
.type removeData, @function
removeData:
    pushl %ebp
    movl %esp, %ebp
    subl $8,%esp
    
    pushl 8(%ebp)
    call isEmpty
    addl $4, %esp

    movl $LIST_EMPTY, %ecx
    cmpl $TRUE, %eax
    cmovz %ecx, %eax
    je rDend

    leal -8(%ebp), %ebx
    pushl %ebx
    pushl 12(%ebp)
    pushl 8(%ebp)
    call searchNode
    addl $12,%esp

    movl %eax, -4(%ebp)
    
    movl $LIST_DATA_NOT_FOUND, %ecx
    cmpl $0, %eax
    cmovz %ecx, %eax
    je rDend
    
    pushl -8(%ebp)
    pushl -4(%ebp)
    call genericDelete
    addl $8,%esp
    
    movl $SUCCESS, %eax
rDend:
    movl %ebp, %esp
    popl %ebp
    ret

.globl addList
.type addList, @function
addList:
    pushl %ebp
    movl %esp, %ebp
    subl $8, %esp
    
    movl $0, -4(%ebp)               #p_run
    movl $0, -8(%ebp)               #p_list3
    
    leal -8(%ebp), %ebx
    pushl %ebx
    call createList
    addl $4,%esp
    
    movl 8(%ebp), %ebx
    movl 4(%ebx), %ebx
    movl %ebx, -4(%ebp)

aLcnd1:
    movl -4(%ebp), %ebx
    cmpl 8(%ebp), %ebx
    je aLend1
    
    movl -4(%ebp), %ebx
    pushl (%ebx)
    pushl -8(%ebp)
    call insertEnd
    addl $8,%esp

    movl -4(%ebp), %ebx
    movl 4(%ebx), %ebx
    movl %ebx, -4(%ebp)

    jmp aLcnd1

aLend1:
    
    movl 12(%ebp), %ebx
    movl 4(%ebx), %ebx
    movl %ebx, -4(%ebp)

aLcnd2:
    movl -4(%ebp), %ebx
    cmpl 12(%ebp), %ebx
    je aLend2

    movl -4(%ebp), %ebx
    pushl (%ebx)
    pushl -8(%ebp)
    call insertEnd
    addl $8,%esp

    movl -4(%ebp), %ebx
    movl 4(%ebx) , %ebx
    movl %ebx, -4(%ebp)
    jmp aLcnd2

aLend2:
    
    movl -8(%ebp), %eax

    movl %ebp, %esp
    popl %ebp
    ret

.globl concatList
.type concatList, @function
concatList:
    pushl %ebp
    movl %esp,%ebp
    subl $8, %esp
    
    movl $0, -4(%ebp)
    movl $0, -8(%ebp)

    movl 8(%ebp), %ebx
    movl 4(%ebx), %ebx
    movl %ebx, -4(%ebp)

cLcnd1:
    movl -4(%ebp), %ebx
    movl 4(%ebx), %ebx
    cmpl 8(%ebp), %ebx
    je cLend1

    movl %ebx, -4(%ebp)
    jmp cLcnd1
cLend1:
    
    movl 12(%ebp), %ebx
    movl 4(%ebx), %ebx
    movl %ebx, -8(%ebp)

cLcnd2:
    movl -8(%ebp), %ebx
    movl 4(%ebx), %ebx
    cmpl 12(%ebp), %ebx
    je cLend2

    movl %ebx, -8(%ebp)
    jmp cLcnd2
cLend2:

    movl 12(%ebp), %ebx
    movl 4(%ebx), %ebx
    cmpl 12(%ebp), %ebx
    je cLend3

    movl -4(%ebp), %ecx
    movl %ebx, 4(%ecx)

    movl 8(%ebp), %ebx
    movl -8(%ebp), %ecx
    movl %ebx, 4(%ecx)
cLend3:

    pushl 12(%ebp)
    call free
    addl $4,%esp

    movl $SUCCESS,%eax
    movl %ebp, %esp
    popl %ebp
    ret

.globl mergeList
.type mergeList, @function
mergeList:
    pushl %ebp
    movl %esp, %ebp
    subl $12,%esp

    movl $0, -4(%ebp)      #p_list3
    movl $0, -8(%ebp)      #p_run1
    movl $0, -12(%ebp)     #p_run2

    leal -4(%ebp), %ebx
    pushl %ebx
    call createList
    addl $4,%esp

    movl 8(%ebp), %ebx
    movl 4(%ebx), %ebx
    movl %ebx, -8(%ebp)

    movl 12(%ebp), %ebx
    movl 4(%ebx), %ebx
    movl %ebx, -12(%ebp)

mLcnd1:
    movl -8(%ebp),%ebx
    cmpl %ebx, 8(%ebp)
    jne mLcnd2
mLcnd11:
    movl -12(%ebp), %ebx
    cmpl %ebx, 12(%ebp) 
    je mLcndend1
    pushl (%ebx)
    pushl -4(%ebp)
    call insertEnd
    addl $8,%esp

    movl -12(%ebp), %ebx
    movl 4(%ebx), %ebx
    movl %ebx, -12(%ebp)
    jmp mLcnd11

mLcnd2:
    movl -12(%ebp), %ebx
    cmpl %ebx, 12(%ebp)
    jne mLcnd3
mLcnd21:
    movl -8(%ebp), %ebx
    cmpl %ebx, 8(%ebp)
    je mLcndend1
    pushl (%ebx)
    pushl -4(%ebp)
    call insertEnd
    addl $8,%esp

    movl -8(%ebp), %ebx
    movl 4(%ebx), %ebx
    movl %ebx, -8(%ebp)
    jmp mLcnd21

mLcnd3:
    movl -8(%ebp), %ebx
    movl -12(%ebp), %ecx
    movl (%ebx), %ebx
    cmpl (%ecx), %ebx
    jge mLcnd4
    pushl %ebx
    pushl -4(%ebp)
    call insertEnd
    addl $8,%esp

    movl -8(%ebp), %ebx
    movl 4(%ebx), %ebx
    movl %ebx, -8(%ebp)
    jmp  mLcnd1
mLcnd4:
    pushl (%ecx)
    pushl -4(%ebp)
    call insertEnd
    addl $8,%esp

    movl -12(%ebp), %ebx
    movl 4(%ebx), %ebx
    movl %ebx, -12(%ebp)
    jmp mLcnd1
mLcndend1:

    movl -4(%ebp), %eax
    
    movl %ebp, %esp
    popl %ebp
    ret

.globl getReversedList
.type getReversedList, @function
getReversedList:
    pushl %ebp
    movl %esp, %ebp
    subl $8, %esp
    
    movl $0, -4(%ebp)
    movl $0, -8(%ebp)

    leal -8(%ebp), %ebx
    pushl %ebx
    call createList
    addl $4,%esp

    movl 8(%ebp), %ebx
    movl 4(%ebx), %ebx
    movl %ebx, -4(%ebp)

    
gRLcnd1:
    movl -4(%ebp), %ebx
    cmpl 8(%ebp), %ebx
    je gRLend1

    movl -4(%ebp), %ebx

    pushl (%ebx)
    pushl -8(%ebp)
    call insertStart
    addl $8,%esp

    movl -4(%ebp), %ebx
    movl 4(%ebx), %ebx
    movl %ebx, -4(%ebp)
    jmp gRLcnd1
gRLend1:

    movl -8(%ebp), %eax

    movl %ebp,%esp
    popl %ebp
    ret

.globl reverseList
.type reverseList, @function
reverseList:
    pushl %ebp
    movl %esp, %ebp
    subl $12, %esp
    
    movl $0, -4(%ebp)
    movl $0, -8(%ebp)
    movl $0, -12(%ebp)

    pushl 8(%ebp)
    call isEmpty
    addl $4,%esp

    movl $LIST_EMPTY, %ecx
    cmpl $TRUE, %eax
    cmove %ecx, %eax
    je rLend

    movl 8(%ebp), %ebx
    movl 4(%ebx), %ebx
    movl %ebx, -4(%ebp)

    movl 8(%ebp), %ebx
    movl %ebx, -8(%ebp)

    movl -4(%ebp), %ebx
    movl 4(%ebx), %ebx
    movl %ebx, -12(%ebp)

rLcnd1:
    movl -4(%ebp), %ebx
    cmpl 8(%ebp), %ebx
    je rLloopend1

    movl -8(%ebp), %ecx
    movl -4(%ebp), %ebx
    movl %ecx, 4(%ebx)

    movl -4(%ebp), %ebx
    movl %ebx, -8(%ebp)

    movl -12(%ebp), %edx
    movl %edx, -4(%ebp) 

    movl -4(%ebp), %ebx
    movl 4(%ebx), %ebx
    movl %ebx, -12(%ebp)
    jmp rLcnd1

rLloopend1:
    movl -8(%ebp), %ecx
    movl 8(%ebp), %ebx
    movl %ecx, 4(%ebx)

    movl $SUCCESS, %eax

rLend:
    movl %ebp, %esp
    popl %ebp
    ret

.globl isEmpty
.type isEmpty, @function
isEmpty:
    pushl %ebp
    movl %esp, %ebp
    
    movl $FALSE, %eax
    movl $TRUE, %ecx
    movl 8(%ebp), %ebx
    cmpl %ebx, 4(%ebx)
    cmovz %ecx ,%eax

    movl %ebp, %esp
    popl %ebp
    ret

.globl destroyList
.type destroyList, @function
destroyList:
    pushl %ebp
    movl %esp,%ebp
    subl $8,%esp

    movl $0, -4(%esp)	    #p_list= NULL
    movl $0, -8(%esp)	    #p_run = NULL
    
    cmpl $0, 8(%ebp)
    je dLend

    movl 8(%ebp), %ebx
    cmpl $0, (%ebx)
    je dLend

    movl 8(%ebp), %ebx
    movl (%ebx), %ebx
    movl %ebx, -4(%ebp)

dLcnd1:
    movl -4(%ebp), %ebx
    cmpl 4(%ebx), %ebx
    cmpl %ebx, -4(%ebp)
    je dLloopend1
    
    movl %ebx, -8(%ebp)
    movl 4(%ebx), %ebx
    movl -4(%ebp), %ecx
    movl %ebx, 4(%ecx)
    
    pushl -8(%ebp)
    call free
    addl $4,%esp
    jmp dLcnd1
dLloopend1:
    
    pushl -4(%ebp)
    call free
    addl $4,%esp
    
    movl 8(%ebp), %ebx
    movl $0, (%ebx)

dLend:
    movl %ebp,%esp
    popl %ebp
    ret

.globl getNode
.type getNode, @function
getNode:
    pushl %ebp
    movl %esp, %ebp
    subl $4,%esp

    pushl $8
    call xmalloc
    addl $4, %esp
    

    movl %eax, -4(%ebp)
    movl 8(%ebp), %ecx
    movl -4(%ebp), %ebx
    movl %ecx,(%ebx)

    movl -4(%ebp), %eax

    movl %ebp, %esp
    popl %ebp
    ret


.globl xmalloc
.type xmalloc, @function
xmalloc:
    pushl %ebp
    movl %esp, %ebp
    subl $4, %esp

    movl $0,-4(%ebp)

    pushl 8(%ebp)
    call malloc
    addl $4,%esp
    
    movl %eax,-4(%ebp)
    cmp $0,%eax
    jne xmif1
    pushl $mem_err
    call puts
    addl $4,%esp

    movl $1,%ebx
    movl $1,%eax
    int $0x80

xmif1:
    movl -4(%ebp), %eax
    movl %ebp,%esp
    popl %ebp
    ret

.globl showList
.type showList, @function
showList:
    pushl %ebp
    movl %esp, %ebp
    subl $4,%esp

    movl $0, -4(%ebp)       #p_run

    cmpl $0, 12(%ebp)
    je if1
    pushl 12(%ebp)
    call puts
    addl $4,%esp

if1:
    pushl $str1
    call printf
    addl $4,%esp

    movl 8(%ebp), %ebx
    movl 4(%ebx), %ecx
    movl %ecx, -4(%ebp)

sLcnd1:
    movl 8(%ebp),%ebx
    cmpl %ebx, -4(%ebp)
    je sLloopend1
    
    movl -4(%ebp), %ebx

    pushl (%ebx)
    pushl $str2
    call printf
    addl $8, %esp

    movl -4(%ebp), %ebx
    movl 4(%ebx), %ebx
    movl %ebx, -4(%ebp)

    jmp sLcnd1
sLloopend1:

    pushl $str3
    call puts
    addl $4,%esp

    movl %ebp, %esp
    popl %ebp
    ret

.globl getLastNode
.type getLastNode, @function
getLastNode:
    pushl %ebp
    movl %esp, %ebp
    subl $8, %esp
    
    movl 8(%ebp), %ebx
    movl 4(%ebx), %ecx
    movl %ecx, -4(%ebp)       #p_run
    movl %ebx, -8(%ebp)       #p_run_prev

gLNcnd1:
    movl -4(%ebp), %ebx
    movl 4(%ebx), %ebx
    cmpl 8(%ebp), %ebx
    je gLNloopend1

    movl -4(%ebp), %ebx
    movl %ebx, -8(%ebp)

    movl 4(%ebx), %ebx
    movl %ebx, -4(%ebp)
    
    jmp gLNcnd1
gLNloopend1:

    cmpl $0, 12(%ebp)
    je gLNif1
    movl -8(%ebp), %ebx
    movl 12(%ebp), %ecx
    movl %ebx, (%ecx)

gLNif1:
    movl -4(%ebp), %eax
 
    movl %ebp, %esp
    popl %ebp
    ret

.globl searchNode
.type searchNode, @function
searchNode:
    pushl %ebp
    movl %esp, %ebp
    subl $8, %esp

    movl $0, -4(%ebp)           # p_run
    movl $0, -8(%ebp)           # p_run_prev

    movl 8(%ebp), %ebx
    movl 4(%ebx), %ecx
    movl %ecx, -4(%ebp)
    movl %ebx, -8(%ebp)


sNcond1:
    movl -4(%ebp), %ebx
    cmpl 8(%ebp), %ebx
    je sNloopend1
    movl (%ebx),%ecx
    cmpl 12(%ebp), %ecx
    je sNloopend1

    movl %ebx, -8(%ebp)
    movl 4(%ebx),%ebx
    movl %ebx, -4(%ebp)
    jmp sNcond1
sNloopend1:
    
    cmpl $0, 16(%ebp)
    je sNifend1
    
    movl 16(%ebp), %ebx
    movl -8(%ebp), %ecx
    movl %ecx, (%ebx)

sNifend1:
    movl -4(%ebp), %ebx
    xorl %eax,%eax
    cmpl 8(%ebp), %ebx
    cmovne %ebx, %eax

    movl %ebp,%esp
    popl %ebp
    ret

.globl genericInsert
.type genericInsert, @function
genericInsert:
    pushl %ebp
    movl %esp,%ebp
    
    movl 8(%ebp), %ebx
    movl 12(%ebp), %ecx
    
    movl %ecx,4(%ebx)

    movl 16(%ebp), %ebx
    movl %ebx, 4(%ecx)

    movl %ebp,%esp
    popl %ebp
    ret


.globl genericDelete
.type genericDelete, @function
genericDelete:
    pushl %ebp
    movl %esp, %ebp
    
    movl 12(%ebp), %ecx
    movl 8(%ebp), %ebx
    movl 4(%ebx), %ebx
    movl %ebx, 4(%ecx)

    pushl 8(%ebp)
    call free
    movl $0, 8(%ebp)

    movl %ebp, %esp
    popl %ebp
    ret

