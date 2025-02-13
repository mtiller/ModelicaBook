package omc

import (
	"bytes"
	"io/ioutil"
	"os"
	"path"
	"text/template"
)

func RunTemplate(templateString string, input interface{}, verbose bool, callback func(dir string) error) error {
	// Create temporary direcotry
	dir, err := ioutil.TempDir("", "mobe")
	if err != nil {
		return err
	}
	defer os.RemoveAll(dir)

	// Create new template
	t, err := template.New("script").Parse(templateString)
	if err != nil {
		return err
	}

	// Name fo the script file to generate
	scriptFile := path.Join(dir, "script.mos")

	// Create a buffer to write our script into
	var scriptFileContents bytes.Buffer

	VerboseOutput("Script", scriptFileContents.String(), verbose);
	// Run the template and write the contents
	err = t.Execute(&scriptFileContents, input)
	if err!=nil {
		return err
	}

	// Write the script file
	err = os.WriteFile(scriptFile, scriptFileContents.Bytes(), 0666)
	if err != nil {
		return err
	}

	// Run the script
	scriptOutput, err := RunScript(scriptFile, dir, verbose)
	if err != nil {
		return err
	}

	VerboseOutput("Output", scriptOutput, verbose)

	if callback != nil {
		err = callback(dir)
		if err != nil {
			return err
		}
	}

	return nil
}

