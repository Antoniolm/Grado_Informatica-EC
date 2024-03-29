###################################################
#
#	Antonio David López Machado - Curso 2016/2017
#	Practica-2 Ejercicio 2
#
###################################################

.section .data
	.macro linea
		#.int  1,2,10, 1,2,0b10, 1,2,0x10
		#.int -1,-1,-1,-1,-1,-1,-1,-1,-1
		#.int -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
		#.int 1,-2,1,-2,1,-2,1,-2,1,-2,1,-2,1,-2,1,-2,1,-2,1,-2,1,-2,1,-2,1,-2,1,-2,1,-2,1,-2
		#.int 1,2,-3,-4,1,2,-3,-4,1,2,-3,-4,1,2,-3,-4,1,2,-3,-4,1,2,-3,-4,1,2,-3,-4,1,2,-3,-4
		.int 0xF0000000,0xE0000000,0xE0000000,0xD0000000,0xF0000000,0xE0000000,0xE0000000,0xD0000000,0xF0000000,0xE0000000,0xE0000000,0xD0000000,0xF0000000,0xE0000000,0xE0000000,0xD0000000,0xF0000000,0xE0000000,0xE0000000,0xD0000000,0xF0000000,0xE0000000,0xE0000000,0xD0000000,0xF0000000,0xE0000000,0xE0000000,0xD0000000,0xF0000000,0xE0000000,0xE0000000,0xD0000000

	.endm
lista: .irpc i,1
		linea
       .endr

longlista:
	.int (.-lista)/4
resultado:
	.quad 0x01234567

formato:
	.ascii "suma = %lld = %llx hex\n\0"

.section .text
main: .global main

	mov $lista,    %ebx		#Introducimos en el registro ebx la lista de elementos
	mov longlista, %ecx		#Introducimos en el registro ecx el tamaño de la lista de elementos
	call suma				#Llamada al metodo suma
	mov %edi, resultado+4	#Obtenemos la suma acumulada
	mov %esi, resultado		#Y la introducimos en la variable resultado
	
	pushl resultado+4	#Realizamos los push necesarias para realizar un printf con
	pushl resultado		#Valores de 64bits
	pushl resultado+4
	pushl resultado
	push $formato
	call printf		#Realizamos la impresión del resultados
	add $20,%esp

	mov $1, %eax		#Ponemos los valores necesarias para realizar la salida del programa
	mov $0, %ebx

	int $0x80		#Realizamos la salida del programa

######################################################
# Método que realiza la suma con signo de un conjunto de elementos 
# pasados como parametro
# Devuelve la suma total de todos los elementos
####################################################
suma:
	push %edx
	mov $0, %edx 	#mas   significativo sin acumular
	mov $0, %eax 	#menos significativo sin acumular
	mov $0, %ebp 	#contador del bucle
	mov $0, %edi 	#mas   significativo acumulado
	mov $0, %esi 	#menos significativo acumulado

bucle:
	mov (%ebx,%ebp,4),%eax	#Movemos el elemento actual de la lista
	cdq  					#Realizamos la instruccion cdq y nos introduce los valores
	add %eax,%esi			#resltantes en eax y edx
	adc %edx,%edi			#Acumulamos ambos valores
	
	inc %ebp				#Incrementamos el contador
	cmp %ebp,%ecx			#Comparamos nuestro contador
	jne bucle				#Si no ha llegado al final vuelve a empezar en la etiqueta bucle:

	pop %edx
	ret
