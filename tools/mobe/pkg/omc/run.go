package omc

import (
	"bytes"
	"fmt"
	"os/exec"
)

func RunScript(scriptFile string, cwd string) (string, error) {
	cmd := exec.Command("omc", scriptFile)
	cmd.Dir = cwd

	var out bytes.Buffer
	cmd.Stdout = &out

	err := cmd.Run()
	if err != nil {
		return "", fmt.Errorf("OMC error: %s", out.String())
	}

	return string(out.Bytes()), nil
}
