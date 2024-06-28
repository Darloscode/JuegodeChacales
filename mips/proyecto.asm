.data
	tablero: .space 12 # Espacio para 12 bytes, cada uno representa una casilla
	posiciones: .space 48  # Espacio para 12 enteros (12 * 4 bytes = 48 bytes)
	nuevo_linea: .asciiz "\n"  # Nueva línea para formato de salida


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

	beq $t2, $zero, fin_inicializacion  # Si hemos inicializado los 12 enteros, salir del bucle
    sw $t1, 0($s0)        # Almacenar el valor de $t1 en la posición actual del array
    addi $s0, $s0, 4      # Incrementar el puntero de la dirección del array
    addi $t1, $t1, 1      # Incrementar el valor de $t1 en 1
    subi $t2, $t2, 1      # Decrementar el contador de enteros por inicializar
    j inicializar_posiciones  # Volver al inicio del bucle

fin_inicializacion:
    # Llamar a la función imprimir_tablero
    la $a0, tablero       # Pasar la dirección base de tablero a $a0
   	li $a1, 12            # Pasar el tamaño del tablero a $a1
    jal imprimir_tablero  # Llamar a la función imprimir_tablero
    
	# Llamar a la función imprimir_posiciones
    la $a0, posiciones    # Pasar la dirección base del array `posiciones` a $a0
    li $a1, 12            # Pasar el tamaño del array `posiciones` a $a1
    jal imprimir_posiciones  # Llamar a la función imprimir_posiciones
    


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
    

# Función para imprimir el array posiciones
imprimir_posiciones:
    # Argumentos:
    # $a0 = dirección base del array `posiciones`
    # $a1 = tamaño del array `posiciones`
    move $t0, $a0         # Mover la dirección base del array `posiciones` a $t0
    move $t2, $a1         # Mover el tamaño del array `posiciones` a $t2

imprimir_posiciones_loop:
    beq $t2, $zero, imprimir_posiciones_nueva_linea  # Si hemos impreso los 12 enteros, salir del bucle
    lw $t3, 0($t0)        # Cargar el valor de la posición actual del array `posiciones` en $t3
    move $a0, $t3         # Mover el valor a $a0 para imprimir
    li $v0, 1             # Syscall para imprimir un entero
    syscall
    li $a0, 32            # ASCII de espacio
    li $v0, 11            # Syscall para imprimir un carácter
    syscall
    addi $t0, $t0, 4      # Incrementar el puntero de la dirección del array
    subi $t2, $t2, 1      # Decrementar el contador de enteros por imprimir
    j imprimir_posiciones_loop  # Volver al inicio del bucle

imprimir_posiciones_nueva_linea:
    # Imprimir una nueva línea después de imprimir el array `posiciones`
    li $v0, 4
    la $a0, nuevo_linea
    syscall
    jr $ra                # Volver a la dirección de retorno
