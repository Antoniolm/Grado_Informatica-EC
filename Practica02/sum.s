.section .data
lista:
	.int 1,2,10, 1,2,0b10, 1,2,0x10
longlista:
	.int (.-lista)/4
resultado:
	.quad 0x01234567

formato:
	.ascii "suma = %u = %x hex\n\0"

.section .text
main: .global main

	mov $lista,    %ebx
	mov longlista, %ecx
	call suma
	mov %eax, resultado
	//Nuevo resultado 
	//sal resultado,32
	//add %edi, resultado

	
	push resultado
	push resultado
	push $formato
	call printf
	add $12,%esp

	mov $1, %eax
	mov $0, %ebx
	mov $0, %edi 
	//Ponemos a cero nuestro segundo valor de resultado
	int $0x80


suma:
	push %edx
	mov $0, %eax
	mov $0, %edx

bucle:
	adc (%ebx,%edx,4),%eax
	jnc sinC
	add $1,%edi
	
sinC:	inc %edx
	cmp %edx,%ecx
	jne bucle

	pop %edx
	ret

