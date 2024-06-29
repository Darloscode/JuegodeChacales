.data
	nuevo_linea: .asciiz "\n"  # Nueva línea para formato de salida
	.align 2
	tablero: .space 12 # Espacio para 12 bytes, cada uno representa una casilla
	posiciones: .space 48  # Espacio para 12 enteros (12 * 4 bytes = 48 bytes)
	chacales: .space 16    # Espacio para 4 enteros (4 * 4 bytes = 16 bytes)
	tesoros: .space 32     # Espacio para 8 enteros (8 * 4 bytes = 32 bytes)


.text
.globl main

main:
	la $t0, tablero       # Cargar la dirección base de tablero en $s0
    li $t1, 79            # Cargar el valor ASCII de 'O' en $t1
    li $t2, 12            # Número de casillas a inicializar
    	
inicializar_tablero:
    beq $t2, $zero, inicializar_posiciones  # Si hemos inicializado las 12 casillas, saltar al final
    sb $t1, 0($t0)        # Almacenar el valor de 'O' en la posición actual del tablero
    addi $t0, $t0, 1      # Incrementar el puntero de la dirección del tablero
    subi $t2, $t2, 1      # Decrementar el contador de casillas por inicializar
    j inicializar_tablero # Volver al inicio del bucle
    	
inicializar_posiciones:
	la $s0, posiciones    # Cargar la dirección base del array `posiciones` en $s0
    li $t1, 0             # Inicializar el primer valor en 0
    li $t2, 12            # Número de enteros a inicializar

loop_posiciones:
	beq $t2, $zero, fin_posiciones  # Si hemos inicializado los 12 enteros, salir del bucle
    sw $t1, 0($s0)        # Almacenar el valor de $t1 en la posición actual del array
    addi $s0, $s0, 4      # Incrementar el puntero de la dirección del array
    addi $t1, $t1, 1      # Incrementar el valor de $t1 en 1
    subi $t2, $t2, 1      # Decrementar el contador de enteros por inicializar
    j loop_posiciones  # Volver al inicio del bucle

fin_posiciones:
    # Llamar a la función shuffle_posiciones
    la $a0, posiciones    # Pasar la dirección base del array `posiciones` a $a0
    li $a1, 12            # Pasar el tamaño del array `posiciones` a $a1
    jal shuffle_posiciones  # Llamar a la función shuffle_posiciones
    
iniciar_copia:
	# Direcciones base
	li $t0, 0 
	la $s0, posiciones
	la $s1, chacales
	la $s2, tesoros
	
copiar:
	beq $t0, 12, salir
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
	
salir:
    # Llamar a la función imprimir_tablero
    la $a0, tablero       # Pasar la dirección base de tablero a $a0
   	li $a1, 12            # Pasar el tamaño del tablero a $a1
    jal imprimir_tablero  # Llamar a la función imprimir_tablero
    
    # imprimir chacales
	li $t0, 0 
	la $s0, tesoros
	li $v0, 1
	
imprimir:
	beq $t0, 8, fin_imprimir
	lw $a0, 0($s0)
	syscall
	addi $t0, $t0, 1
	addi $s0, $s0, 4
	j imprimir
	
fin_imprimir:
	# Imprimir un salto de línea
    la $a0, nuevo_linea   # Cargar la dirección de la cadena en $a0
    li $v0, 4         # Código del servicio para imprimir cadena
    syscall           # Llamada al sistema para imprimir la cadena
    
    # Terminar el programa
    li $v0, 10            # Syscall para salir del programa
    syscall
    	
  
    	
    	  	
# Función para imprimir el tablero
imprimir_tablero:
    # Argumentos:
    # $a0 = dirección base del tablero
    # $a1 = tamaño del tablero
    move $t0, $a0         # Mover la dirección base del tablero a $t0
    move $t2, $a1         # Mover el tamaño del tablero a $t2

imprimir_loop:
    beq $t2, $zero, imprimir_nueva_linea # Si hemos impreso las 12 casillas, salir del bucle
    lb $t3, 0($t0)        # Cargar el valor de la posición actual del tablero en $t3
    move $a0, $t3         # Mover el valor a $a0 para imprimir
    li $v0, 11            # Syscall para imprimir un carácter
    syscall
    addi $t0, $t0, 1      # Incrementar el puntero de la dirección del tablero
    subi $t2, $t2, 1      # Decrementar el contador de casillas por imprimir
    j imprimir_loop       # Volver al inicio del bucle

imprimir_nueva_linea:
    # Imprimir una nueva línea después de imprimir el tablero
    li $v0, 4
    la $a0, nuevo_linea
    syscall
    jr $ra                # Volver a la dirección de retorno  	
    
# Función para mezclar el array posiciones
shuffle_posiciones:
    # Argumentos:
    # $a0 = dirección base del array `posiciones`
    # $a1 = tamaño del array `posiciones`
    move $t0, $a0         # Mover la dirección base del array `posiciones` a $t0
    move $t1, $a1         # Mover el tamaño del array `posiciones` a $t1

    # Definir el número de mezclas
    li $t4, 24            # Definir un número de mezclas (2 veces el tamaño del array)

shuffle_loop:
    beq $t4, $zero, fin_shuffle  # Si hemos hecho todas las mezclas, salir del bucle

    # Generar el primer índice aleatorio
    li $v0, 42
    syscall
    mul $t2, $a0, 4       # Calcular el desplazamiento en bytes (tamaño del entero)

    # Generar el segundo índice aleatorio
    li $v0, 42            # Syscall para generar un número aleatorio
    syscall
    mul $t3, $a0, 4       # Calcular el desplazamiento en bytes (tamaño del entero)

    # Intercambiar los valores en los dos índices aleatorios
    add $t5, $t0, $t2     # Calcular la dirección del primer índice
    lw $t6, 0($t5)        # Cargar el valor en el primer índice

    add $t7, $t0, $t3     # Calcular la dirección del segundo índice
    lw $t8, 0($t7)        # Cargar el valor en el segundo índice

    sw $t8, 0($t5)        # Almacenar el valor del segundo índice en el primer índice
    sw $t6, 0($t7)        # Almacenar el valor del primer índice en el segundo índice

    subi $t4, $t4, 1      # Decrementar el contador de mezclas
    j shuffle_loop        # Volver al inicio del bucle

fin_shuffle:
    jr $ra                # Volver a la dirección de retorno
