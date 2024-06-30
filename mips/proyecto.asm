.data
	tablero: .space 12         			# Espacio para 12 bytes, cada uno representa una casilla
	posiciones: .space 48				# Espacio para 12 enteros (12 * 4 bytes = 48 bytes)
	chacales: .space 16				# Espacio para 4 enteros (4 * 4 bytes = 16 bytes)
	tesoros: .space 32     			# Espacio para 8 enteros (8 * 4 bytes = 32 bytes)
	respuesta: .space 3				# Espacio para la respuesta que ingrese el usuario
    	chacales_encontrados: .word 0			# Contador de chacales encontrados
    	tesoros_encontrados: .word 0			# Contador de tesoros encontrados
    	dinero_acumulado: .word 0			# Dinero acumulado
    	turnos_consecutivos_repetidos: .word -1	# Contador de turnos repetidos
    	cantidad_repetidos: .word 0			# Máximo de turnos repetidos permitidos
    	casilla: .word 0				# casilla aleatoria
    	
	#Mensajes
	nuevo_linea: .asciiz "\n"  			# Nueva línea para formato de salida
	espacio: .asciiz " "				# Caracter espacio en blanco
	.align 2
	bienvenido: .asciiz "----Bienvenido al juego de los chacales----"
	pregunta: .asciiz "¿Quieres seguir jugando? (si/no): "
	repetir: .asciiz "\nIngrese correctamente la palabra si o no (en minusculas)\n"
	si: .asciiz "si"
	no: .asciiz "no"
	agradecimiento: .asciiz "\nGracias por jugar!\nEstos son los resultados:"
	mensaje_tesosoros: .asciiz "\nN° de tesoros encontrados: "
	mensaje_dinero: .asciiz "\nDinero acumulado: "
	mensaje_chacales: .asciiz "\nN° de chacales encontrados: "
	progreso: .asciiz "\nProgreso:"
	separacion: .asciiz "\n--------------------------------------------\n"
	numero_casilla: .asciiz "Numero de casilla: "
	mensaje_progreso_chacal: .asciiz "\nHas encontrado un chacal!"
	mensaje_progreso_tesoro: .asciiz "\nHas encontrado un tesoro!"
	mensaje_gano: .asciiz "\n¡Felicidades! ¡Has encontrado todos los tesoros y ganado el juego!"
	mensaje_perdio: .asciiz "\n¡Has perdido! ¡Has encontrado todos los chacales! :'( "
	mensaje_default: .asciiz "\nHas descubierto el mismo número de casilla 3 veces consecutivas. Has perdido el juego."
	mensaje_adventencia: .asciiz "Advertencia: Este número ha salido dos veces. Tenga cuidado!!\n\n"


.text
.globl main

main:
	li $v0, 4
    	la $a0, bienvenido
    	syscall
	
	la $t0, tablero       # Cargar la dirección base de tablero en $s0
    	li $t1, 79            # Cargar el valor ASCII de 'O' en $t1
    	li $t2, 12            # Número de casillas a inicializar
    	
inicializar_tablero:
    	beq $t2, $zero, inicializar_posiciones		# Si hemos inicializado las 12 casillas, saltar al final
    	sb $t1, 0($t0)        				# Almacenar el valor de 'O' en la posición actual del tablero
    	addi $t0, $t0, 1      				# Incrementar el puntero de la dirección del tablero
    	subi $t2, $t2, 1      				# Decrementar el contador de casillas por inicializar
    	j inicializar_tablero 				# Volver al inicio del bucle
    	
inicializar_posiciones:
	la $s0, posiciones    # Cargar la dirección base del array `posiciones` en $s0
    	li $t1, 0             # Inicializar el primer valor en 0
    	li $t2, 12            # Número de enteros a inicializar

loop_posiciones:
	beq $t2, $zero, fin_posiciones  	# Si hemos inicializado los 12 enteros, salir del bucle
    	sw $t1, 0($s0)        			# Almacenar el valor de $t1 en la posición actual del array
    	addi $s0, $s0, 4      			# Incrementar el puntero de la dirección del array
    	addi $t1, $t1, 1      			# Incrementar el valor de $t1 en 1
    	subi $t2, $t2, 1      			# Decrementar el contador de enteros por inicializar
    	j loop_posiciones  			# Volver al inicio del bucle

