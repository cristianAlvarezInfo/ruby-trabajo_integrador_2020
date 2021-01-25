

## configuracion inicial
una vez que se descargue el repositorio debe ejecutar los siguientes comandos:

`rails db:migrate`

`rails webpacker:install`

## Uso de `rn`
Para poner en funcionamiento la aplicación, debe ejecutarse el siguiente comando en el directorio raíz del proyecto:
`rails server`

> Notá que para la ejecución de la herramienta, es necesario tener una versión reciente de
> Ruby (2.5 o posterior)

Una vez que tenga corriendo el servido podra acceder Ruby Notes, donde lo primero que deberá hacer es crearse una cuenta, al momento que se crea la cuenta, tambien se le creará un cuaderno `global` (este cuaderno no puede eliminarse, ni modificarse). 
Al iniciar sesión, será redirigido al listado de sus libros, donde inicialmente solo contará con el cuaderno `global`, desde esta vista podra:  crear nuevos cuadernos, agregar notas al cuaderno que quiera, exportar notas a HTML (pueden ser las notas de un cuaderno, o todas las notas de todos los cuadernos) y acceder al listado de notas de un cuaderno determinado. 
Desde el listado de notas de un cuaderno, podra crear nuevas notas, modificarlas y exportar su contenido



### Decisiones de diseño

Para la representacion y pesistencia de datos se utilizaron los modelos: 

`User`(provisto por la gema devise) este modelo sera utilizado para la representacion y organizacion de los usuarios que se registren en la aplicacion y tambien se utilizara para la autenticacion del usaurio para acceder a la aplicación. 

`Book` Este modelo representará a los cuadernos pertenecientes a cada usuario y organizará las notas dentro de la aplicación

`Note` este modelo representará a las notas creadas por los uaurios.

Para la exportación de notas se utilizó la gema redcarpet, la cual nos permite a partir de texto markdown generar HTML. al momento de exportar el contenido ya sea de una nota o de varias, se redireccionará al usuario a una vista donde se visualizara el resultado de exportar su contenido.

Otras de las decisiones de diseño tomadas fue aplicar las retricciones de renombre y eliminacion del cuaderno "global" en el que residiran aquellas notas a las cuales no se le especifiquen cuaderno a la hora de ser creadas.






