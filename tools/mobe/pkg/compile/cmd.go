package compile

import (
	"errors"

	"github.com/spf13/cobra"
)

var CompileCmd = &cobra.Command{
	Use:   "compile",
	Short: "Compile a particular model into an executable",
	Long:  `This will generate an executable and associated files`,
	RunE: func(cmd *cobra.Command, args []string) error {
		verbose := cmd.Flags().Lookup("verbose").Value.String() == "true"
		prefix := cmd.Flags().Lookup("prefix").Value.String()
		path := cmd.Flags().Lookup("path").Value.String()

		if len(args)>1 {
			return errors.New("you can only compile a single model")
		}
		return CompileModel(args[0], prefix, verbose, CompileOptions{
			Path: path,
		})
	},
}

func init() {
	CompileCmd.Flags().Bool("verbose", false, "activates verbose output")
	CompileCmd.Flags().String("prefix", "", "prefix to use for generated files")
	CompileCmd.Flags().String("path", ".", "Modelica PATH")
}
