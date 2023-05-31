package compile

import (
	_ "embed"
	"fmt"
	"path"
	"runtime"

	"github.com/mtiller/mobe/pkg/omc"
)

//go:embed compileModel.txt
var compileModelTemplate string

type CompileOptions struct {
	SimFlags string
	Start string
	Stop string
	Path string
	OutputFile string
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
	}, verbose, func(dir string) error {
		arch := runtime.GOARCH
		outputFile := fmt.Sprintf("%s-%s", prefix, arch)
		if opts.OutputFile!="" {
			outputFile = opts.OutputFile
		}
		omc.CopyFile(path.Join(dir, "model"), outputFile)
		omc.CopyFile(path.Join(dir, "model_info.json"), fmt.Sprintf("%s_info.json", prefix))
		omc.CopyFile(path.Join(dir, "model_init.xml"), fmt.Sprintf("%s_init.xml", prefix))
		return nil
	})

	return err
}
