.section .rodata
ismsg1:
    .string "INSERT START"
iemsg1:
    .string "INSERT END"
iamsg1:
    .string "INSERT AFTER"
ibmsg1:
    .string "INSERT 200 BEFORE 1"
gsmsg1:
    .string "START DATA: %d\n"
gsmsg2:
    .string "AFTER GET_START NO CHANGE"
gemsg1:
    .string "END DATA: %d\n"
gemsg2:
    .string "AFTER GET_END NO CHANGE"
psmsg1:
    .string "POP_START DATA: %d\n"
psmsg2:
    .string "AFTER POP_START"
pemsg1:
    .string "POP_END DATA: %d\n"
pemsg2:
    .string "AFTER POP_END"
rsmsg1:
    .string "AFTER REMOVE_START"
remsg1:
    .string "AFTER REMOVE_END"
rdmsg1:
    .string "AFTER REMOVE_DATA 200"
listmsg1:
    .string "LIST_1:"
listmsg2:
    .string "LIST_2:"
listmsg3:
    .string "LIST_3 Concat List: "
listmsg4:
    .string "LIST append to LIST3:"
listmsg5:
    .string "Reversed list of LIST3 is LIST: "
listmsg6:
    .string "LIST3 Reversed: "

.section .text

.globl main
.type main, @function
main:
    pushl %ebp
    movl %esp, %ebp
    subl $24, %esp

    movl $0, -4(%ebp)           # p_list = NULL
    movl $0, -8(%ebp)           # i = 0
    movl $0, -12(%ebp)           # data = 0
    movl $0, -16(%ebp)		# plist_1 = NULL
    movl $0, -20(%ebp)		# plist_2 = NULL
    movl $0, -24(%ebp)		# plist_3 = NULL

    leal -4(%ebp), %ebx
    pushl %ebx
    call createList
    addl $4,%esp

mcnd1:
    cmpl $5, -8(%ebp)
    jge mforend1
    
    movl -8(%ebp), %ebx
    addl $1, %ebx
    pushl %ebx
    pushl -4(%ebp)
    call insertStart
    addl $8,%esp

    addl $1, -8(%ebp)
    jmp mcnd1
mforend1:

    pushl $ismsg1
    pushl -4(%ebp)
    call showList
    addl $8,%esp

    pushl $100
    pushl -4(%ebp)
    call insertEnd
    addl $8,%esp

    pushl $iemsg1
    pushl -4(%ebp)
    call showList
    addl $8,%esp

    pushl $300
    pushl $1
    pushl -4(%ebp)
    call insertAfter
    addl $12,%esp

    pushl $iamsg1
    pushl -4(%ebp)
    call showList
    addl $8, %esp

    pushl $200
    pushl $1
    pushl -4(%ebp)
    call insertBefore
    addl $12,%esp

    pushl $ibmsg1
    pushl -4(%ebp)
    call showList
    addl $8, %esp

    leal -12(%ebp), %ebx
    pushl %ebx
    pushl -4(%ebp)
    call getStart
    addl $4,%esp

    pushl -12(%ebp)
    pushl $gsmsg1
    call printf
    addl $8,%esp

    pushl $gsmsg2
    pushl -4(%ebp)
    call showList
    addl $8, %esp

    leal -12(%ebp), %ebx
    pushl %ebx
    pushl -4(%ebp)
    call getEnd
    addl $4,%esp

    pushl -12(%ebp)
    pushl $gemsg1
    call printf
    addl $8,%esp

    pushl $gemsg2
    pushl -4(%ebp)
    call showList
    addl $8, %esp

    leal -12(%ebp), %ebx
    pushl %ebx
    pushl -4(%ebp)
    call popStart
    addl $8,%esp

    pushl -12(%ebp)
    pushl $psmsg1
    call printf
    addl $8,%esp

    pushl $psmsg2
    pushl -4(%ebp)
    call showList
    addl $8,%esp

    leal -12(%ebp), %ebx
    pushl %ebx
    pushl -4(%ebp)
    call popEnd
    addl $8,%esp

    pushl -12(%ebp)
    pushl $pemsg1
    call printf
    addl $8,%esp

    pushl $pemsg2
    pushl -4(%ebp)
    call showList
    addl $8,%esp

    pushl -4(%ebp)
    call removeStart
    addl $4,%esp

    pushl $rsmsg1
    pushl -4(%ebp)
    call showList
    addl $8,%esp

    pushl -4(%ebp)
    call removeEnd
    addl $4,%esp

    pushl $remsg1
    pushl -4(%ebp)
    call showList
    addl $8,%esp

    pushl $200
    pushl -4(%ebp)
    call removeData
    addl $8,%esp

    pushl $rdmsg1
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

    pushl $50
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

    pushl $listmsg1
    pushl -16(%ebp)
    call showList
    addl $8, %esp


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

    pushl $listmsg2
    pushl -20(%ebp)
    call showList
    addl $8, %esp

    pushl -20(%ebp)
    pushl -16(%ebp)
    call concatList
    addl $8,%esp

    movl %eax, -24(%ebp)
    
    pushl $listmsg3
    pushl -24(%ebp)
    call showList
    addl $8,%esp

    pushl -4(%ebp)
    pushl -24(%ebp)
    call appendList
    addl $8,%esp

    movl $0, -4(%ebp)
    
    pushl $listmsg4
    pushl -24(%ebp)
    call showList
    addl $8,%esp

    pushl -24(%ebp)
    call getReversedList
    addl $4,%esp
    movl %eax, -4(%ebp)

    pushl $listmsg5
    pushl -4(%ebp)
    call showList
    addl $8,%esp

    pushl -24(%ebp)
    call reverseList
    addl $4,%esp

    pushl $listmsg6
    pushl -24(%ebp)
    call showList
    addl $8,%esp

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

    movl $0,%ebx
    movl $1,%eax
    int $0x80

