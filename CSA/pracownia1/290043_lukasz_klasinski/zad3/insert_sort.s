

	.global insert_sort
	.type insert_sort, @function

pointer = %rdi
end_ptr = %rsi
tmp = %r8
i = %r9
j = %r10

	.section .text

insert_sort:
	xorq	tmp,			tmp
	subq	pointer,		end_ptr
	shrq	$3,				end_ptr
	movq	$1,				i
.Loop:
	cmpq	i,				end_ptr
	je		.Sorted
	movq	(pointer,i,8),	tmp	
	movq	i,				j
	decq	j
.Loop2:
	cmpq	$-1,			j
	je		.EndLoop2 	
	cmpq	(pointer,j,8),	tmp
	jg		.EndLoop2			
	movq	(pointer,j,8),	%rax
	movq	%rax,			8(pointer,j,8)
	decq	j
	jmp		.Loop2
.EndLoop2:
	movq	tmp,			8(pointer,j,8)	
	incq	i
	jmp		.Loop
.Sorted:
	ret

.size insert_sort, . - insert_sort
