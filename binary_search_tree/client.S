.section .rodata
successmsg:
	.string "SUCCESS"
failmsg:
	.string "FAILURE"
rnmsg:
	.string "After Removing %d\n"
insuccmsg:
	.string "INORDER SUCCESSOR of %d is %d\n"
innosuccmsg:
	.string "INORDER SUCCESSOR no Successor for %d\n"

.section .text
.equ BST_INVALID,0
.equ SUCCESS,1
.equ BST_EMPTY,2
.equ BST_DATA_NOT_FOUND,3
.equ BST_NO_PREDECESSOR,4
.equ BST_NO_SUCCESSOR,5

.equ NUM_OF_NODES,10

.globl main
.type main, @function
main:
	pushl %ebp
	movl %esp, %ebp
	subl $52, %esp

	movl $0, -4(%ebp)				# p_bst = NULL
	
	movl $100, -44(%ebp)		# node_arr
	movl $54, -40(%ebp)
	movl $115, -36(%ebp)
	movl $65, -32(%ebp)
	movl $120, -28(%ebp)
	movl $50, -24(%ebp)
	movl $112, -20(%ebp)
	movl $72, -16(%ebp)
	movl $130, -12(%ebp)
	movl $100, -8(%ebp)

	movl $0, -48(%ebp)				# i =0
	movl $0, -52(%ebp)				# succ_data = 0

	call createBst
	movl %eax, -4(%ebp)

	jmp mfor1cnd
mfor1body:
	movl -48(%ebp), %ecx

	pushl -44(%ebp, %ecx, 4)
	pushl -4(%ebp)
	call insert
	addl $8,%esp

	addl $1, -48(%ebp)

mfor1cnd:
	cmpl $NUM_OF_NODES, -48(%ebp)
	jl mfor1body

	pushl -4(%ebp)
	call inorder
	addl $4,%esp

	movl $0, -48(%ebp)
	jmp mfor3cnd
mfor3body:
	movl -48(%ebp), %ecx
	leal -52(%ebp), %ebx
	pushl %ebx
	pushl -44(%ebp,%ecx,4)
	pushl -4(%ebp)
	call inorderSuccessor
	addl $12,%esp

	cmpl $SUCCESS, %eax
	jne mif2
	movl -48(%ebp), %ecx
	pushl -52(%ebp)
	pushl -44(%ebp,%ecx,4)
	pushl $insuccmsg
	call printf
	addl $12, %esp
	jmp mfor3end

mif2:
	movl -48(%ebp), %ecx
	pushl -44(%ebp,%ecx,4)
	pushl $innosuccmsg
	call printf
	addl $12, %esp
mfor3end:
	addl $1,-48(%ebp)

mfor3cnd:
	cmpl $NUM_OF_NODES, -48(%ebp)
	jl mfor3body

	movl $0, -48(%ebp)
	jmp mfor2cnd
mfor2body:
	movl -48(%ebp), %ecx
	pushl -44(%ebp,%ecx,4)
	pushl -4(%ebp)
	call removeNode
	addl $8,%esp

	movl -48(%ebp), %ecx
	pushl -44(%ebp,%ecx,4)
	pushl $rnmsg
	call printf
	addl $8,%esp

	pushl -4(%ebp)
	call inorder
	addl $4,%esp

	addl $1, -48(%ebp)
mfor2cnd:
	cmpl $NUM_OF_NODES, -48(%ebp)
	jl mfor2body

	leal -4(%ebp), %ebx
	pushl %ebx
	call destroyBst
	addl $4,%esp

	cmpl $0, -4(%ebp)
	je mif1
	pushl $failmsg
	call puts
	addl $4,%esp
	jmp mif1end
mif1:
	pushl $successmsg
	call puts
	addl $4,%esp
mif1end:

	pushl $0
	call exit
