package main

import (
	"github.com/gin-gonic/gin"
	"github.com/kas/Configs"
)

var (
    port = Configs.DotEnvReader("PORT")
    db   = Configs.DBConstructor()
)

func main() {
server := gin.Default()
	server.Use(func(context *gin.Context) {
		context.Set("db", db)
		context.Next()
	})

server.Run(":" + port)

}
