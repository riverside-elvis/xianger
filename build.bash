# Build the ebook. Check build.md to prep build environment.

# Check arg.
case $1 in
    epub) echo "Building $1" ;;
    pdf) echo "Building $1" ;;
    *) echo >&2 "Usage: $0 [epub|pdf]" && exit 1
esac

# Pre-process foreward template version.
if [[ -n $(git status -s) ]]; then
    COMMIT="#######"
    EPOCH=$(date +%s)
else
    COMMIT=$(git log -1 --format=%h)
    EPOCH=$(git log -1 --format=%ct)
    TAG=$(git describe --tags --candidates=0 $COMMIT 2>/dev/null)
    if [[ -n $TAG ]]; then
        COMMIT=$TAG
    fi
fi
DATE="@$EPOCH"
VERSION="Commit $COMMIT, $(date -d $DATE +'%B %d, %Y')."
sed "s/{{ version }}/$VERSION/g" foreward.tpl.md > foreward.md
echo "${VERSION}"

# Pre-process input files.
MD="XiangerLaozi-$COMMIT.md"
sed -s '$G' -s \
    foreward.md \
    03.md \
    04.md \
    05.md \
    06.md \
    07.md \
    08.md \
    09.md \
    10.md \
    11.md \
    12.md \
    13.md \
    14.md \
    15.md \
    16.md \
    17.md \
    18.md \
    19.md \
    20.md \
    21.md \
    22.md \
    23.md \
    24.md \
    25.md \
    26.md \
    27.md \
    28.md \
    29.md \
    30.md \
    31.md \
    32.md \
    33.md \
    34.md \
    35.md \
    36.md \
    37.md \
    intro.md \
    canon.md \
    README.md \
    intro-notes.md \
    footnotes.md \
    endnotes.md \
    rse-notes.md > "$MD"

# Build epub.
if [ $1 = "epub" ]; then
    EPUB="XiangerLaozi-$COMMIT.epub"
    HTML="XiangerLaozi-$COMMIT.html.md"
    bash epub-html.bash "$MD" > "$HTML"
    pandoc "$HTML" \
        --defaults epub-defaults.yaml \
        --output "${EPUB}"
    echo Built "${EPUB}"
fi

## Or build pdf.
if [ $1 = "pdf" ]; then
    PDF="XiangerLaozi-$COMMIT.pdf"
    TEX="XiangerLaozi-$COMMIT.tex.md"
    bash pdf-latex.bash "$MD" > "$TEX"
    pandoc "$TEX" \
        --defaults pdf-defaults.yaml \
        --output "${PDF}"
    echo Built "${PDF}"
fi
