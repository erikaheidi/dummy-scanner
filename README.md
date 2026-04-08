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
```

Or build a binary first and then run it:

```bash
go build -o dummy-scanner .

# Count files in the current directory (default)
./dummy-scanner

# Count files in a specific directory
./dummy-scanner /path/to/directory
```

### Example output

```
Total files in ".": 4
```
