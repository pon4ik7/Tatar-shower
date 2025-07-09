package main

import (
	"fmt"
	"net/http"
)

func main() {
	http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("auth-service: OK"))
	})
	fmt.Println("auth-service running on :8001")
	http.ListenAndServe(":8001", nil)
}
