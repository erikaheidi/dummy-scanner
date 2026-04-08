package main

import (
	"flag"
	"fmt"
	"os"
	"path/filepath"
)

func countFiles(dir string) (int, error) {
	count := 0
	err := filepath.Walk(dir, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		if !info.IsDir() {
			count++
		}
		return nil
	})
	return count, err
}

func main() {
	silent := flag.Bool("s", false, "silent mode: print only the total number of files")
	flag.Parse()

	dir := "."
	if flag.NArg() > 0 {
		dir = flag.Arg(0)
	}

	count, err := countFiles(dir)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error: %v\n", err)
		os.Exit(1)
	}

	if *silent {
		fmt.Println(count)
	} else {
		fmt.Printf("Total files in %q: %d\n", dir, count)
	}
}
