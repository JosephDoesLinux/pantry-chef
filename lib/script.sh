#!/bin/bash

find . -name "*.dart" -print0 | while IFS= read -r -d $'\0' file; do
    echo "--- FILE START: $file ---"
    cat "$file"
    echo "--- FILE END: $file ---"
    echo ""
done
