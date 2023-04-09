package install

import (
	"fmt"

	"github.com/spf13/cobra"
)

var InstallCmd = &cobra.Command{
	Use:   "install",
	Short: "Install a particular library into the OpenModelica installation",
	Long:  `This invokes the 'installPackage' function to populate the $HOME/.openmodelica/libraries directory`,
	RunE: func(cmd *cobra.Command, args []string) error {
		verbose := cmd.Flags().Lookup("verbose").Value.String() == "true"
		version := cmd.Flags().Lookup("version").Value.String()
		exact := cmd.Flags().Lookup("exact").Value.String() == "true"

		if version != "" && len(args) > 1 {
			return fmt.Errorf("You can only specify a version if you are installing a single library")
		}
		for _, arg := range args {
			err := InstallLibrary(arg, version, exact, verbose)
			if err != nil {
				return err
			}
		}
		return nil
	},
}

func init() {
	InstallCmd.Flags().Bool("verbose", false, "activates verbose output")
	InstallCmd.Flags().String("version", "", "version to install")
	InstallCmd.Flags().Bool("exact", false, "only install the exact version specified")
}
