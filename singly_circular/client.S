.section .rodata
success:
    .string "SUCCESS"
failure:
    .string "FAILURE"
ismsg:
    .string "Insert Start"
iemsg:
    .string "Insert End"
iamsg:
    .string "Insert After"
ibmsg:
    .string "Insert before"
gsmsg:
    .string "Start data: %d\n"
gemsg:
    .string "End data: %d\n"
psmsg:
    .string "After pop start"
psdata:
    .string "popStart data: %d\n"
pemsg:
    .string "After pop end"
pedata:
    .string "popEnd data: %d\n"
rsmsg:
    .string "After remove start"
remsg:
    .string "After remove end"
rdmsg:
    .string "After remove data: %d\n"
l1msg:
    .string "List1: "
l2msg:
    .string "List2: "
l3msg:
    .string "List3 Merged: "
rlmsg:
    .string "Reverse List: "
almsg:
    .string "After List1 append to List2: "
clmsg:
    .string "Concat List1 to List2: "
grlmsg:
    .string "Reversed List1"
lTAmsg:
    .string "list3 to array :"
p_arrmsg:
    .string "p_arr[%d]: %d\n"
parr_to_listmsg:
    .string "p_arr to list: "

.section .text
.globl main
.type main, @function

main:
    pushl %ebp
    movl %esp,%ebp
    subl $40,%esp

    movl $0,-4(%ebp)        #p_list
    movl $0,-8(%ebp)        #i
    movl $0,-12(%ebp)       #data
    movl $0, -16(%ebp)      #p_list1
    movl $0, -20(%ebp)      #p_list2
    movl $0, -24(%ebp)      #p_list3
    movl $0, -28(%ebp)      #p_list4
    movl $0, -32(%ebp)      #p_list5
    movl $0, -36(%ebp)      #p_arr
    movl $0, -40(%ebp)      #size

    leal -4(%ebp), %ebx
    pushl %ebx
    call createList
    addl $4,%esp

maincnd1:
    cmpl $5, -8(%ebp)
    jge mainloopend1
    
    movl -8(%ebp), %ecx
    
    addl $1, %ecx
    pushl %ecx
    pushl -4(%ebp)
    call insertStart
    addl $8,%esp

    addl $1, -8(%ebp)
    jmp maincnd1

mainloopend1:

    pushl $ismsg
    pushl -4(%ebp)
    call showList
    addl $8, %esp


    pushl $100
    pushl -4(%ebp)
    call insertEnd
    addl $8,%esp

    pushl $200
    pushl -4(%ebp)
    call insertEnd
    addl $8,%esp

    pushl $iemsg
    pushl -4(%ebp)
    call showList
    addl $8,%esp

    pushl $32
    pushl $100
    pushl -4(%ebp)
    call insertAfter
    addl $12,%esp

    pushl $iamsg
    pushl -4(%ebp)
    call showList
    addl $8,%esp
    
    pushl $54
    pushl $100
    pushl -4(%ebp)
    call insertBefore
    addl $12, %esp
    
    pushl $ibmsg
    pushl -4(%ebp)
    call showList
    addl $8,%esp
    
    leal -12(%ebp), %ebx
    pushl %ebx
    pushl -4(%ebp)
    call getStart
    addl $8, %esp

    pushl -12(%ebp)
    pushl $gsmsg
    call printf
    addl $8,%esp

    leal -12(%ebp), %ebx
    pushl %ebx
    pushl -4(%ebp)
    call getEnd
    addl $8,%esp

    pushl -12(%ebp)
    pushl $gemsg
    call printf
    addl $8,%esp

    leal -12(%ebp), %ebx
    pushl %ebx
    pushl -4(%ebp)
    call popStart
    addl $8,%esp

    pushl -12(%ebp)
    pushl $psdata
    call printf
    addl $8,%esp
    
    pushl $psmsg
    pushl -4(%ebp)
    call showList
    addl $8,%esp

    leal -12(%ebp), %ebx
    pushl %ebx
    pushl -4(%ebp)
    call popEnd
    addl $8,%esp

    pushl -12(%ebp)
    pushl $pedata
    call printf
    addl $8,%esp
    
    pushl $pemsg
    pushl -4(%ebp)
    call showList
    addl $8,%esp

    pushl -4(%ebp)
    call removeStart
    addl $4,%esp

    pushl $rsmsg
    pushl -4(%ebp)
    call showList
    addl $8, %esp

    pushl -4(%ebp)
    call removeEnd
    addl $4,%esp

    pushl $remsg
    pushl -4(%ebp)
    call showList
    addl $8,%esp

    pushl $54
    pushl -4(%ebp)
    call removeData
    addl $8,%esp

    pushl $54
    pushl $rdmsg
    call printf
    addl $8,%esp

    pushl $0
    pushl -4(%ebp)
    call showList
    addl $8,%esp

    leal -16(%ebp), %ebx
    pushl %ebx
    call createList
    addl $4,%esp

    leal -20(%ebp), %ebx
    pushl %ebx
    call createList
    addl $4,%esp

    pushl $60
    pushl -16(%ebp)
    call insertStart
    addl $8,%esp
    
    pushl $3
    pushl -16(%ebp)
    call insertStart
    addl $8,%esp

    pushl $2
    pushl -16(%ebp)
    call insertStart
    addl $8,%esp

    pushl $1
    pushl -16(%ebp)
    call insertStart
    addl $8,%esp


    pushl $24
    pushl -20(%ebp)
    call insertStart
    addl $8,%esp

    pushl $23
    pushl -20(%ebp)
    call insertStart
    addl $8,%esp

    pushl $22
    pushl -20(%ebp)
    call insertStart
    addl $8,%esp

    pushl $21
    pushl -20(%ebp)
    call insertStart
    addl $8,%esp

    pushl $l1msg
    pushl -16(%ebp)
    call showList
    addl $8,%esp

    pushl $l2msg
    pushl -20(%ebp)
    call showList
    addl $8,%esp

    pushl -20(%ebp)
    pushl -16(%ebp)
    call concatList
    addl $8,%esp

    movl %eax, -28(%ebp)

    pushl $clmsg
    pushl -28(%ebp)
    call showList
    addl $8,%esp

    pushl -20(%ebp)
    pushl -16(%ebp)
    call mergeList
    addl $8,%esp

    movl %eax, -24(%ebp)

    pushl $l3msg
    pushl -24(%ebp)
    call showList
    addl $8,%esp

    leal -40(%ebp), %ebx
    pushl %ebx
    leal -36(%ebp), %ebx
    pushl %ebx
    pushl -24(%ebp)
    call listToArray
    addl $12, %esp
    
    pushl $lTAmsg
    call puts
    addl $4,%esp

    movl $0, -8(%ebp)
