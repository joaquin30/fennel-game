# Fennel Game

Curso Lenguajes de Programación - UCSP

- Bruno Fernandez
- Carlos Castro
- Fredy Quispe
- Joaquin Pino

## Instalación y ejecución

1. Descarga el código fuente
2. Descarga Love2D y que este el comando "love" en el PATH
3. En la carpeta principal del código fuente abre una terminal y ejecuta "love ."

## Controles

- X: Dash horizontal
- C: Saltar
- Flecha izq.: Caminar a la izquierda
- Flecha der.: Caminar a la derecha

## Librerias y herramientas usadas

- Love2D
- bump.lua
- anim8
- push
- Fennel
- Tiled Map Editor

## Para crear un nivel

Creas un nuevo mapa en Tiled, seleccionas como terreno
`map/terrain.tsx` y empiezas a dibujar. Para dibujar
tierra y bordes usa la pestaña "Terrain sets" y para
dibujar pinchos usa directamente "Conjunto de patrones"

Después exportas el mapa como csv y transformas el csv
a un archivo de fennel en la ruta `map/level` (cambias las comas por espacios y agrega
una corchete inicial y final al inicio y fin del archivo). 
El nombre preferiblemente debe ser un número para seguir la convención.

Luego copias los contenidos del archivo `scene/level1.fnl` a un nuevo
archivo que sera el nuevo nivel y cambias las 3 constantes que se
encuentran en las lineas 10, 11 y 12 según corresponda.
