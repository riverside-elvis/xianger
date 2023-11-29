# Build environment

This works on a Debian 12 host.

## Pandoc

Install packages and clone the repo.

    sudo apt install git pandoc

## EPUB

The EPUB relies entirely on system fonts.

Run the build script:

    bash build.bash epub

## PDF

To build the PDF,
install fonts and TeX Live with CJK support.

    sudo apt install texlive-xetex texlive-lang-cjk
    sudo apt install fonts-noto-cjk-extra

Build the PDF.

    bash build.bash pdf
