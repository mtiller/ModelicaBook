package install

import (
	_ "embed"

	"github.com/mtiller/mobe/pkg/omc"
)

//go:embed installLibrary.txt
var installLibraryTemplate string

type installInputs struct {
	LibraryName string
	Version     string
	Exact       bool
}

func InstallLibrary(modelName string, version string, exact bool, verbose bool) error {
	err := omc.RunTemplate(installLibraryTemplate, installInputs{
		LibraryName: modelName,
		Version:     version,
		Exact:       exact,
	}, verbose, nil)

	return err
}
