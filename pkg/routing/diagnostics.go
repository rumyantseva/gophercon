package routing

import (
	"fmt"
	"net/http"

	"github.com/gorilla/mux"
)

func DiagnosticsRouter() *mux.Router {
	r := mux.NewRouter()

	r.HandleFunc("/healthz", healthzHandler()).Methods(http.MethodGet)
	r.HandleFunc("/readyz", readyzHandler()).Methods(http.MethodGet)

	return r
}

func readyzHandler() func(http.ResponseWriter, *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprint(w, http.StatusText(http.StatusOK))
	}
}

func healthzHandler() func(http.ResponseWriter, *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprint(w, http.StatusText(http.StatusOK))
	}
}
