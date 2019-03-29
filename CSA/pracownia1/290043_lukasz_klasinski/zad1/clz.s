
	.globl clz
	.type clz, @function
	
	.section .text

clz:
	movq	$64,	%rax
	movq	%rdi,	%r8
	shrq	$32,	%r8
	cmpq	$0,		%r8
	je		.L16
	subq	$32,	%rax
	movq	%r8,	%rdi
.L16:
	movq 	%rdi,	%r8
	shrq	$16,	%r8
	cmpq	$0,		%r8
	je		.L8
	subq	$16,	%rax
	movq	%r8,	%rdi
.L8:
	movq	%rdi,	%r8
	shrq	$8,		%r8
	cmpq	$0,		%r8
	je		.L4
	subq	$8,		%rax
	movq	%r8,	%rdi
.L4:	
	movq	%rdi,	%r8
	shrq	$4,		%r8
	cmpq	$0,		%r8
	je		.L2
	subq	$4,		%rax
	movq	%r8,	%rdi
.L2:
	movq	%rdi,	%r8
	shrq	$2,		%r8
	cmpq	$0,		%r8
	je		.L1
	subq	$2,		%rax
	movq	%r8,	%rdi
.L1:
	movq	%rdi,	%r8
	shrq	$1,		%r8
	cmpq	$0,		%r8
	je		.L0
	subq	$2,		%rax
	ret
.L0:
	subq	%rdi,	%rax
	ret
.size clz, . - clz
