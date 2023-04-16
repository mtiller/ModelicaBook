package omc

import (
	"encoding/json"
	"errors"
	"fmt"
	"os"
	"path"
)

func ReadInfo(prefix string, dir string) (map[string]interface{}, error) {
	info := make(map[string]interface{})
	infoFile := fmt.Sprintf("%s_info.json", prefix)
	infoBytes, err := os.ReadFile(path.Join(dir, infoFile))
	// If the file doesn't exist, this isn't really an error, it just
	// means we don't know anything about this model
	if errors.Is(err, os.ErrNotExist) {
		return info, nil
	}
	if err != nil {
		return info, err
	}
	err = json.Unmarshal(infoBytes, &info)
	return info, err
}

func WriteInfo(prefix string, dir string, info map[string]interface{}) error {
	infoFile := fmt.Sprintf("%s_info.json", prefix)
	infoBytes, err := json.MarshalIndent(info, "", "  ")
	if err != nil {
		return err
	}
	err = os.WriteFile(path.Join(dir, infoFile), infoBytes, 0644)
	return err
}
