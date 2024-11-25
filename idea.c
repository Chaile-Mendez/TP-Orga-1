#include <stdbool.h>
#include <stdio.h>
#include <string.h>

void transponer(char matriz[7][7]);
void espejoX(char matriz[7][7]);
void imprimirTablero(char matriz[7][7]);
void inicializarTabler(char matriz[7][7]);
void poblarTablero(char tablero[7][7], char simboloPared, char simboloSoldado, char simboloVacio, char simboloOficial);
void preguntarRotacion(int *rotacion);
void preguntarSimbolo(char *simbolo, char *nombre);
void preguntarPrimerJugador(char *turnoJugador, char simboloSoldado, char simboloOficial);
void contarFichas(char tablero[7][7], char simboloOficial, char simboloSoldado, int *cantidadOficiales, int *cantidadSoldados);
void imprimirDatos(int cantidadSoldados, int cantidadOficiales, char turnoJugador);
void preguntarPosicionAMover(char tablero[7][7], char jugadorEnTurno, int* i, int *j);




int main(void)
{

    char tablero[7][7];
    const int ANCHO = 7;
    const int ALTO = 7;

    char simboloVacio = '.';
    char simboloPared = ' ';
    char simboloSoldado = 'X';
    char simboloOficial = 'O';

    bool jugando = true;

    int cantidadOficiales = 0;
    int cantidadSoldados = 0;

    char ganador = '0';
    char *mensajeFinal = "";

    char turnoJugador = simboloSoldado;

    int rotacion = 0;
    // setup
    preguntarSimbolo(&simboloSoldado, "Soldado");
    preguntarSimbolo(&simboloOficial, "Oficial");
    preguntarRotacion(&rotacion);

    preguntarPrimerJugador(&turnoJugador, simboloSoldado, simboloOficial);

    poblarTablero(tablero, simboloPared, simboloSoldado, simboloVacio, simboloOficial);


    imprimirTablero(tablero);
    imprimirDatos(cantidadOficiales,cantidadSoldados,turnoJugador);


    while (jugando)
    {

        if (cantidadOficiales < 1 && cantidadSoldados < 9){
            jugando = false;
            mensajeFinal = "Ha ocurrido un empate\n";
            break;
        }
        if (cantidadOficiales < 1){
          jugando = false;
          mensajeFinal = "No hay mas soldados vivos\n";
          break;
        }

        if (cantidadSoldados < 9){
            jugando = false;
            mensajeFinal = "No hay suficientes soldados para capturar el objetivo\n";
            break;
        }




        imprimirTablero(tablero);
        imprimirDatos(cantidadOficiales,cantidadSoldados,turnoJugador);

    }

    return 0;
}

void poblarTablero(char tablero[7][7], char simboloPared, char simboloSoldado, char simboloVacio, char simboloOficial)
{
    // Llenar TODO
    for (int i = 0; i < 7; i++)
    {
        for (int j = 0; j < 7; j++)
        {
            tablero[i][j] = simboloPared;
        }
    }

    // Llenar cosas
    for (int i = 0; i < 4; i++)
    {
        for (int j = 2; j < 5; j++)
        {
            tablero[i][j] = simboloSoldado;
        }
    }

    // Llenar cosas
    for (int i = 2; i < 5; i++)
    {
        for (int j = 0; j < 2; j++)
        {
            tablero[i][j] = simboloSoldado;
        }
    }

    // Llenar cosas
    for (int i = 2; i < 5; i++)
    {
        for (int j = 5; j < 7; j++)
        {
            tablero[i][j] = simboloSoldado;
        }
    }

    // Llenar cosas
    for (int i = 4; i < 7; i++)
    {
        for (int j = 2; j < 5; j++)
        {
            tablero[i][j] = simboloVacio;
        }
    }

    tablero[6][2] = simboloOficial;
    tablero[5][4] = simboloOficial;
}

void aBasico(int *x, int *y, int rotacion)
{
    // Devuelve x,y como si el tablero estuviera en su posicion base
}

void deBasico(int *x, int *y, int rotacion)
{
    // Devuelve x,y como si el tablero estuviera rotado
}

void transponer(char matriz[7][7])
{
    char aux[7][7];

    for (int i = 0; i < 7; i++)
    {
        for (int j = 0; j < 7; j++)
        {
            aux[j][i] = matriz[i][j];
        }
    }

    for (int i = 0; i < 7; i++)
    {
        for (int j = 0; j < 7; j++)
        {
            matriz[i][j] = aux[i][j];
        }
    }
}

void espejoX(char matriz[7][7])
{
    char aux[7][7];

    for (int i = 6; i >= 0; i--)
    {
        for (int j = 6; j >= 0; j--)
        {

            aux[6 - i][6 - j] = matriz[i][j];
        }
    }

    for (int i = 0; i < 7; i++)
    {
        for (int j = 0; j < 7; j++)
        {
            matriz[i][j] = aux[i][j];
        }
    }
}

