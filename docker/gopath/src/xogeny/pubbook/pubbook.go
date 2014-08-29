package main

import "os"
import "fmt"
import "log"
import "path"
import "os/exec"

import hs "github.com/xogeny/go-hooksink"

type Builder struct {
	Debug bool
}

func (b Builder) Push(msg hs.HubMessage) {
	url := "git@github.com:xogeny/ModelicaBook.git"
	ref := "master"
	target1 := "dirhtml_cn"
	target2 := "web_cn"
	user := "xogeny"
	repo := "ModelicaBook"
	dir := "temp"

	if (!b.Debug) {
		defer func() {
			err := os.RemoveAll(dir);
			if err != nil {
				log.Printf("Error cleaning up directory '%s': %s", dir, err.Error());
			}
		}();
	}

	log.Printf("Cloning repository: %s", url);
	/* Clone repo locally */
	cmd := exec.Command("git", "clone", url, dir)
	err := cmd.Run()
	if err != nil {
		log.Printf("Error cloning repository at '%s' to directory %s: %s",
			url, dir, err.Error());
		return;
	} else {
		log.Printf("...successful");
	}

	log.Printf("Checking out: %s", ref);
	/* Repo checkout correct ref */
	cmd = exec.Command("git", "checkout", ref)
	err = cmd.Run()
	if err != nil {
		log.Printf("Error checking out '%s': %s", ref, err.Error());
		return;
	} else {
		log.Printf("...successful");
	}

	/* Run make */
	bucket := fmt.Sprintf("S3BUCKET=dev.book.xogeny.com/%s/%s", user, repo);
	cmd = exec.Command("make", "specs", "results", target1, target2, bucket);
	cmd.Dir = path.Join(dir, "text");
	log.Printf("Running make: %v", cmd);
	err = cmd.Run()
	if err != nil {
		log.Printf("Error running make '%v': %s", cmd, err.Error());
		return;
	} else {
		log.Printf("...successful");
	}

	log.Printf("Make ran!");
}

func main() {
	h := hs.NewHookSink("");
	h.Add("/build", Builder{Debug: true});
	h.Start();
}
