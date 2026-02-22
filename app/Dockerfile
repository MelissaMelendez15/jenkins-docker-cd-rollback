# Imagen base oficial ligera
FROM node:20-alpine

# Establecer el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copiamos package.json primero para aprovechar el cache de Docker
COPY package.json ./

# Instalar las dependencias
RUN npm install --production

# Copiamos el resto del código de la aplicación
COPY . .

# Exponer el puerto en el que la aplicación se ejecutará
EXPOSE 3000

# Comando de arranque de la aplicación
CMD ["npm", "start"]