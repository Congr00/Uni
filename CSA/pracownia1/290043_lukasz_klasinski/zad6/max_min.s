

	.global main

argc = %rdi
argv = %rsi
table = %r9
length = %r10
min = %rax
max = %rdx
i	= %r11
value = %r12

	.section .text

main:
	decq	argc					#1 wartosc nie interesuje
	movq	argc,		length		
	movq	%rsp,		table		#wskaznik na poczatek tablicy
	addq	$8,			argv
	xorq	%rax,		%rax	
	cmpq	$0,			length
	jz		.End
.Arg_Loop:
	pushq	argc
	pushq	argv
	pushq	length
	pushq	table
	subq	$16,		%rsp
	mov		(argv),		%rdi
	call	atol
	addq	$16,		%rsp
	popq	table
	popq	length
	popq	argv
	popq	argc
	pushq	%rax
	addq	$8,			argv
	decq	argc
	jnz		.Arg_Loop

	movq	-8(table),	min
	movq	min,		max
	movq	$-1,		i
	
.Find_Loop:
	movq	length,		%rcx
	imulq	$-1,		%rcx
	cmpq	i,			%rcx
	je		.Print
	movq	-8(table,i,8),value
	cmpq	value, 		max
	jg		.Greater
	movq	value,		max
	jmp		.EndLoop
.Greater:
	cmpq	min,		value
	jg		.EndLoop
	movq	value,		min
.EndLoop:
	decq	i
	jmp		.Find_Loop
.Print:
	movq	$format,	%rdi
	movq	max,		%rsi
	movq	min,		%rdx
	xorq		%rax,		%rax
	call	printf
.End:
	shlq	$2,			length	
	subq	length,		%rsi
	movq	$60,		%rax
	movq	$1,			%rdi
	syscall

	.section .rodata
format:
	.asciz "max: %d, min: %d\n"
