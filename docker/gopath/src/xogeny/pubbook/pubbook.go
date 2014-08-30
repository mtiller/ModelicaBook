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

func git(args...string) error {
	log.Printf("Running %v...", args);

	cmd := exec.Command("git", args...)
	err := cmd.Run()
	if err != nil {
		log.Printf("Error: %s", err.Error());
		return err;
	} else {
		log.Printf("...successful");
	}
	return nil;
}

func make(dir string, targets...string) error {
	cmd := exec.Command("make", targets...);
	cmd.Dir = path.Join(dir, "text");
	log.Printf("Running initial make: %v...", targets);
	err := cmd.Run()
	if err != nil {
		log.Printf("Error running initial make '%v': %s", targets, err.Error());
		return err;
	} else {
		log.Printf("...successful");
	}
	return nil;
}

func (b Builder) Push(msg hs.HubMessage) {
	url := "git@github.com:xogeny/ModelicaBook.git"
	ref := "origin/master"
	target1 := "dirhtml_cn"
	target2 := "web_cn"
	user := "xogeny"

	dir := path.Join("_cache", user);

	diri, err := os.Stat(dir);

	exists := err==nil && diri.IsDir();

	// TODO: Have a query parameter to clear cache

	if (exists) {
		err = git("fetch", "origin");
		if (err!=nil) { return; }
	} else {
		err = git("clone", url, dir);
		if (err!=nil) { return; }
	}

	/* Repo checkout correct ref */
	err = git("checkout", ref)
	if err != nil { return; }

	bucket := fmt.Sprintf("S3BUCKET=dev.book.xogeny.com/%s", user);
	if (!exists) {
		// If it didn't already exist, we need to run some make targets
		/* Run make */
		make(dir, "specs", "results");
		if (err!=nil) { return; }
	}

	/* Run make */
	make(dir, target1, target2, bucket);
	if err != nil {	return; }

	log.Printf("Make ran!");
}

func main() {
	h := hs.NewHookSink("");
	h.Add("/build", Builder{Debug: true});
	h.Start();
}
