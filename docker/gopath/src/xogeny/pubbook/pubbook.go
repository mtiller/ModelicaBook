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
	ref := "origin/master"
	target1 := "dirhtml_cn"
	target2 := "web_cn"
	user := "xogeny"

	dir := path.Join("_cache", user);

	diri, err := os.Stat(dir);
	/*
	if (err!=nil) {
		log.Printf("Error getting file information: %s", err.Error());
		return;
	}
    */

	var cmd *exec.Cmd;
	var exists bool;

	exists = err==nil && diri.IsDir();

	// TODO: Have a query parameter to clear cache

	if (exists) {
		log.Printf("Repository already exists, fetching latest updates...");
		/* Clone repo locally */
		cmd = exec.Command("git", "fetch", "origin")
		err := cmd.Run()
		if err != nil {
			log.Printf("Error fetching updates: %s", err.Error());
			return;
		} else {
			log.Printf("...successful");
		}
	} else {
		log.Printf("Cloning repository: %s...", url);
		/* Clone repo locally */
		cmd = exec.Command("git", "clone", url, dir)
		err := cmd.Run()
		if err != nil {
			log.Printf("Error cloning repository at '%s' to directory %s: %s",
				url, dir, err.Error());
			return;
		} else {
			log.Printf("...successful");
		}
	}

	log.Printf("Checking out: %s...", ref);
	/* Repo checkout correct ref */
	cmd = exec.Command("git", "checkout", ref)
	err = cmd.Run()
	if err != nil {
		log.Printf("Error checking out '%s': %s", ref, err.Error());
		return;
	} else {
		log.Printf("...successful");
	}

	bucket := fmt.Sprintf("S3BUCKET=dev.book.xogeny.com/%s", user);
	if (!exists) {
		// If it didn't already exist, we need to run some make targets
		/* Run make */
		cmd = exec.Command("make", "specs", "results");
		cmd.Dir = path.Join(dir, "text");
		log.Printf("Running initial make: %v...", cmd);
		err = cmd.Run()
		if err != nil {
			log.Printf("Error running initial make '%v': %s", cmd, err.Error());
			return;
		} else {
			log.Printf("...successful");
		}
	}

	/* Run make */
	cmd = exec.Command("make", target1, target2, bucket);
	cmd.Dir = path.Join(dir, "text");
	log.Printf("Running build make: %v...", cmd);
	err = cmd.Run()
	if err != nil {
		log.Printf("Error running build make '%v': %s", cmd, err.Error());
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
