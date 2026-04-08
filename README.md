# dummy-scanner

A GitHub Action (and standalone Go application) that scans a directory and counts the total number of files. Use it to automatically scan new pull requests in your repository.

## GitHub Action Usage

Add the following workflow to your repository at `.github/workflows/dummy-scanner.yml` to scan every new pull request:

```yaml
name: Dummy Scanner

on:
  pull_request:
    types: [opened, synchronize]

jobs:
  scan:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Run Dummy Scanner
        id: scan
        uses: erikaheidi/dummy-scanner@main

      - name: Print scan results
        run: echo "Total files found:" ${{ steps.scan.outputs.total_files }}
```

### Inputs

| Input       | Description                                          | Required | Default |
|-------------|------------------------------------------------------|----------|---------|
| `directory` | Directory to scan (relative to the repository root)  | No       | `.`     |

### Outputs

| Output        | Description                              |
|---------------|------------------------------------------|
| `total_files` | Total number of files found by the scanner |

### Scanning a specific directory

```yaml
- name: Run Dummy Scanner
  id: scan
  uses: erikaheidi/dummy-scanner@main
  with:
    directory: src
```

## Standalone CLI Usage

### Requirements

- [Go](https://golang.org/dl/) 1.18 or later

Run directly with `go run`:

```bash
# Count files in the current directory (default)
go run .

# Count files in a specific directory
go run . /path/to/directory

# Silent mode: print only the number
go run . -s /path/to/directory
```

Or build a binary first and then run it:

```bash
go build -o dummy-scanner .

# Count files in the current directory (default)
./dummy-scanner

# Count files in a specific directory
./dummy-scanner /path/to/directory

# Silent mode: print only the number
./dummy-scanner -s /path/to/directory
```

### Flags

| Flag | Description |
|------|-------------|
| `-s` | Silent mode: print only the total number of files (no extra text) |

### Example output

```
Total files in ".": 4
```

With the `-s` flag:

```
4
```
