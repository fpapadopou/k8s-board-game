package main

import (
	"log"
	"math/rand"
	"net/http"
	"os"
	"strconv"
	"strings"
	"sync"
	"time"
)

func main() {

	log.Println("booting up number guess board game client..")

	boardUrls := os.Getenv("boards")
	if boardUrls == "" {
		log.Print("no boards provided, shutting down..")
	}

	boards := strings.Split(boardUrls, ",")

	var wg sync.WaitGroup
	// Start making calls to the boards' endpoints
	for _, board := range boards {
		wg.Add(1)
		go func(group *sync.WaitGroup, board string) {
			playBoard(board)

			wg.Done()
		}(&wg, board)
	}

	log.Printf("playing on %d boards", len(boards))
	wg.Wait()

	log.Printf("done playing, shutting down")
}

func playBoard(boardUrl string) {

	rand.Seed(time.Now().UnixNano())

	tts := 2 * time.Second
	for {

		time.Sleep(tts)

		number := strconv.Itoa(rand.Intn(20))

		// Give up after some retries.
		if tts > 31*time.Second {
			log.Printf("board at %s is not available, giving up", boardUrl)
			return
		}

		resp, err := http.Get(boardUrl + "/guess?number=" + number)
		if err != nil {
			tts = tts * 2
			log.Printf("failed to make request to board %s: %v \nretrying in %v", boardUrl, err, tts)
			continue
		}

		tts = 2 * time.Second
		log.Printf("tried number: %s", number)
		log.Printf("got [%s] response from board %s", resp.Status, boardUrl)
	}
}
