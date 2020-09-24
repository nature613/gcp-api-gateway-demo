package api

type Location struct {
	ID      int    `json:"id,omitempty"`
	Name    string `json:"name,omitempty"`
	Country string `json:"country,omitempty"`
}
