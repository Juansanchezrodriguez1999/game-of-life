# Usa una imagen base de Maven para compilar el proyecto
FROM maven:3.8.6-openjdk-11 AS build

# Establece el directorio de trabajo
WORKDIR /build

# Copia el archivo pom.xml y los archivos de configuración necesarios
COPY pom.xml .

# Copia los archivos pom.xml de los módulos
COPY gameoflife-core/pom.xml gameoflife-core/
COPY gameoflife-web/pom.xml gameoflife-web/

# Descarga las dependencias sin construir el proyecto
RUN mvn dependency:go-offline

# Copia el resto del código fuente
COPY . .

# Compila el proyecto y empaqueta la aplicación web
RUN mvn clean package -pl gameoflife-web -am -DskipTests

# Usa una imagen base de OpenJDK para ejecutar la aplicación
FROM openjdk:11-jre-slim

# Establece el directorio de trabajo
WORKDIR /app

# Copia el archivo JAR desde la etapa de construcción
COPY --from=build /build/gameoflife-web/target/gameoflife-web-*.war ./gameoflife-web.war

# Exponer el puerto de la aplicación
EXPOSE 9090

# Comando para ejecutar la aplicación
CMD ["java", "-jar", "gameoflife-web.war"]
