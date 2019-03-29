
	.globl fibonacci
	.type fibonacci, @function

n = %rdi
result = %rax
temp = %r8

	.section .text

fibonacci:
	cmpq	$0,		n
	jne		.Check_one
	movq	n,		result
	ret
.Check_one:
	cmpq	$1,		n
	jne		.Recursive
	movq	n,		result
	ret
.Recursive:
	push	n
	subq	$1,		n
	call	fibonacci
	pop		temp
	push	n
	movq	temp,	n
	subq	$2,		n
	call	fibonacci
	pop		temp
	addq	temp,	n
	movq	n,	result
	ret
	
.size fibonacci, . - fibonacci	
