package omc

import (
	"bytes"
	"os/exec"
)

func RunScript(scriptFile string) (string, error) {
	cmd := exec.Command("omc", scriptFile)

    var out bytes.Buffer
    cmd.Stdout = &out

    err := cmd.Run()

	return string(out.Bytes()), err
}