# Usa una imagen base de Java
FROM openjdk:11-jdk

# Instala Maven
RUN apt-get update && apt-get install -y maven

# Establecer el directorio de trabajo
WORKDIR /app

# Copiar el código fuente al contenedor
COPY . .

# Instalar dependencias y construir el proyecto con Maven
RUN mvn clean package

# Exponer el puerto de la aplicación (ajusta según tu aplicación)
EXPOSE 8080

# Comando para ejecutar la aplicación (ajusta según cómo se ejecute tu app)
CMD ["java", "-jar", "target/game-of-life.jar"]
