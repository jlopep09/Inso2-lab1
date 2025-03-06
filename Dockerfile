# Usa una imagen base de Go
FROM golang:1.24.1-alpine AS builder

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copia el archivo go.mod y go.sum y descarga las dependencias
COPY go.mod go.sum ./
RUN go mod tidy

# Copia el código fuente al contenedor
COPY . .

# Compila la aplicación
RUN go build -o app

# Usa una imagen base de Alpine para ejecutar la app
FROM alpine:latest

# Instala ca-certificates (necesario para HTTPS si es que haces peticiones web)
RUN apk --no-cache add ca-certificates

# Copia el binario compilado desde la imagen builder
COPY --from=builder /app/app /app

# Expone el puerto en el que la app correrá
EXPOSE 8080

# Comando para ejecutar la app
CMD ["/app"]
