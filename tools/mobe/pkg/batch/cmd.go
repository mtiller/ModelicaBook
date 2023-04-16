package batch

import (
	"github.com/spf13/cobra"
)

var BatchCmd = &cobra.Command{
	Use:   "batch",
	Short: "Run a collection of cases",
	Long:  `This compiles and runs a collection of cases`,
	Run: func(cmd *cobra.Command, args []string) {
		// verbose := cmd.Flags().Lookup("verbose").Value.String() == "true"
		// path := cmd.Flags().Lookup("path").Value.String()
	},
}

func init() {
	BatchCmd.Flags().Bool("verbose", false, "activates verbose output")
	BatchCmd.Flags().String("path", ".", "Modelica PATH")
	BatchCmd.Flags().String("output", ".", "Output directory")
}
