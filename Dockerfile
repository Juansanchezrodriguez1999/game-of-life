# Usa una imagen base de Maven para compilar el proyecto
FROM maven:3.8.6-openjdk-11 AS build

# Establece el directorio de trabajo
WORKDIR /build

# Copia solo el archivo pom.xml para resolver dependencias primero
COPY pom.xml .

# Copia los archivos pom.xml de los módulos existentes
COPY gameoflife-core/pom.xml gameoflife-core/
COPY gameoflife-web/pom.xml gameoflife-web/

# Copia el código fuente completo (esto incluye el módulo gameoflife-build si existe)
COPY . .

# Compila el proyecto y empaqueta la aplicación web
RUN mvn clean package -DskipTests

# Usa una imagen base de OpenJDK para ejecutar la aplicación
FROM openjdk:11-jre-slim

# Establece el directorio de trabajo
WORKDIR /app

# Copia el archivo WAR desde la etapa de construcción
COPY --from=build /build/gameoflife-web/target/gameoflife-web.war ./gameoflife-web.war

# Expone el puerto que usa la aplicación
EXPOSE 9090

# Comando para ejecutar la aplicación
CMD ["java", "-jar", "gameoflife-web.war"]
