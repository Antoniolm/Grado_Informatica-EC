###################################################
#
#	Antonio David López Machado - Curso 2016/2017
#	Practica-2 Ejercicio 1
#
###################################################

.section .data
	.macro linea
		#.int 1,2,10, 1,2,0b10, 1,2,0x10
		#.int 1,1,1,1,1,1,1,1,1
		#.int 2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
		#.int 1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4
		#.int 0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff,0xffffffff
		#.int 0x08000000,0x08000000,0x08000000,0x08000000
		.int 0x10000000,0x20000000,0x40000000,0x80000000,0x10000000,0x20000000,0x40000000,0x80000000,0x10000000,0x20000000,0x40000000,0x80000000,0x10000000,0x20000000,0x40000000,0x80000000,0x10000000,0x20000000,0x40000000,0x80000000,0x10000000,0x20000000,0x40000000,0x80000000,0x10000000,0x20000000,0x40000000,0x80000000,0x10000000,0x20000000,0x40000000,0x80000000
	.endm
lista: .irpc i,1
		linea
       .endr
	
longlista:
	.int (.-lista)/4
resultado:
	.quad 0x01234567

formato:
	.ascii "suma = %llu = %llx hex\n\0"

.section .text
main: .global main

	mov $lista,    %ebx		#Introducimos en el registro ebx la lista de elementos
	mov longlista, %ecx		#Introducimos en el registro ecx el tamaño de la lista de elementos
	call suma				#Llamada al metodo suma
	mov %edi, resultado+4	#Introducimos en el resultado los byte mas significativos
	mov %eax, resultado		#Introducimos en el resultado los byte menos significativos
	

	
	pushl resultado+4	#Realizamos los push necesarias para realizar un printf con
	pushl resultado		#Valores de 64bits
	pushl resultado+4
	pushl resultado
	push $formato
	call printf			#Realizamos la impresión del resultados
	add $20,%esp

	mov $1, %eax		#Ponemos los valores necesarias para realizar la salida del programa
	mov $0, %ebx

	int $0x80			#Realizamos la salida del programa

######################################################
# Método que realiza la suma sin signo de un conjunto de elementos 
# pasados como parametro
# Devuelve la suma total de todos los elementos
####################################################
suma:
	push %edx
	mov $0, %eax	#Inicializamos a 0 los registros
	mov $0, %edx	#que utilizaremos en nuestro método
	mov $0, %edi

bucle:
	add (%ebx,%edx,4),%eax  #Realizamos la suma del elemento de la lista
	jnc sinC				#Saltamos a la etiquet sinC cuando no se produzca acarreo
	add $1,%edi				#Caso -> Con carrero
							#Añadimos el carrero al registro con los valores mas significativos(%edi)
	
sinC:	inc %edx			#Incrementamos el contador
	cmp %edx,%ecx			#Comparamos nuestro contador
	jne bucle				#Si no ha llegado al final vuelve a empezar en la etiqueta bucle:

	pop %edx
	ret 					

