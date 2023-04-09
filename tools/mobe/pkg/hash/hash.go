package hash

import (
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

func ComputeHash(modelName string) (string, error) {
	dir, err := ioutil.TempDir("dir", "prefix")
	if err != nil {
		return "", err
	}
	defer os.RemoveAll(dir)

	t, err := template.New("hash").Parse(saveTotalTemplate)
	if err != nil {
		return "", err
	}
	scriptFile := path.Join(dir, "script.mos")
	totalFile := path.Join(dir, "total.mo")
	err = t.Execute(os.Stdout, hashInputs{
		ModelName: modelName,
	})
	if err != nil {
		return "", err
	}
	_, err = omc.RunScript(scriptFile)

	// Hash resulting "SaveTotal.mo"
	bytes, err := os.ReadFile(totalFile)

	hmd5 := md5.Sum([]byte(bytes))

	return fmt.Sprintf("%x", hmd5), nil
}
