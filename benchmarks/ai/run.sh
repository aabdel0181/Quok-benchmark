#!/bin/bash
set -e

# Create results directory
mkdir -p ../../results

# Run AI benchmark and save raw output
python3 -c "
from ai_benchmark import AIBenchmark
benchmark = AIBenchmark()
results = benchmark.run()
" > ../../results/ai_raw.txt

# Create JSON output
cat > ../../results/ai_results.json << EOF
{
  "benchmark": "ai",
  "results": $(awk '
    BEGIN { printf "{\n" }
    /Device:/ { printf "    \"device\": \"%s\",\n", substr($0, index($0,":")+2) }
    /Score:/ { printf "    \"score\": %s\n", $2 }
    END { printf "  }" }' ../../results/ai_raw.txt)
}
EOF

# Display results
cat ../../results/ai_results.json