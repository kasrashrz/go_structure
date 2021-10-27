
echo "project started\n"

read -p 'Project name: ' project_name
mkdir $project_name/
cd $project_name/

read -p 'mod init: ' package
go mod init $package


touch main.go

mkdir Configs/
mkdir Configs/Environment/
touch Configs/Environment/dev.env
read -p 'project port: ' port
read -p 'database user: ' db_user
read -p 'database password: ' db_password
read -p 'database name: ' db_name
read -p 'database port: ' db_port
read -p 'database timezone: ' db_time_zone
read -p 'database host: ' db_host
read -p 'redis dsn: ' redis_dsn
read -p 'token refresh secret: ' token_refresh_secret
echo "PORT = $port
DB_USER = $db_user
DB_PASSWORD = $db_password
DB_NAME = $db_name
DB_PORT = $db_port
DB_TIMEZONE = $db_time_zone
DB_HOST = $db_host
REDIS_DSN = $redis_dsn
REFRESH_SECRET= $token_refresh_secret
" > Configs/Environment/dev.env


echo "package main

import (
	\"github.com/gin-gonic/gin\"
	\"$package/Configs\"
)

var (
    port = Configs.DotEnvReader(\"PORT\")
    db   = Configs.DBConstructor()
)

func main() {
server := gin.Default()
	server.Use(func(context *gin.Context) {
		context.Set(\"db\", db)
		context.Next()
	})

server.Run(\":\" + port)

}" > main.go

#########CONFIGS/DB#########
touch Configs/DB.go
echo "package Configs
import (
	\"gorm.io/driver/postgres\"
	\"gorm.io/gorm\"
)

func DBConstructor() *gorm.DB {
	user := DotEnvReader(\"DB_USER\")
	password := DotEnvReader(\"DB_PASSWORD\")
	name := DotEnvReader(\"DB_NAME\")\
	port := DotEnvReader(\"DB_PORT\")
	timezone := DotEnvReader(\"DB_TIMEZONE\")
	host := DotEnvReader(\"DB_HOST\")

	connectionURL := \"host=\" + host + \" user=\" + user + \" password=\" + password + \" dbname=\" + name + \" port=\" + port + \" TimeZone=\" + timezone
	db, err := gorm.Open(postgres.Open(connectionURL), &gorm.Config{DisableForeignKeyConstraintWhenMigrating: false})
	if err != nil {
		panic(err)
	}

	db.AutoMigrate()

	return db
}" > Configs/DB.go