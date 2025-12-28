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

.equ TRUE,1
.equ FALSE,0


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
	movl -4(%ebp), %ebx
	cmpl $0, 8(%ebx)
	je insif4
	movl 8(%ebx), %ebx
	movl %ebx, -4(%ebp)
	jmp inswhile1body
insif4:
	movl -4(%ebp), %ebx
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

.globl removeNode
.type removeNode, @function
removeNode:
	pushl %ebp
	movl %esp, %ebp
	subl $8, %esp

	movl $0, -4(%ebp)		# succ_node
	movl $0, -8(%ebp)		# del_node

	movl 8(%ebp), %ebx
	pushl 12(%ebp)
	pushl (%ebx)
	call searchNode
	addl $8,%esp

	movl %eax, -8(%ebp)

	movl $BST_DATA_NOT_FOUND,%ecx
	cmpl $0, -8(%ebp)
	cmove %ecx, %eax
	je rnend

	movl -8(%ebp), %ebx
	cmpl $0, 8(%ebx)
	je rnif1
	cmpl $0, 12(%ebx)
	je elseif1

	movl -8(%ebp), %ebx
	movl 12(%ebx), %ebx
	movl %ebx,-4(%ebp)
	jmp rnwhile1
rnwhile1body:
	movl 8(%ebx), %ebx
	movl %ebx, -4(%ebp)

rnwhile1:
	movl -4(%ebp), %ebx
	cmpl $0, 8(%ebx)
	jne rnwhile1body

	movl -8(%ebp), %ebx
	movl -4(%ebp), %edx
	cmpl 12(%ebx), %edx
	je rnif3end
	cmpl $0, 12(%edx)
	je rnif4end
	movl 4(%edx), %ecx
	movl 12(%edx), %ebx
	movl %ecx, 4(%ebx)			# succ_node->right->parent = succ_node->parent
rnif4end:
	movl -4(%ebp), %edx
	movl 4(%edx), %ebx
	movl 12(%edx), %ecx
	movl %ecx, 8(%ebx)			# succ_node->parent->left = succ_node->right 

	movl -8(%ebp), %ebx
	movl -4(%ebp), %edx
	movl 12(%ebx),%ebx
	movl %ebx, 12(%edx)			# succ_node->right = del_node->right

	movl -8(%ebp), %ebx
	movl -4(%ebp), %edx
	movl 12(%ebx), %ebx
	movl %edx, 4(%ebx)			# del_node->right->parent = succ_node

rnif3end:
	movl -8(%ebp), %ebx
	movl -4(%ebp), %edx
	movl 8(%ebx), %ebx
	movl %ebx, 8(%edx)			# succ_node->left = del_node->left

	movl -8(%ebp), %ebx
	movl -4(%ebp), %edx
	movl 8(%ebx), %ebx
	movl %edx, 4(%ebx)			# del_node->left->parent = succ_node

	movl -4(%ebp), %edx
	movl -8(%ebp), %ebx
	movl 4(%ebx), %ebx
	movl %ebx, 4(%edx)			# succ_node->parent = del_node->parent

	jmp rnelse1end
elseif1:
	movl -8(%ebp), %ebx
	movl 8(%ebx), %edx
	movl 4(%ebx), %ebx
	movl %ebx, 4(%edx)

	movl %edx, -4(%ebp)
	jmp rnelse1end
rnif1:
	cmpl $0,12(%ebx)
	je rnif2end
	movl -8(%ebp), %ebx
	movl 12(%ebx), %edx
	movl 4(%ebx), %ebx
	movl %ebx, 4(%edx)

rnif2end:
	movl -8(%ebp), %ebx
	movl 12(%ebx), %edx
	movl %edx, -4(%ebp)
rnelse1end:

	movl -8(%ebp), %ebx
	cmpl $0, 4(%ebx)
	jne rnif5
	movl 8(%ebp), %edx
	movl -4(%ebp), %ebx
	movl %ebx, (%edx)
	jmp rnif5end
rnif5:
	movl -8(%ebp), %ebx
	movl 4(%ebx), %ebx
	movl 12(%ebx), %ebx
	cmpl %ebx, -8(%ebp)
	je rnif6
	movl -8(%ebp), %ebx
	movl 4(%ebx), %ebx
	movl -4(%ebp),%edx
	movl %edx, 8(%ebx)		#del_node->parent->left = succ_node

	jmp rnif5end
rnif6:
	movl -8(%ebp), %ebx
	movl 4(%ebx), %ebx
	movl -4(%ebp), %edx
	movl %edx, 12(%ebx)		#del_node->parent->right = succ_node 
rnif5end:

	movl -8(%ebp), %ebx
	movl $0, 4(%ebx)
	movl $0, 8(%ebx)
	movl $0, 12(%ebx)		#nulling out all links of del_node

	pushl %ebx
	call free
	addl $4,%esp

	movl $SUCCESS, %eax
