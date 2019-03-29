add_128bit:
	movq %rsi, %r8 # gorne
	shrq $32, %r8
	movq %rsi, %r9 # dolne
	shlq $32, %r9
	shrq $32, %r9
	movq %rcx, %r10
	movq %rcx, %r11
	shrq $32, %r10
	shlq $32, %r11
	shrq $32, %r11
	addq %r10, %r8 #gorne
	addq %r11, %r9 #dolne
	movq %r9, %r10
	shrq $32, %r10 #nadmiar dolny
	addq %r10, %r8 # dodajemy nadmiar dolny do gornych
	movq %r8, %r11
	shrq $32, %r11 #nadmiar gorny
	addq %rdx, %rdi
	addq %r11, %rdi //gora dobra
 	movq %rdi, %rax
	shlq $32, %r8
	addq %r8, %rdx
	shlq $32, %r9
	shrq $32, %r9
	addq %r9, %rdx
	ret
	
	
