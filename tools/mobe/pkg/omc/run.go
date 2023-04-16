package omc

import (
	"bytes"
	"fmt"
	"os/exec"
)

func RunScript(scriptFile string, cwd string, verbose bool) (string, error) {
	cmd := exec.Command("omc", scriptFile)
	cmd.Dir = cwd

	var out bytes.Buffer
	cmd.Stdout = &out

	err := cmd.Run()
	if err != nil {
		return "", fmt.Errorf("omc error: %s", out.String())
	}

	return out.String(), nil
}