void preguntarRotacion(int *rotacion)
{

    bool intentando = true;

    int rotacionesValidas[4] = {0, 90, 180, 270};


    while (intentando)
    {
        printf("Ingrese la rotacion del tablero, puede ser 0, 90, 180 o 270:\n");
        int cantidadRepuestas = scanf("%i", rotacion);

        bool esValido = false;
        int i = 0;
        while (!esValido && i < 4)
        {
            if (rotacionesValidas[i] == *(rotacion))
            {
                esValido = true;
            }
            i++;
        }

        if (cantidadRepuestas == 1 && esValido)
        {
            intentando = false;
        }
    }
}

void darRotacion(char tablero[7][7], int rotacion)
{
    switch (rotacion)
    {
    case 0:
        break;
    case 90:
        transponer(tablero);
        espejoX(tablero);
        break;
    case 180:
        transponer(tablero);
        espejoX(tablero);
        break;
    case 270:
        transponer(tablero);
        break;
    default:
        break;
    }
}

void imprimirTablero(char tablero[7][7])
{

    printf(" ");
    printf("  ");

    for (int i = 0; i < 7; i++)
    {
        printf("%i", i);
        printf("  ");
    }

    printf(" x");

    printf("\n");
    // Imprimir:

    for (int i = 0; i < 7; i++)
    {

        printf("%i", i);
        printf("  ");

        for (int j = 0; j < 7; j++)
        {
            printf("%c", tablero[i][j]);
            printf("  ");
        }
        printf("\n");
    }

    printf("\n");

    printf("y");

    printf("\n");
}

void preguntarSimbolo(char *simbolo, char *nombre)
{
    printf("Desea modificar el simbolo de el %s? ingrese S o N (si o no)\n", nombre);
    char respuesta = 'N';
    scanf("%c", &respuesta);
    if (respuesta == 'S'){
        printf("Ingrese el caracter que quiere usar para el %s:\n", nombre);
        int cantidadRespuestas = scanf("%c", simbolo);
    }
}

void preguntarPrimerJugador(char *turnoJugador, char simboloSoldado, char simboloOficial)
{

    printf("Desea elegir quien empieza la partida?  S / N \n");
    char respuesta = 'N';

    scanf("%c", &respuesta);
    if (respuesta == 'Y')
    {
        char simboloIngresado = '0';
        bool respuestaValida = false;

        while (!respuestaValida)
        {
            printf("Ingrese el simbolo de quien va a empezar la partida %c o %c:\n", simboloSoldado, simboloOficial);
            scanf("%c", &simboloIngresado);
            if (simboloIngresado == simboloSoldado)
            {
                *turnoJugador = simboloSoldado;
                respuestaValida = true;
            }
            if (simboloIngresado == simboloOficial)
            {
                *(turnoJugador) = simboloOficial;
                respuestaValida = true;
            }
        }
    }
}

void contarFichas(char tablero[7][7], char simboloOficial, char simboloSoldado, int *cantidadOficiales, int *cantidadSoldados)
{
    for (int i = 0; i < 7; i++)
    {
        for (int j = 0; j < 7; j++)
        {
            char simbolo = tablero[i][j];

            if (simbolo == simboloOficial)
            {
                *cantidadOficiales++;
            }
            if (simbolo == simboloSoldado)
            {
                *cantidadSoldados++;
            }
        }
    }
}

void imprimirDatos(int cantidadSoldados, int cantidadOficiales, char turnoJugador){

  printf("Es el turno del jugador con el simbolo de %c\n", turnoJugador);
  printf("Soldados restantes: %i\n", cantidadSoldados);
  printf("Oficiales restantes: %i\n", cantidadOficiales);
}

void preguntarPosicionAMover(char tablero[7][7], char jugadorEnTurno, int* i, int *j){

  bool respuestaValida = false;

  while (!respuestaValida){
      printf("Indique la posicion X,Y de la ficha que desea mover:\n");

      int i = -1;
      int j = -1;

      scanf("%i,%i", &j, &i);

      if ((j >= 0 && j <7) && (i >= 0 && i < 7)){
        char ficha = tablero[i][j];
        if (ficha == jugadorEnTurno){
          respuestaValida = true;
        }else{
          printf("Respuesta invalida\n");
        }
      }
  }
}

void agregarMovimientosOficial(char tablero [7][7], int i, int j, int movimientosValidos[32], int* tope, char simboloVacio, char simboloSoldado){

  int offsetY = 1;
  int offsetX = 1;

  int y = i + offsetY;
  int x = j + offsetX;

  if (y >= 0 && y < 7 && x >= 0 && x < 7){
     char casilla = tablero[y][x];

     if (casilla == simboloVacio){
       movimientosValidos[*tope] = x;
       *tope = *tope + 1;
       movimientosValidos[*tope] = y;
       *tope = *tope + 1;
     }

     if (casilla == simboloSoldado){
       x = x + offsetX;
       y = y + offsetY;
       if (y >= 0 && y < 7 && x >= 0 && x < 7){
             char casilla = tablero[y][x];
           if (casilla == simboloVacio){
               movimientosValidos[*tope] = x;
               *tope = *tope + 1;
               movimientosValidos[*tope] = y;
               *tope = *tope + 1;
           }
       }

     }

  }


}