fin_posiciones:
    	la $a0, posiciones    		# Pasar la dirección base del array `posiciones` a $a0
    	li $a1, 12            		# Pasar el tamaño del array `posiciones` a $a1
    	jal shuffle_posiciones  	# Llamar a la función shuffle_posiciones
    
iniciar_copia:
	# Direcciones base
	li $t0, 0 
	la $s0, posiciones
	la $s1, chacales
	la $s2, tesoros

copiar:
	beq $t0, 12, Loop
	addi $t0, $t0, 1
	# Copiar indices chacales
	bge $t0, 5, else
	lw $t1, 0($s0)
	sw $t1, 0($s1)
	addi $s0, $s0, 4
	addi $s1, $s1, 4
	j copiar

else: 
	# copiar indicces tesoros
	lw $t1, 0($s0)
	sw $t1, 0($s2)
	addi $s0, $s0, 4
	addi $s2, $s2, 4
	j copiar

#Inicio de juego
Loop:
	li $v0, 4
    	la $a0, separacion
    	syscall
    	
	li $v0, 4
    	la $a0, nuevo_linea
    	syscall

   	# Llamar a la syscall para generar un número aleatorio
    	li $v0, 42
    	li $a1, 12
    	syscall
    	sw $a0, casilla

    	# Imprimir el número aleatorio generado
    	li $v0, 4
    	la $a0, numero_casilla
    	syscall
    
    	li $v0, 1
    	lw $a0, casilla
    	syscall

    	li $v0, 4
    	la $a0, nuevo_linea
    	syscall
    	
    	li $v0, 4
    	la $a0, nuevo_linea
    	syscall
    	
    	# Comparar numero anterior con actual
    	lw $t0, casilla
    	lw $t1, turnos_consecutivos_repetidos
    	move $t1, $t1
    	lw $t2, cantidad_repetidos
    	move $t2, $t2
    	
    	beq $t0, $t1, iguales
    	#Difentes
    	li $t2, 0
	sw $t2, cantidad_repetidos
	sw $t0, turnos_consecutivos_repetidos
    	
    	j comparar_numeros
    	
iguales:
	#Iguales
	addi $t2, $t2, 1
    	sw $t2, cantidad_repetidos
    	sw $t0, turnos_consecutivos_repetidos

comparar_numeros:
	# Verifica si ya se repitio 3 veces
	li $t9, 2
	li $t8, 1
	beq $t2, $t8, advertencia		
	bne $t2, $t9, iniciar_tablero
	j  defaut

advertencia:
	li $v0, 4
    	la $a0, mensaje_adventencia
    	syscall
	la $a0, tablero       		# Pasar la dirección base de tablero a $a0
    	li $a1, 12            		# Pasar el tamaño del tablero a $a1
    	jal imprimir_tablero		# Llamar a la función imprimir_tablero
    	jal mostrar_progreso
    	j validacion
    	
iniciar_tablero:
    	# Contar chacales y tesoros
    	lw $t0, chacales_encontrados
    	lw $t1, tesoros_encontrados
    	la $t2, chacales
    	li $t3, 0 					# Contador para el loop
    	li $t6, 0 					# Copiar numero aletorio anterior
    	lw $t8, cantidad_repetidos 			# Veces que se puede repetir un numero
    	lw $t7, turnos_consecutivos_repetidos 		# Veces que se repitio el numero
    	lw $t9, dinero_acumulado
   
actualizar_contadores:
	# Comparar numero aleatorio con arreglo de chacales
	bge, $t3, 4, caso_tesoros 	# Recorrer chacales
	lw $t4, 0($t2) 			# Cargar elemento de chacales
	lw $t5, casilla 		# Cargar numero aleatorio
	addi $t2, $t2, 4
	addi $t3, $t3, 1
	bne $t4, $t5, actualizar_contadores
	addi $t0, $t0, 1
	addi $t4, $t4, 1
	sw $t0, chacales_encontrados
	
	lw $t0, casilla
	addi $t0, $t0, -1
	la $t2, tablero
	add $t2, $t2, $t0
    	li $t5, 67                	# Cargar el carácter 'C' en $t5
    	sb $t5, 0($t2)
	la $a0, tablero       		# Pasar la dirección base de tablero a $a0
    	li $a1, 12            		# Pasar el tamaño del tablero a $a1
    	jal imprimir_tablero  		# Llamar a la función imprimir_tablero

	li $v0, 4
    	la $a0, mensaje_progreso_chacal
    	syscall
    	jal mostrar_progreso
    	
	lw $t0, chacales_encontrados
	move $t0, $t0
    	li $t3, 4
    	beq $t0, $t3, perdio
	j validacion

