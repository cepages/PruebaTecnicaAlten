# Version de Xcode y iOS minimo utilizado

XCode: 26.2

iOS: 26.2

# Instrucciones para compilar y ejecutar

## Compilar

Para compilar el proyecto simplemente abra el archivo `PruebaTecnicaAlten.xcodeproj` y presione CMD + B

## Ejecutar

Para ejecutar el proyecto, con el archivo de proyecto abierto presione CMD + R. El proyecto se ejecutara en el simulador seleccionado en la lista de dispositivos destino.

Para ejecutar en dispositivo físico es necesario configurar los provisioning profiles y certificados correctamente. Para más información visite [este enlace](https://developer.apple.com/help/account/provisioning-profiles/create-a-development-provisioning-profile/).

## Test

Para ejecutar test simplemente abra el archivo de proyecto y presione CMD + U.

# Toma de decisiones

## Arquitectura 

La arquitectura elegida ha sido VIPER, esta es una arquitectura altamente modular, mantenible y escalable. Al separar claramente las responsabilidades en capas (View, Interactor, Presenter, Entity y Router), facilita el testing, mejora la reutilización de componentes y reduce el acoplamiento entre módulos.

## Mecanismos de concurrencia

He elegido un modelo híbrido para obtener lo mejor de varios mundos:

- **Swift Concurrency (async/await)** para acciones: Es la forma más legible de gestionar peticiones de red puntuales en el Interactor. Evita el “callback hell” y hacer que el manejo de errores sea sencillo mediante try/catch.
- **Combine (@Published) para el estado**: Mientras que async/await gestiona cómo obtenemos los datos, Combine se encarga de cómo la UI se mantiene sincronizada. Al exponer el estado con publishers, la vista se vuelve reactiva: se actualiza automáticamente cada vez que cambia el estado del Presenter, asegurando una único fuente de información (source of truth).
- **Protocolos para desacoplar**: Al definir nuestros publishers y métodos asíncronos en protocolos, garantizamos que cada capa esté aislada y sea fácilmente simulable (mockable) para pruebas unitarias, como ya hemos demostrado en nuestras suites de tests.

## Test

En cada archivo de test se han creado pruebas para los principales componentes no visuales de la arquitectura.

Se incluyen tests para cada módulo, garantizando una cobertura adecuada.

Los mocks se han definido dentro de los propios archivos de test cuando su uso es específico de un único caso. En aquellos casos en los que han sido necesarios en varios archivos, se han extraído y compartido para favorecer la reutilización.

En todos los tests se han cubierto tanto los escenarios positivos como los de error, asegurando un comportamiento robusto del sistema.


# Mejoras pendientes

- **Comunicación asíncrona del Interactor:** Pasar de un protocolo de salida basado en delegados a retornos asíncronos directos con async await para lograr flujos de datos aún más simples.
- **Test sobre el network service**: Test sobre el propio NetworkService, haciendo mock sobre URLSession así como la inyección del urlsession. De esta forma podemos hacer test a todo el servicio.
- **Mejora en la lista de usuarios**: Optimizar la lista de usuarios, actualizando solo las celdas que cambian en lugar de recargar toda la tabla, lo que mejora tanto el rendimiento como la fluidez de la interfaz.

