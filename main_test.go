package main

import (
	"os"
	"path/filepath"
	"testing"
)

func TestCountFiles_EmptyDir(t *testing.T) {
	dir := t.TempDir()
	count, err := countFiles(dir)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if count != 0 {
		t.Errorf("expected 0, got %d", count)
	}
}

func TestCountFiles_WithFiles(t *testing.T) {
	dir := t.TempDir()
	for _, name := range []string{"a.txt", "b.txt", "c.txt"} {
		if err := os.WriteFile(filepath.Join(dir, name), []byte("x"), 0644); err != nil {
			t.Fatal(err)
		}
	}
	count, err := countFiles(dir)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if count != 3 {
		t.Errorf("expected 3, got %d", count)
	}
}

func TestCountFiles_Nested(t *testing.T) {
	dir := t.TempDir()
	sub := filepath.Join(dir, "sub")
	if err := os.Mkdir(sub, 0755); err != nil {
		t.Fatal(err)
	}
	for _, p := range []string{filepath.Join(dir, "top.txt"), filepath.Join(sub, "nested.txt")} {
		if err := os.WriteFile(p, []byte("x"), 0644); err != nil {
			t.Fatal(err)
		}
	}
	count, err := countFiles(dir)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if count != 2 {
		t.Errorf("expected 2, got %d", count)
	}
}

func TestCountFiles_InvalidDir(t *testing.T) {
	_, err := countFiles("/nonexistent/path/xyz")
	if err == nil {
		t.Error("expected error for nonexistent directory, got nil")
	}
}
