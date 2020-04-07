Considermos dos jugadores con dos estrategias distintas:

1. Cambia de puerta
2. No cambia de puerta

El problema sería encontrar la probabilidd de que cada uno de estos jugadores
gane el coche. La [definición clásica o de _Laplace_ de la probabilidad](http://emilio.lcano.com/b/eee/_book/ch-introprob.html#definición-clásica-o-de-laplace)
nos permite calcular
la probabilidad enumerando el número de resultados posibles en un
determinado experimento (o juego), y también el número de casos favorables
a un determinado resultado. Entonces, si queremos calcular la probabilidad
de ganar el coche bajo una determinada estrategia, enumeramos los casos posibles
y favorables y tenemos:

$$P(coche) = \frac{\text{casos favorables}(\text{coche})}{\text{casos posibles}}$$

En nuestro concurso, consideramos por separado las dos estrategias. En 
la estrategia de no cambiar de puerta, como tenemos tres puertas, entonces
hay tres casos posibles: {coche, cabra, cabra}. Como nos vamos a quedar
con la primera opción, hay un solo caso favorable a ganar el coche, que es
haberlo elegido a la primera. Entonces:

$$P(\text{coche}|\text{no cambio})=\frac{1}{3}$$

El simbolo `|` se lee "condicionado a". Es decir, la probabilidad de ganar el coche
condicionado a que no se cambia de puerta, es $\frac{1}{3}\simeq{0,33}$, la
tercera parte de las veces ganaremos el coche.

Si pensamos ahora en la estrategia de cambiar de puerta, los casos posibles siguen
siendo los mismos 3. Ahora bien, si cambiamos de puerta, ¿cuántos casos hay
favorables a ganar el coche? Si hemos elegido el coche, entonces mala suerte,
al cambiar de puerta ganamos una cabra. Eso es una posibilidad. Pero si hemos
elegido una de las cabras (dos casos favorables) entonces al cambiar de puerta **seguro**
que ganaremos el coche. Por tanto:

$$P(\text{coche}|\text{cambio})=\frac{2}{3}$$

Es decir, tenemos el doble de probabilidad de ganar el coche si cambiamos de puerta,
$\frac{2}{3}\simeq 0,67$. Dos de cada tres veces ganaremos el coche. En el siguiente
diagrama se pueden contar fácilmente los casos favorables y posibles de ambas
estrategias.



