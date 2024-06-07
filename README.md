# TPE - Diseño y Procesamiento de Documentos XML

El presente trabajo consiste en un programa que realiza una consulta a la página de SportRadar (https://developer.sportradar.com/) para obtener las estadísticas la competencia Nascar de algun año en particular.


## Instrucciones:

1. En primer lugar, se debe poseer una API_key válida para la página de SportRadar.

2. Establecemos la variable de entorno API_KEY, usando el siguiente comando:
    export API_KEY [Esto se debe remplazar por la key]

3. Para ejecutar el programa, se debe correr la siguiente línea de códgio en la terminal: 

   ```sh
   ./tpe.sh "sc" 2015
   ```
Reemplazando "sc" por la competencia que se quiera consultar (sc, xf, cw, go, mc) y 2015 por el año solicitado (años validos desde 2013 hasta 2023).

## Integrantes:

    Nahuel Ignacio Prado    - 64276 - naprado@itba.edu.ar
    Mateo Buela             - 64680 - mbuela@itba.edu.ar
    Luana Percich           - 64316 - lpercich@itba.edu.ar
    Lorenzo Chiossone       - 64359 - lchiossone@itba.edu.ar
