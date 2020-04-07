Otra forma de obtener el resultado usando la probabilidad, es haciendo
sendas particiones del espacio muestral para los sucesos:

  * $C_X$: El coche está detrás de la puerta $X$,
  * $L_X$: _Monty_ abre la puerta $X$,
  
y análogamente $C_Y$, $C_Z$, $L_Y$, $L_Z$. Entonces podemos representar
el espacio muestral de un concursante que ha elegido la puerta $X$ y cuya estrategia es 
cambiar de puerta con el siguiente diagrama:

<img src="particion.jpg" style='width:80%;margin-left:auto;margin-right:auto;display:block;' />

Vemos que algunas intersecciones son imposibles (probabilidad igual a cero), por
ejemplo que _Monty_ abra la puerta que hemos elegido, o la que tiene el coche. 
Entonces si hemos elegido la puerta $X$, la probabilidad de ganar el coche será 
(ya que hemos cambiado de puerta)
$P(C_Y \cup C_Z)$, que obtenemos como:

$$P(C_Y \cap L_Z) + P(C_Z \cap L_Y) = P(C_Y)\cdot P(L_Z | C_Y) + P(C_Z)\cdot P(L_Y | C_Z) = \frac{1}{3} \cdot 1 + \frac{1}{3}\cdot 1 = \frac{2}{3}$$

El razonamiento es análogo para cualquiera de las otras dos puertas, que llevaría almismoresultado.

Vemos de nuevo cómo la probabilidad condicionada es la "culpable" de obtener
este resultado sorprendente. Esta es la explicación que da _Cristopher_,
el protagonista de "El curioso incidente del perro a medianoche" [2], en el capítulo
101 (La numeración de los capítulos ya merece la lectura del libro), que termina:

> ... la intuición es lo que la gente utiliza en la vida para tomar decisiones.
> Pero la lógica puede ayudarte a deducir la respuesta correcta ...

[2] Haddon M (2013). _El curioso incidente del perro a medianoche_. Salamandra. ISBN
978-84-9838-373-7, Traducción de Patricia Antón de Vez.
