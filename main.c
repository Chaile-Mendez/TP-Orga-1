#include <stdbool.h>
#include <stdio.h>
void transponer();
void espejoX();

int main(void)
{


    char tablero [7][7];
    const int ANCHO = 7;
    const int ALTO = 7;

    char vacio = '.';
    char pared = ' ';
    char soldado = 'X';
    char oficial = 'O';

    int rotacion = 0;

    //Llenar TODO
    for (int i = 0; i < ALTO; i++) {
        for (int j = 0; j < ALTO; j++) {
            tablero[i][j] = pared;
        }
    }

    //Llenar cosas
    for (int i = 0; i <4; i++) {
        for (int j = 2; j < 5; j++) {
            tablero[i][j] = soldado;
        }
    }

    //Llenar cosas
    for (int i = 2; i <5; i++) {
        for (int j = 0; j < 2; j++) {
            tablero[i][j] = soldado;
        }
    }

    //Llenar cosas
    for (int i = 2; i <5; i++) {
        for (int j = 5; j < 7; j++) {
            tablero[i][j] = soldado;
        }
    }

    //Llenar cosas
    for (int i = 4; i < 7; i++) {
        for (int j = 2; j < 5; j++) {
            tablero[i][j] = vacio;
        }
    }

    tablero[6][2] = oficial;
    tablero[5][4] = oficial;


    printf(" ");
    printf("  ");

    for (int i = 0; i <7; i++) {
        printf("%i", i);
        printf("  ");
    }

    printf(" x");

    printf("\n");
    //Imprimir:


    transponer(&tablero);
   //espejoX(&tablero);

    for (int i = 0; i < ALTO; i++) {

        printf("%i", i);
        printf("  ");

        for (int j = 0; j < ALTO; j++) {
            printf("%c", tablero[i][j]);
            printf("  ");
        }
        printf("\n");
    }

    printf("\n");

    printf("y");

    printf("\n");


    bool jugando = false;
    int oficialJugado = 1;

    while (jugando) {

        scanf("%i", &oficialJugado);
    }








    return 0;
}




void transponer(char matriz[7][7]) {
    char aux [7][7];

    for (int i = 0; i < 7; i++) {
        for (int j = 0; j < 7; j++) {
            aux[j][i] = matriz[i][j];
        }
    }

    for (int i = 0; i < 7; i++) {
        for (int j = 0; j < 7; j++) {
            matriz[i][j] = aux[i][j];
        }
    }
}

void espejoX(char matriz[7][7]) {
    char aux [7][7];

    for (int i = 6; i >= 0; i--) {
        for (int j = 6; j >=0; j--) {

            aux[6-i][6-j] = matriz[i][j];
        }
    }

    for (int i = 0; i < 7; i++) {
        for (int j = 0; j < 7; j++) {
            matriz[i][j] = aux[i][j];
        }
    }
}