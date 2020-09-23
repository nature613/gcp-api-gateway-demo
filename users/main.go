package main

import (
	"log"

	"github.com/didil/gcp-api-gateway-demo/users/api"
)

func main() {
	err := api.StartServer()
	if err != nil {
		log.Fatal(err)
	}
}
