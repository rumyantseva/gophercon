package main

import (
	"fmt"
	"log"
	"net/http"
)

// go run ./cmd/gophercon/gophercon.go
// curl -i http://127.0.0.1:8000/home
func main() {
	log.Printf("Service is starting...")

	http.HandleFunc("/home", func(w http.ResponseWriter, r *http.Request) {
		log.Printf("Request is processing: %s", r.URL.Path)
		fmt.Fprint(w, "Hello! Your request was processed.")
	})
	http.ListenAndServe(":8000", nil)
}
