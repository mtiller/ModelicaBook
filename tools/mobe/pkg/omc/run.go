package omc

import (
	"bytes"
	"fmt"
	"os/exec"
)

func RunScript(scriptFile string) (string, error) {
	cmd := exec.Command("omc", scriptFile)

	var out bytes.Buffer
	cmd.Stdout = &out

	err := cmd.Run()
	if err != nil {
		return "", fmt.Errorf("OMC error: %s", out.String())
	}

	return string(out.Bytes()), nil
}
