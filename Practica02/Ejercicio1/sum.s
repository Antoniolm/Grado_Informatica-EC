.section .data
lista:
	.int 1,2,10, 1,2,0b10, 1,2,0x10
	#.int 1,1,1,1,1,1,1,1,1
longlista:
	.int (.-lista)/4
resultado:
	.quad 0x01234567

formato:
	.ascii "suma = %llu = %llx hex\n\0"

.section .text
main: .global main

	mov $lista,    %ebx
	mov longlista, %ecx
	call suma
	mov %edi, resultado+4
	mov %eax, resultado
	

	
	pushl resultado+4
	pushl resultado
	pushl resultado+4
	pushl resultado
	push $formato
	call printf
	add $20,%esp

	mov $1, %eax
	mov $0, %ebx
	mov $0, %edi 

	int $0x80


suma:
	push %edx
	mov $0, %eax
	mov $0, %edx
	mov $0, %edi

bucle:
	add (%ebx,%edx,4),%eax
	jnc sinC
	add $1,%edi
	//Opcion b -> adc $0,%edi
	
sinC:	inc %edx
	cmp %edx,%ecx
	jne bucle

	pop %edx
	ret
