.section .data
lista:
	#.int  1,2,10, 1,2,0b10, 1,2,0x10
	#.int 1,-1,1,1,-1,1,1,1,1
	#.int -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1

	.int 1,-2,1,-2,1,-2,1,-2,1,-2,1,-2,1,-2,1,-2,1,-2,1,-2,1,-2,1,-2,1,-2,1,-2,1,-2,1,-2
	#.int 1,2,-3,-4,1,2,-3,-4,1,2,-3,-4,1,2,-3,-4,1,2,-3,-4,1,2,-3,-4,1,2,-3,-4,1,2,-3,-4
longlista:
	.int (.-lista)/4
cociente:
	.int 0x01234567
resto:
	.int 0x01234220

formato:
	.ascii "Cociente : %8d -> 0x%08x hex \nResto : %8d -> 0x%08x hex \n\0"

.section .text
main: .global main

	mov $lista,    %ebx
	mov longlista, %ecx
	call suma
	mov %edi, resto
	mov %eax, cociente
	
	pushl resto
	pushl resto
	pushl cociente
	pushl cociente
	push $formato
	call printf
	add $20,%esp

	mov $1, %eax
	mov $0, %ebx
	mov $0, %edi 

	int $0x80


suma:
	push %edx
	mov $0, %edx #mas   significativo sin acumular
	mov $0, %eax #menos significativo sin acumular
	mov $0, %ebp #contador del bucle
	mov $0, %edi #mas   significativo acumulado
	mov $0, %esi #menos significativo acumulado

bucle:
	mov (%ebx,%ebp,4),%eax
	cdq  
	add %eax,%esi
	adc %edx,%edi
	
	inc %ebp
	cmp %ebp,%ecx
	jne bucle

	mov %esi,%eax	# Realizamos estos mov ya que idiv necesita el dividendo en %edx:%eax
	mov %edi,%edx
	idiv %ecx	# %edx:%eax/%ecx  = Resto-> %edx Cociente-> %eax

	mov %edx,%edi #guardamos nuestro resto ya que debido al pop perderiamos el valor

	pop %edx
	ret
