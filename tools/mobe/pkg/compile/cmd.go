package compile

import (
	"fmt"
	"os"
	"strings"

	"github.com/mtiller/mobe/pkg/hash"
	"github.com/mtiller/mobe/pkg/omc"
	"github.com/spf13/cobra"
)

var CompileCmd = &cobra.Command{
	Use:   "compile",
	Short: "Compile a particular model into an executable",
	Long:  `This will generate an executable and associated files`,
	Run: func(cmd *cobra.Command, args []string) {
		verbose := cmd.Flags().Lookup("verbose").Value.String() == "true"
		prefix := cmd.Flags().Lookup("prefix").Value.String()
		path := cmd.Flags().Lookup("path").Value.String()

		if len(args)>1 {
			fmt.Fprintf(os.Stderr, "you can only compile a single model\n")
			os.Exit(1)
		}

		hash, err := hash.ComputeHash(args[0], verbose)
		if err!=nil {
			fmt.Fprint(os.Stderr, err.Error())
			os.Exit(1)
		}

		info, err := omc.ReadInfo(prefix, ".")
		if err!=nil {
			fmt.Fprint(os.Stderr, err.Error())
			os.Exit(1)
		}

		if prefix=="" {
			parts := strings.Split(args[0], ".")
			prefix = parts[len(parts)-1]
		}

		curHash, exists := info["mobe_hash"]
		if exists {
			if curHash=="hash" {
				if verbose {
					fmt.Printf("Model has not changed since last compile, skipping compile\n")
				}
				return
			} else {
				if verbose {
					fmt.Printf("Model has changed since last compile, recompiling\n")
				}
			}
		}

		err = CompileModel(args[0], prefix, verbose, CompileOptions{
			Path: path,
		})
		if err!=nil {
			fmt.Fprint(os.Stderr, err.Error())
			os.Exit(1)
		}

		// Read lastest info
		info, err = omc.ReadInfo(prefix, ".")
		if err!=nil {
			fmt.Fprint(os.Stderr, err.Error())
			os.Exit(1)
		}

		info["mobe_hash"] = hash
		err = omc.WriteInfo(prefix, ".", info)
		if err!=nil {
			fmt.Fprint(os.Stderr, err.Error())
			os.Exit(1)
		}
	},
}

func init() {
	CompileCmd.Flags().Bool("verbose", false, "activates verbose output")
	CompileCmd.Flags().String("prefix", "", "prefix to use for generated files")
	CompileCmd.Flags().String("path", ".", "Modelica PATH")
}
