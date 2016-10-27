###################################################
#
#	Antonio David López Machado - Curso 2016/2017
#	Practica-2 Ejercicio 3
#
###################################################


.section .data
	.macro linea
		#.int  1,2,10, 1,2,0b10, 1,2,0x10
		#.int -1,-1,-1,-1,-1,-1,-1,-1,-1
		#.int -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
		.int 1,-2,1,-2,1,-2,1,-2,1,-2,1,-2,1,-2,1,-2,1,-2,1,-2,1,-2,1,-2,1,-2,1,-2,1,-2,1,-2
		#.int 1,2,-3,-4,1,2,-3,-4,1,2,-3,-4,1,2,-3,-4,1,2,-3,-4,1,2,-3,-4,1,2,-3,-4,1,2,-3,-4

	.endm
lista: .irpc i,1
		linea
       .endr
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

	mov $lista,    %ebx	#Introducimos en el registro ebx la lista de elementos
	mov longlista, %ecx	#Introducimos en el registro ecx el tamaño de la lista de elementos
	call suma			#Llamada al metodo suma
	mov %edi, resto		#Introducimos el resto en la variable
	mov %eax, cociente	#Introducimos el cociente en la variable
	
	pushl resto		#Realizamos los push necesarias para realizar un printf
	pushl resto		#Tanto del cociente como del resto
	pushl cociente
	pushl cociente
	push $formato
	call printf		#Realizamos la impresión del resultados
	add $20,%esp

	mov $1, %eax		#Ponemos los valores necesarias para realizar la salida del programa
	mov $0, %ebx

	int $0x80		#Realizamos la salida del programa


######################################################
# Método que realiza la suma con signo de un conjunto de elementos 
# y realiza su media
# Devuelve el cociente y el resto de la media
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
	cdq  			#Realizamos la instruccion cdq y nos introduce los valores
	add %eax,%esi		#resultantes en eax y edx
	adc %edx,%edi		#Acumulamos ambos valores
	
	inc %ebp			#Incrementamos el contador
	cmp %ebp,%ecx		#Comparamos nuestro contador
	jne bucle			#Si no ha llegado al final vuelve a empezar en la etiqueta bucle:

	mov %esi,%eax	# Realizamos estos mov ya que idiv necesita el dividendo en %edx:%eax
	mov %edi,%edx
	idiv %ecx	# %edx:%eax/%ecx  = Resto-> %edx Cociente-> %eax

	mov %edx,%edi 	#guardamos nuestro resto ya que debido al pop perderiamos el valor

	pop %edx
	ret

