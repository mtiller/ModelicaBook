package main

import "bytes"
import "io/ioutil"
import "net/http"
import "testing"
import "encoding/json"

func TestPostRequest(t *testing.T) {
	p := GitHubPost{
		Ref: "abc",
		Commit: HeadCommit{
			Id: "def",
		},
		Repo: Repository{
			Clone: "http://foo.com/",
		},
	}

	setupServer()
	http.HandleFunc("/kill", func (w http.ResponseWriter, req *http.Request) {
		panic("Done");
	})
	go startServer();

	raw, err := json.Marshal(p)
	if (err!=nil) { t.Fatalf("Error marshalling json: %v: %s", p, err.Error()); }

	buffer := bytes.NewBuffer(raw);

	resp, err := http.Post("http://localhost:8080/update", "application/json", buffer)
	if (err!=nil) { t.Fatalf("Error making POST: %s", err.Error()); }

	if (resp.StatusCode!=200) {
		t.Fatalf("Got unexpected status code %d", resp.StatusCode);
	}

	body, err := ioutil.ReadAll(resp.Body);
	if (err!=nil) { t.Fatalf("Error reading body: %s", err.Error()); }
	defer resp.Body.Close();

	if (string(body)!="Success") {
		t.Fatalf("Expected 'Success', got '%s'", body);
	}
}
