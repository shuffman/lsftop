# LSFtop

A curses-based monitoring utility for IBM Spectrum LSF jobs.

## Description

LSFtop provides a terminal-based interface for monitoring LSF jobs, similar to the Unix `top` command but specifically for LSF job management. It displays jobs in a sortable, color-coded table with expandable job groups.

## Features

- Interactive terminal UI with color-coded job information
- Sortable columns for different job attributes
- Expandable/collapsible job groups
- Real-time job status updates
- Keyboard navigation and shortcuts

## Requirements

- Perl 5.10 or higher
- Perl modules:
  - Curses
  - Getopt::Long
  - Time::HiRes
  - POSIX
  - Text::Wrap
- IBM Spectrum LSF (for normal operation)

## Installation

1. Clone or download this repository
2. Make sure the script is executable:
   ```
   chmod +x lsftop
   ```
3. Install required Perl modules if needed:
   ```
   cpan Curses
   ```

## Usage

### Normal Mode

When you have access to an LSF cluster, simply run:

```
./lsftop
```

### Test Mode

For testing or demonstration without an LSF cluster:

1. Make sure the test data generator is executable:
   ```
   chmod +x lsftop_test_data.pl
   ```

2. Run lsftop in test mode:
   ```
   ./lsftop --test
   ```

   This will use randomly generated mock data.

3. Alternatively, you can generate a test data file and use it:
   ```
   ./lsftop_test_data.pl > mock_jobs.txt
   ./lsftop --test mock_jobs.txt
   ```

## Command Line Options

- `-i, --interval SECONDS` - Set polling interval (default: 5 seconds)
- `-t, --test [FILE]` - Run in test mode with mock data
- `-h, --help` - Show help message

## Keyboard Shortcuts

- `q`, `Q` - Quit
- `↑`, `↓` - Navigate through jobs
- `←`, `→` - Change sort column
- `s` - Toggle sort direction
- `Enter` - Expand/collapse job group
- `+` - Expand all job groups
- `-` - Collapse all job groups
- `r` - Refresh immediately

## License

See the LICENSE file for details.
