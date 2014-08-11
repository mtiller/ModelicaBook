package main

import "log"
import "net/http"
import "encoding/json"

type HeadCommit struct {
	Id string `json:"id"`
}

type Repository struct {
	Clone string `json:"clone_url"`
}

type GitHubPost struct {
	Ref string `json:"ref"`
	Commit HeadCommit `json:"head_commit"`
	Repo Repository `json:"repository"`
}

func updateHandler(w http.ResponseWriter, req *http.Request) {
	if (req.Method=="POST") {
		decoder := json.NewDecoder(req.Body)
		var t GitHubPost
		err := decoder.Decode(&t)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			log.Fatalf("Error parsing GitHub POST: %s", err.Error())
		} else {
			w.Write([]byte("Success"));
		}
		log.Println("GitHub Commit:");
		log.Println(t);
	} else {
		log.Println("Received unrecognized request:");
		log.Println(req);
	}
}

func setupServer() {
	http.HandleFunc("/update", updateHandler)
}

func startServer() {
	log.Fatal(http.ListenAndServe(":8080", nil))
}

func main() {
	setupServer()
	startServer()
}
