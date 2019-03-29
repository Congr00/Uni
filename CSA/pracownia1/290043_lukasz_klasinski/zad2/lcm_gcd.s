
	.global lcm_gcd
	.type lcm_gcd, @function
	
arg_1 = %rdi
arg_2 = %rsi
gcd = %r11
a = %r8
b = %r9
	
	.section .text

lcm_gcd:
	movq	arg_1,	a
	movq	arg_2,	b
	call	NWD
	movq	%rax,	gcd
	movq	a,		%rax
	mulq	b
	div		gcd
	movq	gcd,	%rdx
	ret

.size lcm_gcd, . - lcm_gcd

NWD:
	cmpq	$0,		arg_2
	je		.Skip_rec
	xorq	%rdx,	%rdx
	movq	arg_1,	%rax
	div		arg_2
	movq	arg_2,	arg_1
	movq	%rdx,	arg_2
	call	NWD
	ret
.Skip_rec:
	movq	arg_1,	%rax
	ret
