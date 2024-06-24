import random

def inicializar_tablero():
    # Creamos un tablero con 12 casillas inicialmente ocultas
    tablero = ['Oculto'] * 12
    return tablero

def distribuir_elementos():
    # Distribuimos 4 chacales y 8 tesoros aleatoriamente
    elementos = ['Chacal'] * 4 + ['Tesoro'] * 8
    random.shuffle(elementos)
    return elementos

def mostrar_tablero(tablero):
    # Mostramos el estado actual del tablero
    print("\nEstado actual del tablero:")
    for i in range(12):
        print(f"Casilla {i+1}: {tablero[i]}")

def jugar():
    tablero = inicializar_tablero()
    elementos = distribuir_elementos()
    dinero_acumulado = 0
    tesoros_encontrados = 0
    chacales_encontrados = 0
    consecutivo_repetido = 0
    
    while tesoros_encontrados < 4:
        # Mostramos el tablero y la información actual
        mostrar_tablero(tablero)
        print(f"Dinero acumulado: ${dinero_acumulado}")
        print(f"Tesoros encontrados: {tesoros_encontrados}")
        print(f"Chacales encontrados: {chacales_encontrados}")
        
        # Generamos un número aleatorio entre 1 y 12 (casillas del tablero)
        numero_casilla = random.randint(1, 12) - 1
        
        # Verificamos si la casilla ya ha sido descubierta
        if tablero[numero_casilla] != 'Oculto':
            consecutivo_repetido += 1
            if consecutivo_repetido == 3:
                print("Perdiste por repetir tres veces seguidas casillas ya descubiertas.")
                break
            continue
        
        # Descubrimos la casilla y vemos qué hay en ella
        tablero[numero_casilla] = elementos[numero_casilla]
        
        if elementos[numero_casilla] == 'Chacal':
            chacales_encontrados += 1
            print(f"Encontraste un chacal en la casilla {numero_casilla + 1}. ¡Has perdido!")
            break
        elif elementos[numero_casilla] == 'Tesoro':
            tesoros_encontrados += 1
            dinero_acumulado += 100
            print(f"Encontraste un tesoro en la casilla {numero_casilla + 1}. +$100")
        
        # Reiniciamos el contador de casillas repetidas consecutivas
        consecutivo_repetido = 0
    
    # Mostramos resultados finales
    print("\nJuego terminado.")
    print(f"Total de tesoros encontrados: {tesoros_encontrados}")
    print(f"Dinero acumulado final: ${dinero_acumulado}")

# Iniciamos el juego
jugar()
