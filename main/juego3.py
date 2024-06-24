import random

# Definir constantes
DINERO_POR_TESORO = 100
NUMERO_CASILLAS = 12
NUMERO_TESOROS = 8
NUMERO_CHACALES = 4
NUMERO_MAX_REPETICIONES_CASILLA = 3

# Inicializar variables
tesoros_encontrados = 0
chacales_encontrados = 0
dinero_acumulado = 0
casillas_descubiertas = []
repetidas_consecutivas = 0

# Función para inicializar el tablero
def inicializar_tablero():
    tablero = ["Oculto"] * NUMERO_CASILLAS

    # Distribuir tesoros y chacales aleatoriamente
    for _ in range(NUMERO_TESOROS):
        while True:
            casilla = random.randint(0, NUMERO_CASILLAS - 1)
            if tablero[casilla] != "Tesoro":
                tablero[casilla] = "Tesoro"
                break

    for _ in range(NUMERO_CHACALES):
        while True:
            casilla = random.randint(0, NUMERO_CASILLAS - 1)
            if tablero[casilla] != "Chacal":
                tablero[casilla] = "Chacal"
                break

    return tablero

# Función para mostrar el tablero
def mostrar_tablero(tablero):
    print("\nTablero actual:")
    for casilla in tablero:
        print(f"[ {casilla} ]", end="")

# Función para tirar el dado
def tirar_dado():
    return random.randint(1, NUMERO_CASILLAS)

# Función para descubrir una casilla
def descubrir_casilla(tablero, casilla):
    global tesoros_encontrados, chacales_encontrados, dinero_acumulado

    if tablero[casilla] == "Tesoro":
        tesoros_encontrados += 1
        dinero_acumulado += DINERO_POR_TESORO
        print(f"¡Encontraste un tesoro! Ganaste ${DINERO_POR_TESORO}")
    elif tablero[casilla] == "Chacal":
        chacales_encontrados += 1
        print(f"¡Encontraste un chacal!")
    else:
        print(f"La casilla está vacía.")

# Función para actualizar el juego
def actualizar_juego(tablero):
    global repetidas_consecutivas

    casilla_descubierta = tirar_dado()

    while casilla_descubierta in casillas_descubiertas:
        repetidas_consecutivas += 1
        if repetidas_consecutivas == NUMERO_MAX_REPETICIONES_CASILLA:
            print("¡Perdiste! Descubriste la misma casilla 3 veces seguidas.")
            return False

        casilla_descubierta = tirar_dado()
        repetidas_consecutivas = 0

    casillas_descubiertas.append(casilla_descubierta)

    descubrir_casilla(tablero, casilla_descubierta)

    mostrar_tablero(tablero)

    print(f"\nDinero acumulado: ${dinero_acumulado}")
    print(f"Tesoros encontrados: {tesoros_encontrados}")
    print(f"Chacales encontrados: {chacales_encontrados}")

    return True

# Función para jugar
def jugar():
    global tesoros_encontrados, chacales_encontrados, dinero_acumulado, casillas_descubiertas, repetidas_consecutivas

    # Inicializar variables de juego
    tesoros_encontrados = 0
    chacales_encontrados = 0
    dinero_acumulado = 0
    casillas_descubiertas = []
    repetidas_consecutivas = 0

    # Inicializar tablero
    tablero = inicializar_tablero()

    # Mostrar instrucciones
    print("\nBienvenido al Juego de Chacales!")
    print("El objetivo es encontrar 4 tesoros antes de encontrar 3 chacales.")
    print("Cada tesoro te dará $100. ¡Buena suerte!")

    # Bucle principal del juego
    while True:
        if tesoros_encontrados == NUMERO_TESOROS:
            print("\n¡Felicidades! Ganaste el juego con 4 tesoros y $")


jugar()