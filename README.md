
# _Introducción_

## Entorno de desarrollo

Esta práctica ha sido desarrollada en el framework _Cocoa_ que permite el desarrollo de aplicaciones nativas para el sistema operativo Mac OS X.

Personalmente Cocoa me ha parecido un framework muy potente que muchas veces te ayuda, pero, por otro lado, Apple es muy estricto en como realizar aplicaciones para que cumplan su estilo por lo que me hubiera gustado que hubiera mas libertad por parte de la empresa.

## Lenguaje utilizado

El lenguaje utilizado en esta práctica es _Objective-C,_ un lenguaje de programación orientado a objetos creado como un superconjunto de C.

También se podría haber utilizado el lenguaje _Swift_, ya que es una versión mejorada de _Objective-C_ y presenta muchas más facilidades y más potencia a la hora del desarrollo.

Personalmente Objective-C me ha parecido simple, pero al mismo tiempo tedioso en cuanto a nomenclatura, habiendo desarrollado aplicaciones para android es un cambio bastante grande pasar de un lenguaje como Java o Kotlin con un IDE extremadamente potente a este lenguaje, y como se ha dicho con anterioridad al entorno también. Sin embargo, no he tenido problemas mayores con el lenguaje.

## Objetivos de la práctica

El objetivo principal de esta práctica es construir una aplicación que permita la representación gráfica de funciones.
# Manual de Usuario

## Funcionamiento

La funcionalidad mínima que posee la aplicación es representar los siguientes tipos de ecuaciones dados los valores de los parámetros:

- a*sen(b*x)

- a*cos(b*x)

- a*xn

- a*x +b

- a*x2 +b*x+c

- a/(b*x)

La selección de cualquiera de las ecuaciones anteriores, así como sus parámetros se podrá modificar a través de una segunda ventana de preferencias a la que accederemos mediante el menú de la aplicación.

![Sample image](/readmeAssets/menu.png?raw=true "menu")

Este menú consta de 3 pestañas:

- Gráficas predefinidas:
![Sample image](/readmeAssets/predefined_functions.png?raw=true "predefined_functions")
- Intérprete de ecuaciones:
![Sample image](/readmeAssets/equationInterpeter.png?raw=true "equationInterpeter")
 - Preferencias visuales:
  ![Sample image](/readmeAssets/personalizeTab.png?raw=true "personalizeTab")


### Gráficas predefinidas

En esta pestaña se podrá añadir cualquiera de las gráficas citadas anteriormente. Primero se deberá seleccionar el tipo de gráfica, después, se mostrarán los parámetros necesarios en la tabla de parámetros. Una vez añadidos los valores de los parámetros y el nombre de la función se activará el botón de añadir gráfica.

Una vez añadida la gráfica, ésta pasará a la tabla de gráficas pendientes por representar. Seleccionando cualquiera de las gráficas en esta tabla podremos enviarla a la tabla de gráficas representadas y se activará el botón de pintar.

### Intérprete de ecuaciones

En esta pestaña deberemos seleccionar el número de parámetros que queremos que tenga nuestra ecuación. Una vez seleccionados estos valores y el nombre de la función a representar, podremos escribir la ecuación deseada.

El botón de añadir solo se activará cuando se haya escrito una ecuación válida.

Las operaciones definidas por el intérprete son las siguientes:
- Seno (_sin, sen_)

- Coseno (_cos_)

- Tangente (_tan, tag, tg_)

- Seno hiperbólico (_senh, sinh_)

- Coseno hiperbólico (_cosh_)

- Tangente hiperbólica (_tanh, tagh, tgh_)

- Logaritmo neperiano (_log, ln_)

- Raíz cuadrada (_sqrt_)

- Valor absoluto (_abs_)


### Preferencias visuales

En esta pestaña podremos realizar varias funciones:

- Modificar atributos de cada ecuación:

	- Color

	- Ancho de traza

	- Nombre