rnend:
	movl %ebp, %esp
	popl %ebp
	ret

.globl preorder
.type preorder, @function
preorder:
	pushl %ebp
	movl %esp, %ebp

	movl 8(%ebp), %ebx

	pushl (%ebx)
	call preorderNodeLevel
	addl $4,%esp

	pushl $emptystring
	call puts
	addl $4,%esp

	movl $SUCCESS, %eax

	movl %ebp, %esp
	popl %ebp
	ret

.type preorderNodeLevel, @function
preorderNodeLevel:
	pushl %ebp
	movl %esp, %ebp

	cmpl $0, 8(%ebp)
	je pnlend

	movl 8(%ebp),%ebx
	pushl (%ebx)
	pushl $traversemsg
	call printf
	addl $8,%esp

	movl 8(%ebp), %ebx
	pushl 8(%ebx)
	call preorderNodeLevel
	addl $4,%esp

	movl 8(%ebp), %ebx
	pushl 12(%ebx)
	call preorderNodeLevel
	addl $4,%esp

pnlend:
	movl %ebp, %esp
	popl %ebp
	ret

.globl postorder
.type postorder, @function
postorder:
	pushl %ebp
	movl %esp, %ebp

	movl 8(%ebp), %ebx
	pushl (%ebx)
	call postorderNodeLevel
	addl $4,%esp

	pushl $emptystring
	call puts
	addl $4,%esp

	movl %ebp, %esp
	popl %ebp
	ret

.type postorderNodeLevel, @function
postorderNodeLevel:
	pushl %ebp
	movl %esp, %ebp

	cmpl $0, 8(%ebp)
	je pstnlend

	movl 8(%ebp), %ebx
	pushl 8(%ebx)
	call postorderNodeLevel
	addl $4,%esp

	movl 8(%ebp), %ebx
	pushl 12(%ebx)
	call postorderNodeLevel
	addl $4,%esp

	movl 8(%ebp), %ebx
	pushl (%ebx)
	pushl $traversemsg
	call printf
	addl $8,%esp

pstnlend:
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

.globl inorderSuccessor
.type inorderSuccessor, @function
inorderSuccessor:
	pushl %ebp
	movl %esp, %ebp
	subl $8, %esp

	movl $0, -4(%ebp)		#e_node = NULL
	movl $0, -8(%ebp)		#succ_node = NULL

	movl 8(%ebp), %ebx
	pushl 12(%ebp)
	pushl (%ebx)
	call searchNode
	addl $8,%esp

	movl %eax, -4(%ebp)
	movl $BST_DATA_NOT_FOUND, %ecx
	cmpl $0, -4(%ebp)
	cmove %ecx, %eax
	je isend

	pushl -4(%ebp)
	call inorderSuccessorNodeLevel
	addl $4,%esp

	movl %eax, -8(%ebp)
	movl $BST_NO_SUCCESSOR, %ecx
	cmpl $0, -8(%ebp)
	cmove %ecx, %eax
	je isend

	movl 16(%ebp), %ebx
	movl -8(%ebp), %edx
	movl (%edx), %edx
	movl %edx, (%ebx)

	movl $SUCCESS, %eax
isend:
	movl %ebp, %esp
	popl %ebp
	ret

.type inorderSuccessorNodeLevel, @function
inorderSuccessorNodeLevel:
	pushl %ebp
	movl %esp, %ebp
	subl $8, %esp

	movl $0, -4(%ebp)			# p_run = NULL 
	movl $0, -8(%ebp)			# succ_node = NULL

	movl 8(%ebp), %ebx
	cmpl $0, 12(%ebx)
	jne isnlif1

	movl 8(%ebp), %ebx
	movl %ebx, -4(%ebp)

	jmp isnlwhile2
isnlwhile2body:
	movl -4(%ebp), %ebx
	movl 4(%ebx), %ebx
	movl %ebx, -4(%ebp)

isnlwhile2:
	movl -4(%ebp), %ebx
	cmpl $0, 4(%ebx)
	je isnlwhile2end
	movl 4(%ebx), %ebx
	movl 8(%ebx), %ebx
	cmpl -4(%ebp), %ebx
	jne isnlwhile2body

isnlwhile2end:
	movl -4(%ebp), %ebx
	movl 4(%ebx), %ebx
	movl %ebx, -8(%ebp)
	jmp isnlif1end
isnlif1:
	movl 8(%ebp), %ebx
	movl 12(%ebx), %ebx
	movl %ebx,-4(%ebp)
	jmp isnlwhile1
isnlwhile1body:
	movl 8(%ebx), %ebx
	movl %ebx, -4(%ebp)

