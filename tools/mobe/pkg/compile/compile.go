package compile

import (
	_ "embed"

	"github.com/mtiller/mobe/pkg/omc"
)

//go:embed compileModel.txt
var compileModelTemplate string

type CompileOptions struct {
	SimFlags string
	Start string
	Stop string
	Path string
}

type compileInputs struct {
	ModelName string
	Start string
	Stop string
	Path string
}

func CompileModel(modelName string, prefix string, verbose bool, opts CompileOptions) error {
	if opts.Stop=="" {
		opts.Stop = "1.0"
	}
	if opts.Start=="" {
		opts.Start = "0.0"
	}
	err := omc.RunTemplate(compileModelTemplate, compileInputs{
		ModelName: modelName,
		Start: opts.Start,
		Stop: opts.Stop,
		Path: opts.Path,
	}, verbose, omc.PreviewDirectory)

	return err
}
