package main

import (
	"fmt"
	"net/http"
)

func main() {
	http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("shower-service: OK"))
	})
	fmt.Println("shower-service running on :8002")
	http.ListenAndServe(":8002", nil)
}
