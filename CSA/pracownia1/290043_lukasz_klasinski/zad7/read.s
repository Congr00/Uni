	.global _start
	.section .bss
	.lcomm char, 1
	.section .text


_start:

	xorq	%rax, 	%rax
	xorq	%rdi,	%rdi
	leaq	char,	%rsi
	movq	$1,		%rdx
	syscall

	cmpq	$0,		%rax
	je 		.Ret

	movq	char,	%rax
	cmpq	$123,	%rax
	jae		.Loop
	cmpq	$97,	%rax
	jae		.Skip
	cmpq	$91,  %rax
	jae		.Loop
	cmpq	$65,	%rax
	jae		.Skip
	jmp		.Loop

.Skip:
	xor		$32,	char

.Loop:
	movq	$1,		%rax
	movq	$1,		%rdi
	leaq	char,	%rsi
	syscall
	jmp		_start
.Ret:
	movq	$60,	%rax
	xorq	%rdi,	%rdi
	syscall
	ret
