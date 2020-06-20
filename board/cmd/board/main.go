package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"strconv"
)

const (
	odd  = "odd"
	even = "even"
)

var numbers map[int]int
var score map[string]int

func handler(w http.ResponseWriter, r *http.Request) {

	score["total"]++
	param, ok := r.URL.Query()["number"]
	number, err := strconv.Atoi(param[0])

	if !ok || err != nil {
		_, _ = w.Write([]byte("required query parameter `number` is missing"))
		w.WriteHeader(http.StatusBadRequest)
		return
	}

	if _, ok := numbers[number]; !ok {
		score["fail"]++
		w.WriteHeader(http.StatusNotFound)
		return
	}

	score["success"]++
	_, _ = w.Write([]byte("gotcha!"))
	return
}

func scoreHandler(w http.ResponseWriter, r *http.Request) {
	_, _ = w.Write([]byte(fmt.Sprintf("score: %+v", score)))
	return
}

func main() {

	log.Println("booting up number guess board game app..")

	oddOrEven := os.Getenv("odd_or_even")
	if oddOrEven == "" {
		oddOrEven = odd
	}

	remainder := 1
	if oddOrEven == even {
		remainder = 0
	}

	score = make(map[string]int)
	score["total"] = 0
	score["success"] = 0
	score["fail"] = 0

	numbers = make(map[int]int)
	for i := 0; i < 20; i++ {
		if i%2 == remainder {
			numbers[i] = i
		}
	}

	log.Printf("numbers are %v", numbers)

	http.HandleFunc("/guess", handler)
	http.HandleFunc("/score", scoreHandler)

	log.Fatal(http.ListenAndServe(":8080", nil))
}
