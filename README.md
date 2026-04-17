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

| Input          | Description                                                        | Required | Default  |
|----------------|--------------------------------------------------------------------|----------|----------|
| `directory`    | Directory to scan (relative to the repository root)               | No       | `.`      |
| `post_comment` | Post a PR comment with the file count comparison                  | No       | `false`  |
| `base_count`   | File count from the base branch scan (used when `post_comment` is `true`) | No | `''` |
| `github_token` | GitHub token for posting PR comments                              | No       | `''`     |
| `pr_number`    | Pull request number to comment on                                 | No       | `''`     |

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

### Comparing base and PR branches with an automatic comment

Run the action twice — once on the base branch, once on the PR branch — and pass `post_comment: 'true'` on the second run to have the action post a comparison table directly to the PR:

```yaml
name: Dummy Scanner

on:
  pull_request_target:
    types: [opened, synchronize]

jobs:
  scan:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      pull-requests: write
    steps:
      - name: Checkout base branch
        uses: actions/checkout@v4
        with:
          ref: ${{ github.event.pull_request.base.sha }}
          path: base

      - name: Run Dummy Scanner on base branch
        id: scan_base
        uses: erikaheidi/dummy-scanner@main
        with:
          directory: base

      - name: Checkout PR branch
        uses: actions/checkout@v4
        with:
          ref: ${{ github.event.pull_request.head.sha }}
          path: head

      - name: Run Dummy Scanner on PR branch
        uses: erikaheidi/dummy-scanner@main
        with:
          directory: head
          post_comment: 'true'
          base_count: ${{ steps.scan_base.outputs.total_files }}
          github_token: ${{ secrets.GITHUB_TOKEN }}
          pr_number: ${{ github.event.pull_request.number }}
```

The action will post a comment like:

```
## Dummy Scanner Results

| Branch | Total Files |
|--------|-------------|
| Base (`main`) | 42 |
| PR (`my-feature`) | 45 |

📈 **+3 files added**
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
