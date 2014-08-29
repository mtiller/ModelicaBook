package main

import "os"
import "fmt"
import "log"
import "os/exec"

import hs "github.com/xogeny/go-hooksink"

type Builder struct {}

func (b Builder) Push(msg hs.HubMessage) {
	url := "git@github.com:xogeny/ModelicaBook.git"
	ref := "master"
	target := "web_cn"
	user := "xogeny"
	repo := "ModelicaBook"
	dir := "temp"

	defer func() {
		os.RemoveAll(dir);
		if err != nil {
			log.Printf("Error cleaning up directory '%v': %s", cmd, err.Error());
		}
	}();

	/* Clone repo locally */
	cmd := exec.Command("git", "clone", url, dir)
	err := cmd.Run()
	if err != nil {
		log.Printf("Error cloning repository at '%s' to directory %s: %s",
			url, dir, err.Error());
		return;
	}

	/* Repo checkout correct ref */
	cmd = exec.Command("git", "checkout", ref)
	err = cmd.Run()
	if err != nil {
		log.Printf("Error checking out '%s': %s", ref, err.Error());
		return;
	}

	/* Run make */
	bucket := fmt.Sprintf("S3BUCKET=dev.book.xogeny.com/%s/%s", user, repo);
	cmd = exec.Command("make", target, bucket);
	cmd.Dir = dir;
	err = cmd.Run()
	if err != nil {
		log.Printf("Error running make '%v': %s", cmd, err.Error());
		return;
	}

	log.Printf("Make ran!");
}

func main() {
	h := hs.NewHookSink("");
	h.Add("/build", Builder{});
	h.Start();
}
