package main

import (
	"fmt"
	"os"

	"github.com/mtiller/mobe/pkg/compile"
	"github.com/mtiller/mobe/pkg/hash"
	"github.com/mtiller/mobe/pkg/install"
	"github.com/spf13/cobra"
)

func init() {
	rootCmd.AddCommand(hash.HashCmd)
	rootCmd.AddCommand(install.InstallCmd)
	rootCmd.AddCommand(compile.CompileCmd)
}

var rootCmd = &cobra.Command{
	Use:   "mobe",
	Short: "The 'mobe' tool is CLI that runs OpenModelica behind the scenes to perform some commong tasks.",
	Long: `The basic idea behind 'mobe' is to avoid having to remember how to do OpenModelica scripting
and instead have a simple binary that is capable of doing lots of tasks.  The hash of the save
total version of a model is used as a "fingerprint" to know whether a model has changed"`,
	// RunE: func(cmd *cobra.Command, args []string) error {
	// 	fmt.Printf("Running!\n")
	// 	return nil
	// },
}

func Execute() {
	if err := rootCmd.Execute(); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}
