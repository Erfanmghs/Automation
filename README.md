# Automation
# Ultimate Passive Recon

A simple Bash script for passive subdomain enumeration using multiple well-known OSINT tools.

The script runs each tool **sequentially** (not in parallel), hides their output, displays a clean progress dashboard, and saves the final results to user-defined files.

## Features

* Passive subdomain enumeration
* Sequential execution (helps reduce rate limiting)
* Clean terminal dashboard
* No noisy tool output
* Automatic duplicate removal
* Custom output filenames
* Alive host detection with:

  * HTTP Status Code
  * Page Title

## Tools Used

* subfinder
* amass (passive mode)
* assetfinder
* chaos
* findomain
* httpx
* anew

## Requirements

Install the following tools before running the script:

* Go
* subfinder
* amass
* assetfinder
* chaos
* findomain
* httpx
* anew

## Installation

```bash
git clone https://github.com/yourusername/ultimate-passive-recon.git
cd ultimate-passive-recon
chmod +x script.sh
```

## Usage

```bash
./script.sh <domain> <subs_file> <alive_file>
```

Example:

```bash
./script.sh snapp.ir subs.txt alive.txt
```

## Output

### Subdomains

The first output file contains all unique discovered subdomains.

Example:

```text
api.example.com
dev.example.com
mail.example.com
vpn.example.com
```

### Alive Hosts

The second output file contains only live HTTP/HTTPS hosts.

Each line includes:

* URL
* HTTP Status Code
* Page Title

Example:

```text
https://example.com [200] [Example Domain]
https://api.example.com [403] [Forbidden]
https://admin.example.com [302] [Redirecting]
```

## Workflow

```
subfinder
      ↓
amass (passive)
      ↓
assetfinder
      ↓
chaos
      ↓
findomain
      ↓
Remove Duplicates
      ↓
httpx
      ↓
Alive Hosts
```

## Notes

* Enumeration is performed sequentially.
* Tool output is hidden during execution.
* The dashboard displays:

  * Current stage
  * Progress
  * Elapsed time
  * Number of discovered subdomains
* Results are written only to the specified output files.

## Disclaimer

This project is intended for authorized security testing, bug bounty programs, and educational purposes only.

Use it only against systems you own or have explicit permission to test.

## License

MIT License

