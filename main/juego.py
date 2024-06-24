import random

def inicializar_tablero():
    # Inicializar tablero con casillas ocultas y distribuir chacales y tesoros aleatoriamente
    tablero = ['O'] * 12  # 'O' representa casilla oculta
    posiciones = list(range(12))
    random.shuffle(posiciones)
    chacales = posiciones[:4]
    tesoros = posiciones[4:]
    return tablero, chacales, tesoros

def mostrar_tablero(tablero, casillas_descubiertas, chacales, tesoros):
    # Mostrar tablero con casillas descubiertas y ocultas
    for i in range(12):
        if i in casillas_descubiertas:
            if i in chacales:
                print('C', end=' ')  # 'C' representa chacal encontrado
            elif i in tesoros:
                print('$', end=' ')  # '$' representa tesoro encontrado
        else:
            print('O', end=' ')  # 'O' representa casilla oculta
    print()

def jugar():
    tablero, chacales, tesoros = inicializar_tablero()

    casillas_descubiertas = []
    casillas_repetidas = []
    chacales_encontrados = 0
    tesoros_encontrados = 0
    dinero_acumulado = 0
    turnos_consecutivos_repetidos = 0
    max_turnos_repetidos_permitidos = 3
    continuar = ""

    print("¡Bienvenido al Juego de Chacales!")
    while chacales_encontrados < 8 and turnos_consecutivos_repetidos !=3 and tesoros_encontrados < 4 and continuar!="No":
        continuar = ""
        print()
        mostrar_tablero(tablero, casillas_descubiertas, chacales, tesoros)
        opcion = random.randint(1, 12) - 1
        print("Numero: ", opcion)
        
        if opcion in casillas_descubiertas:
            casillas_repetidas.append(opcion)
            repetido = casillas_repetidas.count(opcion)
            if repetido == 2:
                dinero_acumulado = 0
                continuar = "No"
                turnos_consecutivos_repetidos = 3
                print("\nHas descubierto el mismo número de casilla 3 veces consecutivas. Has perdido el juego.")
                finalizar_juego(tesoros_encontrados, dinero_acumulado, chacales_encontrados)
            else:
                print(f"\nAdvertencia: El número {opcion} ya ha salido {repetido+1} veces. Tenga cuidado!!")
        else:   
            casillas_descubiertas.append(opcion)
            if opcion in chacales:
                print("\n¡Has encontrado un chacal!")
                chacales_encontrados += 1
                mostrar_proceso(dinero_acumulado, chacales_encontrados)
            elif opcion in tesoros:
                tesoros_encontrados += 1
                dinero_acumulado += 100
                print(f"\n¡Has encontrado un tesoro!")
                mostrar_proceso(dinero_acumulado, chacales_encontrados)
            
            if tesoros_encontrados == 4:
                continuar = "No"
                print("\n¡Felicidades! ¡Has encontrado todos los tesoros y ganado el juego!")
                finalizar_juego(tesoros_encontrados, dinero_acumulado, chacales_encontrados)
            
            if chacales_encontrados == 8:
                dinero_acumulado = 0
                continuar = "No"
                print("\n¡Has perdido! ¡Has encontrado todos los chacales! :'( ")
                finalizar_juego(tesoros_encontrados, dinero_acumulado, chacales_encontrados)

        while continuar!="Si" and continuar!="No":
            continuar = input("\n¿Quiere seguir jugando?Si/No: ").strip().title()
            if continuar!="Si" and continuar!="No":
                print("Ingrese una opcion correcta")


def mostrar_proceso(dinero_acumulado, chacales_encontrados):
    print(f"\nProgreso")
    print(f"Dinero acumulado: ${dinero_acumulado}")
    print(f"Número de chacales encontrados: {chacales_encontrados}")

def finalizar_juego(tesoros_encontrados, dinero_acumulado, chacales_encontrados):
    print(f"\nResumen del juego:")
    print(f"Tesoros encontrados: {tesoros_encontrados}")
    print(f"Dinero acumulado: ${dinero_acumulado}")
    print(f"Número de chacales encontrados: {chacales_encontrados}")
    print("Gracias por jugar.")

# Ejecutar el juego
if __name__ == "__main__":
    jugar()
