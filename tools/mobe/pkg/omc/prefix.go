package omc

import (
	"fmt"
	"strings"
)

func VerboseOutput(prefix string, lines string, verbose bool) {
	if !verbose {
		return
	}
	for _, line := range strings.Split(lines, "\n") {
		fmt.Printf("%s: %s\n", prefix, line)
	}
}