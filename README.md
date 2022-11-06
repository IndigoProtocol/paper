Indigo Paper
============

[![License: CC BY-SA
4.0](https://img.shields.io/badge/License-CC%20BY--SA%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by-sa/4.0/)

This paper is informational and a specification of Indigo Protocol. It
is a free culture work, licensed under Creative Commons Attribution
Share-Alike (CC-BY-SA) Version 4.0.

Indigo is a synthetics platform on the Cardano blockchain. It connects
the real-world to the blockchain, giving everybody equal access to
financial opportunties.

For more information about Indigo, visit the [Indigo
website](https://indigoprotocol.io/).

Usage
-----

The latest version of the Indigo paper in PDF format is available at
https://indigoprotocol.io/paper. Some PDF viewers may place borders
around links within the document. For a better viewing experience, you
may consider using an alternative PDF viewer like SumatraPDF.

To edit the paper, the source code is available in this repository. The
paper is defined in a single `latex` file `main.tex`.

For easy editing, you can use an IDE such as Visual Studio Code with the
LaTeX Workshop extension. This allows you to edit `main.tex` and view
the PDF alongside.

You can also edit `main.tex` in any editor of your choosing, then
compile the PDF using `pdflatex`:

    pdflatex --shell-escape main.tex

This will create a PDF named `main.pdf` that can be viewed in any PDF
reader. For a more streamlined editing experience, SumatraPDF offers the
ability to automatically reload the PDF after compilation. Whereas some
other PDF viewers may require you to manually close and reopen
`main.pdf`.

Processing with Pandoc
----------------------

`pandoc` can be helpful for formatting `main.tex`, such as wrapping long
lines of text. This can make it easier to review changes in git.

To process `main.tex` with pandoc, run `./preprocess.sh`.

`pandoc` has some limitations, such as inability to handle figure and
diagrams, and incorrectly processing tables. After running
`./preprocess.sh`, use git tools to view changes. Discard any changes
that alter structure or otherwise are nonsensical.

Editing with Microsoft Word
---------------------------

`pandoc` can be used to convert `main.tex` into `docx` format:

    ./to-docx.sh

This creates `main.docx` that you can then edit with Microsoft Word.

To convert `main.docx` back into `main.tex`, run:

    ./from-docx.sh

This conversion process will greatly alter formatting. It's recommended
to edit small sections at a time then commit into this repository. After
running `./preprocess.sh`, use git tools to view changes. Discard any
changes that alter structure or otherwise are nonsensical. Manual effort
may be required to complete conversion successfully.