caso_tesoros:
	lw $t0, casilla
	addi $t0, $t0, -1
	la $t2, tablero
	add $t2, $t2, $t0
    	li $t5, 88                	# Cargar el carácter 'C' en $t5
    	sb $t5, 0($t2)
	la $a0, tablero			# Pasar la dirección base de tablero a $a0
    	li $a1, 12            		# Pasar el tamaño del tablero a $a1
    	jal imprimir_tablero  		# Llamar a la función imprimir_tablero
    	  	  	  	
	# si no es un tesoro, es un chacal
	addi $t1, $t1, 1
	sw $t1, tesoros_encontrados
	addi $t9, $t9, 100
	sw $t9, dinero_acumulado
	li $v0, 4
    	la $a0, mensaje_progreso_tesoro
    	syscall
	jal mostrar_progreso
	
	lw $t2, tesoros_encontrados
	move $t2, $t2
	
	li $t4, 4
	beq  $t1, $t4, gano
	j validacion
	
validacion:
    	li $v0, 4
    	la $a0,nuevo_linea
    	syscall
    	
    	li $v0, 4
    	la $a0, pregunta
    	syscall 
    		
    	li $v0, 8
    	la $a0, respuesta
    	li $a1, 3
    	syscall
    
    	# Comparar con "si"
    	la $a0, respuesta         	# Dirección de la entrada del usuario
    	la $a1, si       		# Dirección de la cadena "si"
    	jal comparar_cadenas
    	beq $v0, 1, continuar        	# Si es igual, ir al fin del programa

    	# Comparar con "no"
    	la $a0, respuesta        	# Dirección de la entrada del usuario
    	la $a1, no       		# Dirección de la cadena "no"
    	jal comparar_cadenas
    	beq $v0, 1, finalizar        	# Si es igual, ir al fin del programa
	
	li $v0, 4
    	la $a0, repetir
    	syscall
	
	j validacion

mostrar_progreso:
	li $v0, 4
    	la $a0, progreso
    	syscall

	li $v0, 4
    	la $a0, mensaje_chacales
    	syscall
    	
    	lw $t0, chacales_encontrados
	li $v0, 1
    	move $a0, $t0
    	syscall
    	
    	li $v0, 4
    	la $a0, mensaje_dinero
    	syscall
    	
    	lw $t0, dinero_acumulado
	li $v0, 1
    	move $a0, $t0
    	syscall

	li $v0, 4
    	la $a0, nuevo_linea
    	syscall
    	jr $ra
    	
continuar:
    	j Loop

gano:
	li $v0, 4
    	la $a0, mensaje_gano
    	syscall
	j finalizar
	
perdio:
	lw $t0, dinero_acumulado
    	li $t0, 0                
    	sw $t0, dinero_acumulado
    	
	li $v0, 4
    	la $a0, mensaje_perdio
    	syscall
	j finalizar

defaut:
	lw $t0, dinero_acumulado
    	li $t0, 0                
    	sw $t0, dinero_acumulado
    	
	li $v0, 4
    	la $a0, mensaje_default
    	syscall
	j finalizar

finalizar:
	li $v0, 4
    	la $a0, separacion
    	syscall

	li $v0, 4
    	la $a0, agradecimiento
    	syscall

	li $v0, 4
    	la $a0, mensaje_tesosoros
    	syscall
    	
    	lw $t0, tesoros_encontrados
	li $v0, 1
    	move $a0, $t0
    	syscall
    	
	li $v0, 4
    	la $a0, mensaje_chacales
    	syscall
    	
    	lw $t0, chacales_encontrados
	li $v0, 1
    	move $a0, $t0
    	syscall
    	
    	li $v0, 4
    	la $a0, mensaje_dinero
    	syscall
    	
    	lw $t0, dinero_acumulado
	li $v0, 1
    	move $a0, $t0
    	syscall

	li $v0, 4
    	la $a0, nuevo_linea
    	syscall
    		
    	li $v0, 10            # Syscall para salir del programa
    	syscall

