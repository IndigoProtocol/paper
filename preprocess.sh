#!/usr/bin/env bash

# Runs main.tex through pandoc

set -e

# Convert tabularx tables to longtables so pandoc can understand
sed 's/\\end{tabularx}/\\end{longtable}/g' "${1:-main.tex}" > main.tex.tmp.pandoc
sed -i '' -e 's/\\begin{tabularx}{\\linewidth}{/\\begin{longtable}[]{/g' main.tex.tmp.pandoc
sed -i '' -e 's/\\begin{longtable}.*/\L&/g' main.tex.tmp.pandoc

# Fix texttt
sed -i '' -e 's/}\\texttt{//g' main.tex.tmp.pandoc

# Process with pandoc
pandoc main.tex.tmp.pandoc -f latex -t latex -o main.tex.tmp.pandoc

# Copy over head of main.tex
begin=$(grep -n '\tableofcontents' main.tex | head -1 | cut -d ':' -f 1)
begin=$((begin + 1))
head -n "$begin" main.tex > main.tex.tmp

# Copy over pandoc processed file
cat main.tex.tmp.pandoc >> main.tex.tmp
rm main.tex.tmp.pandoc

# Remove messed up title page pandoc creates
start=$(grep -n '\tableofcontents' main.tex.tmp | head -1 | cut -d ':' -f 1)
end=$(grep -n '\hypertarget' main.tex.tmp | head -1 | cut -d ':' -f 1)
start=$((start + 1))
end=$((end - 2))
sed -i '' -e "${start},${end}d" main.tex.tmp

# Copy over end of main.tex
total_lines=$(wc -l main.tex | cut -d ' ' -f 1)
end=$(grep -n '\end{sloppypar}' main.tex | head -1 | cut -d ':' -f 1)
end=$((total_lines - end + 1))
echo "" >> main.tex.tmp
tail -n "$end" main.tex >> main.tex.tmp

# Format tables
sed -i '' -e 's/\\tabularnewline/\n\\tabularnewline\n\\midrule/g' main.tex.tmp
sed -i '' -e '1h;2,$H;$!d;g' -e 's/\\midrule\n\\midrule/\\midrule/g' main.tex.tmp
sed -i '' -e '1h;2,$H;$!d;g' -e 's/\\midrule\n\\toprule/\\toprule/g' main.tex.tmp
sed -i '' -e '1h;2,$H;$!d;g' -e 's/\\midrule\n\\bottomrule/\\bottomrule/g' main.tex.tmp
sed -i '' -e 's/\\strut//g' main.tex.tmp
sed -i '' -e '/^\\begin{minipage}/d' main.tex.tmp
sed -i '' -e 's/^\\end{minipage}.*/\&/g' main.tex.tmp
sed -i '' -e '1h;2,$H;$!d;g' -e 's/\&\n\\tabularnewline/\\tabularnewline/g' main.tex.tmp
sed -i '' -e '/\\endfirsthead/,/\\midrule/d' main.tex.tmp
sed -i '' -e '1h;2,$H;$!d;g' -e 's/\\\midrule\n\\midrule/\\midrule/g' main.tex.tmp
sed -i '' -e 's/\\ldots{}/\\ldots/g' main.tex.tmp

# Convert longtables back to tabularx
sed -i '' -e 's/\\end{longtable}/\\end{tabularx}/g' main.tex.tmp
tabularx_headers=($(grep '\\begin{tabularx}' main.tex))
longtable_headers=($(grep -n '\\begin{longtable}' main.tex.tmp | cut -d ':' -f 1))

for ((i = 0; i < ${#longtable_headers[@]}; ++i)); do
    line="${longtable_headers[$i]}"
    replace=${tabularx_headers[$i]//\\/\\\\}
    gawk -i inplace "NR==${line} {\$0=\"${replace}\"}1" main.tex.tmp
done

# Process figures
script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
python3 $script_dir/figures.py

# Remove height from images
sed -i '' -e 's/\,height=\\textheight//g' main.tex.tmp

# Done
mv main.tex.tmp main.tex
