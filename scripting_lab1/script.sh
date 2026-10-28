#!/bin/bash
# prepare_sim.sh - Prepare a simulation run for a VLSI project
# Usage: ./prepare_sim.sh <project_directory>

# 1. Check command-line argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 <project_directory>" >&2
    exit 1
fi

PROJ="${1%/}"                      # strip trailing slash
RTL_DIR="$PROJ/rtl"
TIMING="$PROJ/reports/timing.txt"
RESULTS="$PROJ/results"

# 2. Validate required inputs, collecting every missing item
missing=0
[ -d "$PROJ" ]    || { echo "ERROR: Project directory '$PROJ' not found." >&2; exit 2; }
[ -d "$RTL_DIR" ] || { echo "ERROR: Missing folder: $RTL_DIR" >&2; missing=1; }
[ -f "$TIMING" ]  || { echo "ERROR: Missing timing report: $TIMING" >&2; missing=1; }

if [ $missing -ne 0 ]; then
    echo "Simulation preparation aborted: required inputs missing." >&2
    exit 3
fi

# 3. Create results directory
mkdir -p "$RESULTS" || { echo "ERROR: Cannot create $RESULTS" >&2; exit 4; }

# 4. List all .v and .sv files
find "$RTL_DIR" -type f \( -name "*.v" -o -name "*.sv" \) | sort > "$RESULTS/source_files.txt"

# 5. Copy timing report
cp "$TIMING" "$RESULTS/" || { echo "ERROR: Failed to copy timing report." >&2; exit 5; }

# 6. Count sources and write summary
count=$(wc -l < "$RESULTS/source_files.txt")

if [ "$count" -eq 0 ]; then
    status="FAILED - no .v/.sv files found in $RTL_DIR"
    rc=6
else
    status="READY"
    rc=0
fi

{
    echo "Project         : $PROJ"
    echo "Source file count: $count"
    echo "Run status      : $status"
} > "$RESULTS/run_summary.txt"

cat "$RESULTS/run_summary.txt"
[ $rc -ne 0 ] && echo "ERROR: $status" >&2
exit $rc