comparar_cadenas:
    	move $t0, $a0          # Dirección de la primera cadena en $t0
    	move $t1, $a1          # Dirección de la segunda cadena en $t1

comparar_loop:
    	lb $t2, 0($t0)         		# Cargar byte de la primera cadena en $t2
    	lb $t3, 0($t1)         		# Cargar byte de la segunda cadena en $t3
    	bne $t2, $t3, cadenas_diferentes  	# Si los bytes son diferentes, cadenas son diferentes
    	beq $t2, $zero, cadenas_iguales  	# Si es el final de la cadena, son iguales
    	addi $t0, $t0, 1       		# Avanzar al siguiente byte de la primera cadena
    	addi $t1, $t1, 1       		# Avanzar al siguiente byte de la segunda cadena
    	j comparar_loop

cadenas_diferentes:
    	li $v0, 0		# Indicar que son diferentes
    	jr $ra

cadenas_iguales:
    	li $v0, 1			# Indicar que son iguales
    	jr $ra

#Fin de lógica de juego
 		  		  		  	

# Función para imprimir el tablero
imprimir_tablero:
    	move $t0, $a0         # Mover la dirección base del tablero a $t0
    	move $t2, $a1         # Mover el tamaño del tablero a $t2

imprimir_loop:
    	beq $t2, $zero, imprimir_nueva_linea 	# Si hemos impreso las 12 casillas, salir del bucle
    	lb $t3, 0($t0)        			# Cargar el valor de la posición actual del tablero en $t3
    	move $a0, $t3         			# Mover el valor a $a0 para imprimir
    	li $v0, 11            			# Syscall para imprimir un carácter
    	syscall
    	li $v0, 4
    	la $a0, espacio
    	syscall
    
    	addi $t0, $t0, 1      			# Incrementar el puntero de la dirección del tablero
    	subi $t2, $t2, 1      			# Decrementar el contador de casillas por imprimir
    	j imprimir_loop       			# Volver al inicio del bucle

imprimir_nueva_linea:
    	# Imprimir una nueva línea después de imprimir el tablero
    	li $v0, 4
    	la $a0, nuevo_linea
    	syscall
    	jr $ra


# Función para mezclar el array posiciones
shuffle_posiciones:
    	move $t0, $a0         # Mover la dirección base del array `posiciones` a $t0
    	move $t1, $a1         # Mover el tamaño del array `posiciones` a $t1
    	li $t4, 24            # Definir un número de mezclas (2 veces el tamaño del array)

shuffle_loop:
    	beq $t4, $zero, fin_shuffle  	# Si hemos hecho todas las mezclas, salir del bucle

    	# Generar el primer índice aleatorio
    	li $v0, 42
    	syscall
    	mul $t2, $a0, 4       		# Calcular el desplazamiento en bytes (tamaño del entero)

    	# Generar el segundo índice aleatorio
    	li $v0, 42            		# Syscall para generar un número aleatorio
    	syscall
    	mul $t3, $a0, 4       		# Calcular el desplazamiento en bytes (tamaño del entero)

    	# Intercambiar los valores en los dos índices aleatorios
    	add $t5, $t0, $t2     		# Calcular la dirección del primer índice
    	lw $t6, 0($t5)        		# Cargar el valor en el primer índice

    	add $t7, $t0, $t3     		# Calcular la dirección del segundo índice
    	lw $t8, 0($t7)        		# Cargar el valor en el segundo índice

    	sw $t8, 0($t5)        		# Almacenar el valor del segundo índice en el primer índice
    	sw $t6, 0($t7)        		# Almacenar el valor del primer índice en el segundo índice

    	subi $t4, $t4, 1      		# Decrementar el contador de mezclas
    	j shuffle_loop        		# Volver al inicio del bucle

fin_shuffle:
    	jr $ra                		# Volver a la dirección de retorno
