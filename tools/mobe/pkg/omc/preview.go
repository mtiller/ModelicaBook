package omc

import (
	"os"
	"os/exec"
)

func PreviewDirectory(dir string) error {
	cmd := exec.Command("ls", "-al", dir)
	cmd.Dir = dir

	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	return cmd.Run()
}