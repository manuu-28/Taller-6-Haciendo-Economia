# Taller 6

## Equipo consultor

| Integrante        | Rol                                              |
|--------------------|---------------------------------------------------|
| Manuela Vergara   | Líder del proyecto y enlace con la ONG            |
| Santiago Gómez    | Especialista en datos y reproducibilidad          |
| Sara Vásquez      | Analista cuantitativo                             |
| Samuel Mora       | Especialista en visualización y comunicación      |

## Descripción del proyecto

El repositorio contiene el análisis de datos experimentales de un juego de bienes públicos jugado en clase en dos versiones (Juego 1 y Juego 2), cada una con 22 jugadores a lo largo de 10 períodos. Para cada jugador y período se registró la contribución individual y el pago recibido.

El análisis busca responder dos preguntas:

1. ¿Hubo diferencias en las contribuciones promedio entre los dos juegos?

2. ¿Esas diferencias pueden atribuirse al cambio en las reglas del juego, o son atribuibles al azar?

Para esto se calculan estadísticas descriptivas (media, varianza, desviación estándar, mínimo, máximo, rango) por período y por juego, se construyen gráficos de línea y de columnas de la contribución promedio a lo largo del tiempo, y se realizan pruebas t para comparar las medias del Período 1 y del Período 10 entre ambos juegos.

## Estructura del repositorio
RawData/ -> Datos originales del juego (sin editar manualmente)

DoFiles/ -> Do-files de Stata con todo el análisis reproducible

Resultados/ -> Tablas y gráficos generados por los do-files