maincnd2:
    movl -8(%ebp), %ecx
    cmpl -40(%ebp), %ecx
    jge mainloopend2
    
    movl -36(%ebp), %ebx
    pushl (%ebx, %ecx, 4)
    pushl %ecx
    pushl $p_arrmsg
    call printf
    addl $12,%esp

    movl -8(%ebp), %ecx
    addl $1,%ecx
    movl %ecx, -8(%ebp)
    jmp maincnd2
mainloopend2:

    pushl -20(%ebp)
    pushl -16(%ebp)
    call appendList
    addl $8,%esp

    movl $0, -20(%ebp)

    pushl -40(%ebp)
    pushl -36(%ebp)
    call arrayToList
    addl $8,%esp

    movl %eax, -20(%ebp)
    pushl $parr_to_listmsg
    pushl -20(%ebp)
    call showList
    addl $8,%esp

    pushl $almsg
    pushl -16(%ebp)
    call showList
    addl $8,%esp

    pushl -16(%ebp)
    call getReversedList
    addl $4,%esp

    movl %eax, -32(%ebp)

    pushl $grlmsg
    pushl -32(%ebp)
    call showList
    addl $8,%esp

    pushl -24(%ebp)
    call reverseList
    addl $4,%esp

    pushl $rlmsg
    pushl -24(%ebp)
    call showList
    addl $8,%esp

    pushl -36(%ebp)
    call free
    addl $4,%esp

    leal -32(%ebp), %ebx
    pushl %ebx
    call destroyList
    addl $4,%esp

    leal -28(%ebp), %ebx
    pushl %ebx
    call destroyList
    addl $4,%esp

    leal -24(%ebp), %ebx
    pushl %ebx
    call destroyList
    addl $4,%esp

    leal -20(%ebp), %ebx
    pushl %ebx
    call destroyList
    addl $4,%esp

    leal -16(%ebp), %ebx
    pushl %ebx
    call destroyList
    addl $4,%esp

    leal -4(%ebp), %ebx
    pushl %ebx
    call destroyList
    addl $4,%esp

    movl $failure, %ebx
    movl $success, %ecx
    cmpl $0,-4(%ebp)
    cmovz %ecx, %ebx
    
    pushl %ebx
    call puts
    addl $4,%esp
    
    movl $0,%ebx
    movl $1,%eax
    int $0x80

    movl %ebp,%esp
    popl %ebp
    ret
