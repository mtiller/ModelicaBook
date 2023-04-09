package hash

import (
	"fmt"

	"github.com/spf13/cobra"
)

var HashCmd = &cobra.Command{
	Use:   "hash",
	Short: "Compute the hash value for a given model",
	Long:  `This takes into account all dependencies of the model by performing
	        a save total and then hashing the result.  In this way, any change to
			the model or its dependencies will result in a new hash.  NB: annotations
			and comments are ignored for the purpose of computing this hash.`,
	RunE: func(cmd *cobra.Command, args []string) error {
		for _, arg := range args {
			hash, err := ComputeHash(arg)
			if err!=nil {
				return err
			}
			fmt.Printf("%s\n", hash)
		}
		return nil
	},
  }