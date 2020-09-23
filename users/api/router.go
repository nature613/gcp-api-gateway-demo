package api

import (
	"net/http"

	"github.com/go-chi/chi"
)

// BuildRouter builds the router
func BuildRouter() (*chi.Mux, error) {
	r := chi.NewRouter()

	// the single route in our app (would need to be moved to a "handlers" package in a production app)
	r.Get("/all", func(w http.ResponseWriter, r *http.Request) {
		users := []User{
			User{
				ID:   1,
				Name: "Mike",
			},
			User{
				ID:   2,
				Name: "John",
			},
		}

		jsonOk(w, &users)
	})

	return r, nil
}
