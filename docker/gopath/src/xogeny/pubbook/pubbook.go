package main

import "os"
import "fmt"
import "log"
import "path"
import "bytes"
import "os/exec"
import "io/ioutil"

import hs "github.com/xogeny/go-hooksink"

type Builder struct {
	Debug bool
}

func git(dir string, args...string) error {
	log.Printf("Running %v...", args);

	ebuf := []byte{};
	obuf := []byte{};

	stderr := bytes.NewBuffer(ebuf);
	stdout := bytes.NewBuffer(obuf);

	cmd := exec.Command("git", args...)
	cmd.Dir = dir;
	cmd.Stderr = stderr;
	cmd.Stdout = stdout;
	err := cmd.Run()
	if err != nil {
		log.Printf("Error: %s", err.Error());
		log.Print("=== Output ===");
		log.Print(stdout.String());
		log.Print("=== Error ===");
		log.Print(stderr.String());
		return err;
	} else {
		log.Printf("...successful");
	}
	return nil;
}

func runmake(dir string, targets...string) error {
	ebuf := []byte{};
	obuf := []byte{};

	stderr := bytes.NewBuffer(ebuf);
	stdout := bytes.NewBuffer(obuf);

	cmd := exec.Command("make", targets...);
	cmd.Stderr = stderr;
	cmd.Stdout = stdout;
	cmd.Dir = path.Join(dir, "text");
	log.Printf("Running make: %v...", targets);
	err := cmd.Run()
	if err != nil {
		log.Printf("Error running make '%v': %s", targets, err.Error());
		log.Print("=== Output ===");
		log.Print(stdout.String());
		log.Print("=== Error ===");
		log.Print(stderr.String());
		return err;
	} else {
		log.Printf("...successful");
	}
	return nil;
}

func (b Builder) Push(msg hs.PushMessage, params map[string][]string) {
	user := msg.Repository.Owner.Name;
	url := msg.Repository.GitUrl;
	ref := msg.After;
	var targets []string = params["target"];
	if (user=="") {
		user = "xogeny";
		url = "https://github.com/xogeny/ModelicaBook.git"
		ref = "origin/master"
		targets = []string{"dirhtml_cn", "web_cn"}
	}
	log.Printf("User:    %s", user);
	log.Printf("URL:     %s", url);
	log.Printf("Ref:     %s", ref);
	log.Printf("Targets: %v", targets);

	dir := path.Join("_cache", user);

	// TODO: Create a lock file and check for it...

	diri, err := os.Stat(dir);

	exists := err==nil && diri.IsDir();

	// TODO: Have a query parameter to clear cache

	if (exists) {
		err = git(dir, "fetch", "origin");
		if (err!=nil) { return; }
	} else {
		err = git(".", "clone", url, dir);
		if (err!=nil) { return; }
	}

	/* Repo checkout correct ref */
	err = git(dir, "checkout", ref)
	if err != nil { return; }

	wd, err := os.Getwd();
	if (err!=nil) {
		log.Printf("Unable to get working directory!");
		wd = ".";
	}
	s3flags := fmt.Sprintf("S3FLAGS='--config=%s'",	path.Join(wd, ".s3cfg"));
	bucket := fmt.Sprintf("S3BUCKET=dev.book.xogeny.com/%s", user);
	if (!exists) {
		// If it didn't already exist, we need to run some make targets
		/* Run make */
		err = runmake(dir, "specs");
		if (err!=nil) { return; }
	}

	err = runmake(dir, "results");
	if (err!=nil) { return; }

	args := append(targets, bucket, s3flags);
	err = runmake(dir, args...);
	if (err != nil) { return; }
	
	log.Printf("Make ran!");
}

func main() {
	secret := os.Getenv("MBE_WEBHOOK_SECRET");
	log.Printf("Secret = '%s'", secret);

	// Take the template config file, append keys and then
	// write it back out.
	cf, err := os.Open("s3cfg");
	defer cf.Close();
	if (err!=nil) {
		log.Printf("Unable to open template s3cfg file");
	}
	conf, err := ioutil.ReadAll(cf);
	if (err!=nil) {
		log.Printf("Unable to read template s3cfg file");
	}
	nconf := fmt.Sprintf("%s\naccess_key=%s\nsecret_key=%s\n",
		string(conf), os.Getenv("AWS_ACCESS_KEY_ID"),
		os.Getenv("AWS_SECRET_ACCESS_KEY"));
	err = ioutil.WriteFile(".s3cfg", []byte(nconf), 0660);
	if (err!=nil) {
		log.Printf("Unable to write .s3cfg file");
	}

	h := hs.NewHookSink(secret);
	h.Add("/build", Builder{Debug: true});
	h.Start();
}
