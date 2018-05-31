package main

import (
	"log"
	"net/http"
	"os"

	"github.com/rumyantseva/gophercon/pkg/routing"
)

// go run ./cmd/gophercon/gophercon.go
// curl -i http://127.0.0.1:8000/home
func main() {
	log.Printf("Service is starting...")

	// you can also use github.com/kelseyhightower/envconfig
	// to keep your config more structured
	port := os.Getenv("SERVICE_PORT")
	if len(port) == 0 {
		log.Fatal("Service port wasn't set")
	}

	r := routing.BaseRouter()

	log.Fatal(http.ListenAndServe(":"+port, r))
}