- Modificar atributos de la vista principal:

	- Color de fondo

	- Grid

	- Marcas numéricas

	- Calidad de representación
		- Baja

		- Media

		- Alta: No apta para Macs lentos, ya que en un intervalo amplio puede conllevar una ejecución lenta.

- Modificar Dominio y recorrido de representación
- Exportar representación a los siguientes formatos:
	- PNG

	- GIF

	- JPEG

	- JP2 (JPEG 2000)

	- BMP


# Manual del programador

## Diagrama de clases

Nuestro diagrama de clases consta principalmente de 2 paquetes:

- Math: Correspondiente al intérprete de ecuaciones.

- EquationDrawer: Paquete principal el cual contiene el MVC

![Sample image](/readmeAssets/mainClassDiagram.png?raw=true "mainClassDiagram")

Debido al gran tamaño de los módulos los veremos por separado:

![Sample image](/readmeAssets/mathClassDiagram.png?raw=true "mathClassDiagram")

![Sample image](/readmeAssets/equationDrawerClassDiagram.png?raw=true "equationDrawerClassDiagram")

![Sample image](/readmeAssets/both.png?raw=true "both")


## Glosario de clases

Primero nos encontramos con el paquete _Math_ en el que se incluyen las siguientes las siguientes clases:

- _EquationParser:_ Esta clase es la encargada de transformar la ecuación introducida por el usuario a un _NSMutableArray,_ el cual necesita nuestra clase _EquationSolver_. El procedimiento es muy sencillo:
	1. Se comprueba que los paréntesis estén balanceados, es decir, que haya el mismo número de paréntesis cerrados que abiertos y éstos se correspondan entre sí.
	2. Se comprueba que el usuario ha introducido correctamente los parámetros y las operaciones, es decir, que el usuario no ha introducido ningún parámetro no establecido o ninguna operación no citada anteriormente.
	3. Genera el _NSMutableArray._

- _EquationSolver:_ Esta clase recibe el _NSMutableArray_ desde nuestra clase _EquationParser_ y resuelve las operaciones siguiendo el siguiente orden:
	1. Paréntesis más anidados
	2. Operaciones (cosenos, senos, tangentes…)
	3. Exponentes
	4. Multiplicaciones y divisiones
	5. Sumas y restas

	No entraremos en detalle del funcionamiento interno del intérprete ya que mayoritariamente busca datos y realiza operaciones aritméticas.

- _Operation:_ En esta clase guardamos nuestras operaciones, así como algunos atributos necesarios para el correcto funcionamiento de la clase _EquationSolver y EquationParser._
- _Stack:_ Esta clase representa a un tipo abstracto de datos Pila necesario para el correcto funcionamiento de la clase _BalancedParentheses._
- _BalancedParentheses:_ Esta clase recibe un _NSString_ y devuelve un _boolean_ dependiendo de si la ecuación tiene paréntesis balanceados o no.

Respecto al paquete EquationDrawer podremos diferenciar las siguientes clases:

- _Chart:_ Esta clase representa nuestra vista principal, es decir, donde representamos las funciones. Los objetivos principales de esta clase son:

	- Realizar la transformación afín
	- Dibujar el eje de coordenadas
	- Dibujar el Grid
	- Dibujar las marcas numéricas
	- Responder a los eventos de ratón
		- Hacer zoom con la ruleta
		- Dibujar rectángulo para ampliar
		- Hacer zoom con botones

- _GraphicsController:_ Esta clase es la encargada del funcionamiento lógico de nuestra aplicación. Es la encargada de mediar entre la vista y el modelo y crear la ventana de preferencias. También será el encargado de atender las notificaciones mandadas por nuestro _PreferencesWindow._

- _Equation:_ Esta clase representa una ecuación la cual se representará sobre nuestra vista _Chart_. Consta de un _EquationParser y EquationSolver_ para proporcionar los valores “y” de la ecuación.

