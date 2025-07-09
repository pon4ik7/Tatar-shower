package main

import (
	"fmt"
	"net/http"
)

func main() {
	http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("rec-service: OK"))
	})
	fmt.Println("rec-service running on :8003")
	http.ListenAndServe(":8003", nil)
}
