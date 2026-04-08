# dummy-scanner

A demo Go application that counts the total number of files in a specified directory.

## Requirements

- [Go](https://golang.org/dl/) 1.18 or later

## Usage

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