- _EquationData:_ Esta clase es utilizada para nuestra pestaña de _gráficas por defecto_ y guarda el nombre de la ecuación, valores de los parámetros…

- _Model:_ Es donde se almacenan todos los datos usados por la aplicación.

- _PreferencesWindow:_ Esta clase realiza toda la lógica de las 3 pestañas explicadas anteriormente.

## Dificultades pasadas

1. Rendimiento del sistema operativo

	- Dada la ausencia de un Mac, el trabajo se ha realizado mayoritariamente en una máquina virtual cuya potencia es mucho menor que la podríamos obtener con un sistema operativo no virtualizado.

2. Rendimiento de la práctica

	- Para representar funciones en un intervalo extenso es necesario una gran cantidad de puntos para la correcta visualización de las gráficas. Por este motivo se ha añadido un _Slider_ para configurar la calidad de representación.

3. Intérprete de ecuaciones

	- Dada la alta complejidad de un analizador sintáctico de ecuaciones se ha realizado una versión incompleta de dicho tipo de intérprete. Sin embargo, el comportamiento de este analizador permite calcular la gran mayoría de ecuaciones lineales dotándolo así de una gran potencia.

4. Dibujar números:
	- El principal problema que no se ha podido resolver es el de dibujar en la vista _Chart_ los números del intervalo. Esto es debido a que cuando el dominio y el recorrido varían hacen que el tamaño de nuestro _Chart_ varíe en una amplia gama de valores. Por ejemplo, si el usuario quiere representar el intervalo: (-100<x<100), (-1y<-1) Hace que la altura de nuestra vista sea 2 frente a 200 de ancho lo que hace que el texto sea pequeño.



## Posibles mejoras

Dadas las dificultades mencionadas anteriormente, esta práctica podría haberse mejorado aún más, pero esto no ha sido posible por falta de tiempo.

A continuación, enumero algunas de las posibles mejoras a realizar:

- Representación de números

- Limpieza de código

- Modularidad

- Mejorar la interfaz de usuario

- Documentación de código

## Funcionalidades que destacar

Dado que se trata de un trabajo con una funcionalidad mínima vamos a destacar algunas funcionalidades especiales que se han implementado de manera opcional para incrementar el potencial de este representador gráfico de funciones:

1. Intérprete de ecuaciones

2. Hacer zoom dibujando un rectángulo

3. Hacer zoom con la ruleta del ratón

4. Rastreador de posición del ratón

5. Modificar intervalos en ambos ejes y modificar el centro

6. Exportar a varios ficheros con un panel para guardar



# Referencias

- Transformar un NSView a un fichero de imagen:

	- [https://gist.github.com/nacho4d/1283598](https://gist.github.com/nacho4d/1283598)

- Crear un cuadro de diálogo para guardar archivos, en nuestro caso las imágenes generadas:

	- [https://pinkstone.co.uk/how-to-create-a-save-as-dialogue-with-nssavepanel/](https://pinkstone.co.uk/how-to-create-a-save-as-dialogue-with-nssavepanel/)

- Implementación de tipo abstracto de datos _Stack_:

	- [https://github.com/mattjgalloway/MJGFoundation/blob/master/Source/Model/MJGStack.m](https://github.com/mattjgalloway/MJGFoundation/blob/master/Source/Model/MJGStack.m)

	- [https://github.com/mattjgalloway/MJGFoundation/blob/master/Source/Model/MJGStack.h](https://github.com/mattjgalloway/MJGFoundation/blob/master/Source/Model/MJGStack.h)

- Animación para _TextField_

	- [https://stackoverflow.com/questions/29351520/shake-animation-for-nstextfield](https://stackoverflow.com/questions/29351520/shake-animation-for-nstextfield)

- Representador de gráficas del que se han tomado varias ideas:

	- [http://fooplot.com](http://fooplot.com)