isnlwhile1:
	movl -4(%ebp), %ebx
	cmpl $0, 8(%ebx)
	jne isnlwhile1body

	movl -4(%ebp), %ebx
	movl %ebx, -8(%ebp)

isnlif1end:
	movl -8(%ebp), %eax

	movl %ebp, %esp
	popl %ebp
	ret

.globl inorderPredecessor
.type inorderPredecessor, @function
inorderPredecessor:
	pushl %ebp
	movl %esp, %ebp
	subl $8, %esp

	movl $0, -4(%ebp)		# e_node  = NULL
	movl $0, -8(%ebp)		# pred_node	= NULL

	movl 8(%ebp), %ebx
	pushl 12(%ebp)
	pushl (%ebx)
	call searchNode
	addl $8,%esp
	movl %eax, -4(%ebp)

	movl $BST_DATA_NOT_FOUND, %ecx
	cmpl $0,-4(%ebp)
	cmove %ecx, %eax
	je ipend

	# pushl $here1
	# call puts
	# addl $4,%esp

	pushl -4(%ebp)
	call inorderPredecessorNodeLevel
	addl $4,%esp

	movl %eax, -8(%ebp)
	movl $BST_NO_PREDECESSOR, %ecx
	cmpl $0, -8(%ebp)
	cmove %ecx, %eax
	je ipend

	movl 16(%ebp), %ebx
	movl -8(%ebp), %edx
	movl (%edx),%edx
	movl %edx,(%ebx)

	movl $SUCCESS, %eax
ipend:

	movl %ebp, %esp
	popl %ebp
	ret

.type inorderPredecessorNodeLevel, @function
inorderPredecessorNodeLevel:
	pushl %ebp
	movl %esp, %ebp
	subl $8, %esp

	movl $0, -4(%ebp)			#p_run
	movl $0, -8(%ebp)			#pred_node

	movl 8(%ebp),%ebx
	cmpl $0, 8(%ebx)
	jne ipnlif1
	movl 8(%ebp), %ebx
	movl %ebx, -4(%ebp)

	
	jmp ipnlwhile2
ipnlwhile2body:
	movl -4(%ebp), %ebx
	movl 4(%ebx), %ebx
	movl %ebx, -4(%ebp)

ipnlwhile2:
	movl -4(%ebp), %ebx
	cmpl $0, 4(%ebx)
	je ipnlwhile2end
	
	movl -4(%ebp), %ebx
	movl 4(%ebx), %ebx
	movl 12(%ebx),%ebx
	cmpl %ebx,-4(%ebp)
	jne ipnlwhile2body

ipnlwhile2end:
	# movl -4(%ebp), %ebx
	# movl 4(%ebx),%ebx
	# pushl %ebx
	# pushl $datamsg
	# call printf
	# addl $8,%esp

	movl -4(%ebp),%ebx
	movl 4(%ebx), %ebx
	movl %ebx, -8(%ebp)
	
	jmp ipnlifend
ipnlif1:
	movl 8(%ebp), %ebx
	movl 8(%ebx), %ebx
	movl %ebx, -4(%ebp)

	jmp ipnlwhile1
ipnlwhile1body:
	movl 12(%ebx), %ebx
	movl %ebx, -4(%ebp)

ipnlwhile1:
	movl -4(%ebp), %ebx
	cmpl $0, 12(%ebx)
	jne ipnlwhile1body

	movl -4(%ebp), %ebx
	movl %ebx, -8(%ebp)
ipnlifend:

	movl -8(%ebp),%eax

	movl %ebp, %esp
	popl %ebp
	ret

.globl find
.type find, @function
find:
	pushl %ebp
	movl %esp, %ebp
	subl $4, %esp

	movl 8(%ebp), %ebx

	pushl 12(%ebp)
	pushl (%ebx)
	call searchNode
	addl $8,%esp

	movl $FALSE, %ecx
	cmpl $0, %eax
	cmove %ecx, %eax
	je findend
	movl $TRUE, %eax

findend:
	movl %ebp, %esp
	popl %ebp
	ret

.type searchNode, @function
searchNode:
	pushl %ebp
	movl %esp, %ebp
	subl $4, %esp

	movl $0, -4(%ebp)

	movl 8(%ebp), %ebx
	movl %ebx, -4(%ebp)

	jmp snwhile1
snwhile1body:
	
	movl -4(%ebp), %ebx
	movl 12(%ebp), %edx
	cmpl (%ebx), %edx
	je snwhile1end
	jg snif1
	movl -4(%ebp), %ebx
	movl 8(%ebx), %ebx
	movl %ebx, -4(%ebp)
	jmp snwhile1
snif1:
	movl -4(%ebp), %ebx
	movl 12(%ebx), %ebx
	movl %ebx, -4(%ebp)

snwhile1:
	cmpl $0, -4(%ebp)
	jne snwhile1body
snwhile1end:
	movl -4(%ebp), %eax

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
