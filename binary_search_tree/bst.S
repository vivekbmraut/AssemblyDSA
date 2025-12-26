.section .rodata
errmsg:
	.string "ERROR IN MEMORY ALLOCATION"
traversemsg:
	.string "%d ,"
emptystring:
	.string ""

.section .text

.equ BST_INVALID,0
.equ SUCCESS,1
.equ BST_EMPTY,2
.equ BST_DATA_NOT_FOUND,3
.equ BST_NO_PREDECESSOR,4
.equ BST_NO_SUCCESSOR,5


.globl createBst
.type createBst, @function
createBst:
	pushl %ebp
	movl %esp, %ebp
	subl $4,%esp

	movl $0, -4(%ebp)

	pushl $8
	pushl $1
	call xcalloc
	addl $8,%esp

	movl %eax, -4(%ebp)

	movl -4(%ebp), %eax
	movl %ebp, %esp
	popl %ebp
	ret


.globl insert
.type insert, @function
insert:
	pushl %ebp
	movl %esp, %ebp
	subl $8, %esp

	movl $0, -4(%ebp)		# p_run
	movl $0, -8(%ebp)		# p_new_node

	pushl 12(%ebp)
	call getBstNode
	addl $4,%esp

	movl %eax, -8(%ebp)

	movl 8(%ebp), %ebx
	cmpl $0, (%ebx)
	je insif1
	movl (%ebx), %ebx
	movl %ebx, -4(%ebp)

inswhile1body:
	movl -4(%ebp), %ebx
	movl 12(%ebp), %ecx
	cmpl (%ebx), %ecx
	jle insif2
	cmpl $0, 12(%ebx)
	je insif3
	movl 12(%ebx), %ebx
	movl %ebx, -4(%ebp)
	jmp inswhile1body 
insif3:
	movl -8(%ebp), %edx
	movl %edx, 12(%ebx)
	movl %ebx, 4(%edx)

	jmp inswhile1end
insif2:	
	cmpl $0, 8(%ebx)
	je insif4
	movl 8(%ebx), %ebx
	movl %ebx, -4(%ebp)
	jmp inswhile1body
insif4:
	movl -8(%ebp), %edx
	movl %edx, 8(%ebx)
	movl %ebx, 4(%edx)

inswhile1end:
	jmp insif1end
insif1:
	movl -8(%ebp), %ecx
	movl %ecx, (%ebx)

insif1end:
	movl 8(%ebp), %ebx
	addl $1, 4(%ebx)

	movl $SUCCESS, %eax
	movl %ebp, %esp
	popl %ebp
	ret

.globl inorder
.type inorder, @function
inorder:
	pushl %ebp
	movl %esp, %ebp

	movl 8(%ebp), %ebx
	
	pushl (%ebx)
	call inorderNodeLevel
	addl $4,%esp

	pushl $emptystring
	call puts
	addl $4,%esp

	movl $SUCCESS, %eax

	movl %ebp, %esp
	popl %ebp
	ret


.type inorderNodeLevel, @function
inorderNodeLevel:
	pushl %ebp
	movl %esp, %ebp

	cmpl $0, 8(%ebp)
	je inlend

	movl 8(%ebp), %ebx
	pushl 8(%ebx)
	call inorderNodeLevel
	addl $4,%esp

	movl 8(%ebp), %ebx
	pushl (%ebx)
	pushl $traversemsg
	call printf
	addl $4,%esp

	movl 8(%ebp), %ebx
	pushl 12(%ebx)
	call inorderNodeLevel
	addl $4,%esp

inlend:

	movl %ebp, %esp
	popl %ebp
	ret

.globl destroyBst
.type destroyBst, @function
destroyBst:
	pushl %ebp
	movl %esp, %ebp

	movl 8(%ebp), %ebx
	movl (%ebx), %ebx

	pushl (%ebx)
	call destroyBstNodeLevel
	addl $4,%esp

	movl 8(%ebp), %ebx
	pushl (%ebx)
	call free
	addl $4,%esp

	movl 8(%ebp), %ebx
	movl $0, (%ebx)

	movl %ebp, %esp
	popl %ebp
	ret

.type destroyBstNodeLevel, @function
destroyBstNodeLevel:
	pushl %ebp
	movl %esp, %ebp

	cmpl $0, 8(%ebp)
	je dnlend

	movl 8(%ebp), %ebx
	pushl 8(%ebx)
	call destroyBstNodeLevel
	addl $4,%esp

	movl 8(%ebp), %ebx
	pushl 12(%ebx)
	call destroyBstNodeLevel
	addl $4,%esp
	
	pushl 8(%ebp)
	call free
	addl $4,%esp

dnlend:
	movl %ebp, %esp
	popl %ebp
	ret

.type getBstNode, @function
getBstNode:
	pushl %ebp
	movl %esp, %ebp
	subl $4,%esp

	movl $0, -4(%ebp)

	pushl $16
	pushl $1
	call xcalloc
	addl $8,%esp

	movl %eax, -4(%ebp)
	movl %eax, %ebx

	movl 8(%ebp), %ecx
	movl %ecx, (%ebx)

	movl -4(%ebp), %eax
	movl %ebp, %esp
	popl %ebp
	ret


.type xcalloc, @function
xcalloc:
	pushl %ebp
	movl %esp, %ebp

	pushl 12(%ebp)
	pushl 8(%ebp)
	call calloc
	addl $8,%esp

	cmpl $0, %eax
	jne xcend
	pushl $errmsg
	call puts
	addl $4,%esp

	movl $1, %ebp
	movl $1, %eax
	int $0x80

xcend:

	movl %ebp, %esp
	popl %ebp
	ret
