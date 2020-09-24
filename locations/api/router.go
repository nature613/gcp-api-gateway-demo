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
		locations := []Location{
			Location{
				ID:      1,
				Name:    "London",
				Country: "UK",
			},
			Location{
				ID:      2,
				Name:    "Paris",
				Country: "FR",
			},
		}

		jsonOk(w, &locations)
	})

	return r, nil
}
