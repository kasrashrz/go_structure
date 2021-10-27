package Configs
import (
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

func DBConstructor() *gorm.DB {
	user := DotEnvReader("DB_USER")
	password := DotEnvReader("DB_PASSWORD")
	name := DotEnvReader("DB_NAME")	port := DotEnvReader("DB_PORT")
	timezone := DotEnvReader("DB_TIMEZONE")
	host := DotEnvReader("DB_HOST")

	connectionURL := "host=" + host + " user=" + user + " password=" + password + " dbname=" + name + " port=" + port + " TimeZone=" + timezone
	db, err := gorm.Open(postgres.Open(connectionURL), &gorm.Config{DisableForeignKeyConstraintWhenMigrating: false})
	if err != nil {
		panic(err)
	}

	db.AutoMigrate()

	return db
}
