Hay dos conceptos clave en Estadística que aparecen en el problema de _Monty Hall_.
El primero es el de la **aleatorización**. El resultado es el que es porque partimos
de la base que los premios se asignan a las puertas aleatoriamente. Y después,
el concursante también elige la puerta al azar entre las tres (son lo que se
llama sucesos equiprobables). El resultado sería distinto si, por poner el caso,
el concursante tuviera alguna suerte de poder adivinatorio que se salte las leyes
del azar. Este hecho es muy común en situaciones de toma de decisión en la
vida cotidiana, en los negocios, o incluso en la política. El decisor puede
tener una "corazonada", o actuar por "intuición", y entonces los sucesos
ya no son equiprobables (o hay falta de aleatorización).

El otro concepto fundamental es el de **[probabilidad 
condicionada](http://emilio.lcano.com/b/eee/_book/ch-introprob.html#probabilidad-condicionada)**.
La clave está en que la **nueva información** modifica la probabilidad **a priori**
de ganar el premio. De nuevo, en muchas situaciones de toma de decisiones 
se da por irrelevante la información disponible y no se calculan probabilidades
condicionadas (llevando a decisiones erróneas). Por ejemplo, cuando
observamos un conjunto de elementos sin considerar que puede haber
grupos en los que la característica de interés se comporta de forma
totalmente diferente, y habría que **estratificar** los datos (tratarlos
por grupos). La [fórmula de Bayes](http://emilio.lcano.com/b/eee/_book/ch-introprob.html#probabilidad-total-y-fórmula-de-bayes) nos ayuda a calcular probabilidades 
condicionadas en multitud de problemas reales. Esta fórmula queda expresada
en su versión más simple como:

$$P(A|B) = \frac{P(B|A)\cdot P(A)}{P(B)},$$

donde $A$ y $B$ son sucesos aleatorios de un mismo espacio de probabilidad.
La fórmula se extiende a tres sucesos fácilmente, que es lo que haremos a
continuación.

El problema de Monty Hall también se
puede abordar con este formalismo matemático.
Sabemos que para el concursante que no cambiará de puerta, la probabilidad
de conseguir el coche es $\frac{1}{3}$, ya que es como si en ese momento
hubiera terminado el juego. Sin embargo, para el jugador que cambia de puerta,
hay que tener en cuenta la nueva información. En términos de teoría de la
probabilidad, consideramos los sucesos:

$C_i$ La puerta $i$ tiene el coche

$J_i$ El Jugador elige la puerta $i$

$M_i$ Monty descubre la puerta $i$, $i \in \{1, 2, 3\}$

Vamos a suponer que elegimos la puerta $1$ ($J_1$), y Monty destapa la puerta $3$ ($M_3$).
El razonamiento es idéntico
para cualquiera de las otras puertas, ya que los premios se han ordenado
al azar. Entonces, si lo que buscamos es la probabilidad de obtener el 
coche, queremos calcular $P(C_2 | J_1, M_3)$. Al aplicar la fórmula de Bayes:

$$P(C_2 | M_3, J_1) = \frac{P(M_3 | C_2, J_1)\cdot P(C_2, J_1)}{P(J_1, M_3)}=*$$

Aquí aparece la información relevante. La probabilidad de que Monty 
destape la puerta 3 ($M_3$) condicionada a que el coche está en la puerta
2 y hemos elegido la puerta 1 ($C_2, J_1$) es igual... ¡a 1! Porque siempre
va a elegir la puerta de la cabra. Entonces podemos desarrollar la expresión anterior
y llegar al resultado que hemos obtenido por los otros métodos:

$$*=\frac{P(C_2, J_1)}{P(J_1, M_3)} = \frac{P(C_2)\cdot P(J_1)}{P(M_3|J_1)\cdot P(J_1)}=\frac{P(C_2)}{P(M_3|J_1)}=\frac{1/3}{1 / 2}=\frac{2}{3}.$$

