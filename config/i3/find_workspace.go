package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"log"
	"os/exec"
	"strings"
)

var (
	prefix = flag.String("prefix", "", "Prefix of the command before the workspace name.")
	query  = flag.String("query", "", "Query of the workspace.")
	suffix = flag.String("suffix", "", "Postfix of the command after the workspace name.")
)

type workspace struct {
	Name string
	// We ignore other fields since they are not useful.
}

func firstMatch(ws []workspace, p func(workspace) bool) *workspace {
	for _, w := range ws {
		if p(w) {
			return &w
		}
	}
	return nil
}

func main() {
	flag.Parse()
	cmd := exec.Command("i3-msg", "-t", "get_workspaces")
	output, err := cmd.Output()
	if err != nil {
		log.Fatalf("Failed to get workspace: %s", err)
	}
	var ws []workspace
	err = json.Unmarshal(output, &ws)
	if err != nil {
		log.Fatalf("Failed to parse workspace json: %s", err)
	}
	log.Printf("Parsed json: %s", ws)

	if w := firstMatch(ws, func(w workspace) bool {
		return strings.HasPrefix(w.Name, *query)
	}); w != nil {
		*query = w.Name
	} else if w := firstMatch(ws, func(w workspace) bool {
		return strings.Contains(w.Name, *query)
	}); w != nil {
		*query = w.Name
	} else if w := firstMatch(ws, func(w workspace) bool {
		return strings.HasSuffix(w.Name, *query)
	}); w != nil {
		*query = w.Name
	}
	log.Printf("Final name: %s", *query)
	cmd = exec.Command("i3-msg", fmt.Sprintf("%s%s%s", *prefix, *query, *suffix))
	log.Printf("Command run: %v", cmd.Args)
	if err = cmd.Run(); err != nil {
		log.Fatalf("Failed to run command: %s", err)
	}

}
