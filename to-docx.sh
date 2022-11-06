#!/usr/bin/env bash

# Runs converts main.tex to main.docx

set -e

# Convert tabularx tables to longtables so pandoc can understand
sed 's/\\end{tabularx}/\\end{longtable}/g' "${1:-main.tex}" > main.tex.tmp.pandoc
sed -i 's/\\begin{tabularx}{\\linewidth}{/\\begin{longtable}[]{/g' main.tex.tmp.pandoc
sed -i 's/\\begin{longtable}.*/\L&/g' main.tex.tmp.pandoc

# Convert formulas
sed -i 's/\\genfrac{}{}{}{}/\\frac/g' main.tex.tmp.pandoc
sed -i 's/\\cfrac/\\frac/g' main.tex.tmp.pandoc
sed -i 's/\\raisebox//g' main.tex.tmp.pandoc
sed -i 's/{\$/{/g' main.tex.tmp.pandoc
sed -i 's/\$}/}/g' main.tex.tmp.pandoc

# Process with pandoc
pandoc main.tex.tmp.pandoc -f latex -t docx -o main.docx
rm main.tex.tmp.pandoc
