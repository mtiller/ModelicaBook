package hash

import (
	"bytes"
	"crypto/md5"
	"fmt"
	"html/template"
	"io/ioutil"
	"os"
	"path"

	_ "embed"

	"github.com/mtiller/mobe/pkg/omc"
)

//go:embed saveTotal.txt
var saveTotalTemplate string

type hashInputs struct {
	ModelName string
}

func ComputeHash(modelName string, verbose bool) (string, error) {
	// Create temporary direcotry
	dir, err := ioutil.TempDir("", "mobe")
	if err != nil {
		return "", err
	}
	defer os.RemoveAll(dir)

	// Create new template
	t, err := template.New("hash").Parse(saveTotalTemplate)
	if err != nil {
		return "", err
	}

	// Name files we will work with
	scriptFile := path.Join(dir, "script.mos")
	totalFile := path.Join(dir, "total.mo")

	// Create a buffer to write our script into
	var scriptFileContents bytes.Buffer

	// Run the template and write the contents
	err = t.Execute(&scriptFileContents, hashInputs{
		ModelName: modelName,
	})
	if err != nil {
		return "", err
	}

	if verbose {
		fmt.Fprintf(os.Stderr, "Script: %s\n", scriptFileContents.String())
	}

	// Write the script file
	err = os.WriteFile(scriptFile, scriptFileContents.Bytes(), 0666)
	if err != nil {
		return "", err
	}

	// Run the script
	out, err := omc.RunScript(scriptFile)
	if verbose {
		fmt.Fprintf(os.Stderr, "Script Output: %s\n", out)
	}

	// Read in contents of the save total file
	bytes, err := os.ReadFile(totalFile)
	if verbose {
		fmt.Fprintf(os.Stderr, "Save Total: %s\n", bytes)
	}

	// Hash them
	hmd5 := md5.Sum([]byte(bytes))

	// Return the hash
	return fmt.Sprintf("%x", hmd5), nil
}
