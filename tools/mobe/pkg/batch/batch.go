package batch

import (
	"encoding/json"
	"fmt"
	"os"

	"github.com/mtiller/mobe/pkg/compile"
	"github.com/mtiller/mobe/pkg/install"
)

type CaseDetails struct {
	ModelName string `json:"model_name"`
	Mods map[string]string `json:"mods"`
}

type CaseFile struct {
	Libraries map[string]string `json:"libraries"`
	Cases map[string]CaseDetails `json:"cases"`	
}

func RunCases(casefile string, outputdir string, verbose bool) error {
	// 1. Read the cases from the cases.json file
	casebytes, err := os.ReadFile(casefile)
	if err!=nil {
		return err
	}
	cases := CaseFile{}
	err = json.Unmarshal(casebytes, &cases)
	if err!=nil {
		return err
	}

	// 2. Install the libraries
	for library, version := range cases.Libraries {
		err := install.InstallLibrary(library, version, false, verbose)
		if err!=nil {
			return fmt.Errorf("error installing library %s: %w", library, err)
		}
	}
	
	// 3. Run each case
	for prefix, details := range cases.Cases {
		err := compile.CompileModel(details.ModelName, prefix, verbose, compile.CompileOptions{})
		if err!=nil {
			return fmt.Errorf("error compiling model %s: %w", details.ModelName, err)
		}
		// 4. Write the results to the <prefix>_res.json file
		// TODO: Run the model
	}

	return nil
}