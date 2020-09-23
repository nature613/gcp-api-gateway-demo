package api

import (
	"fmt"
	"net/http"
	"os"
)

// StartServer starts the server
func StartServer() error {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8000"
	}

	mux, err := BuildRouter()
	if err != nil {
		return fmt.Errorf("buildrouter: %v", err)
	}

	fmt.Printf("Listening on port %s\n", port)
	return http.ListenAndServe(fmt.Sprintf(":%s", port), mux)
}
