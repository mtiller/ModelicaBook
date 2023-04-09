package hash

import (
	"crypto/md5"
	"fmt"
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
	ret := ""
	err := omc.RunTemplate(saveTotalTemplate, hashInputs{
		ModelName: modelName,
	}, func(dir string) error {
		totalFile := path.Join(dir, "total.mo")
		// Read in contents of the save total file
		bytes, err := os.ReadFile(totalFile)
		if err != nil {
			return err
		}

		if verbose {
			fmt.Fprintf(os.Stderr, "Save Total: %s\n", bytes)
		}

		// Hash them
		hmd5 := md5.Sum([]byte(bytes))
		ret = fmt.Sprintf("%x", hmd5)
		return nil
	})
	// Return the hash
	return ret, err
}
