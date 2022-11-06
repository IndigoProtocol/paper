#!/usr/bin/env bash

# Converts main.docx to main.tex

set -e

# Run through pandoc twice
pandoc main.docx -t latex -o main.tex.tmp.pandoc
pandoc main.tex.tmp.pandoc -f latex -t latex -o main.tex.tmp.pandoc

# Copy over head of main.tex
begin=$(grep -n '\tableofcontents' main.tex | head -1 | cut -d ':' -f 1)
begin=$((begin + 1))
head -n "$begin" main.tex > main.tex.tmp

# Copy over pandoc processed file
cat main.tex.tmp.pandoc >> main.tex.tmp
rm main.tex.tmp.pandoc

# Copy over end of main.tex
total_lines=$(wc -l main.tex | cut -d ' ' -f 1)
end=$(grep -n '\end{sloppypar}' main.tex | head -1 | cut -d ':' -f 1)
end=$((total_lines - end + 1))
echo "" >> main.tex.tmp
tail -n "$end" main.tex >> main.tex.tmp

# Fix figures
sed -i 's/\}{}{}/}{}\n\n/g' main.tex.tmp
sed -i 's/\\\protect\\hypertarget/\\hypertarget/g' main.tex.tmp

# Run through preprocess
script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
$script_dir/preprocess.sh main.tex.tmp
