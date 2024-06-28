import random

def inicializar_tablero():
    # Inicializar tablero con casillas ocultas y distribuir chacales y tesoros aleatoriamente
    tablero = ['O'] * 12  # 'O' representa casilla oculta
    posiciones = list(range(12))
    random.shuffle(posiciones)
    chacales = posiciones[:4]
    tesoros = posiciones[4:]
    return tablero, chacales, tesoros

print(inicializar_tablero())