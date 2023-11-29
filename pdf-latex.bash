# Pre-process markdown to insert latex before generating the PDF.
LATEX=0
LAOZI=0
COMMENTARY=0
BLOCKS=0
while IFS= read -r line; do

    # Chapter titles reset LATEX processing.
    if [[ "$line" =~ ^#[[:space:]]Chapter ]]; then
        LATEX=1
        LAOZI=0
        COMMENTARY=0
        BLOCKS=0
        echo "$line"
        continue
    fi

    # Appendix stops processing.
    if [[ "$line" =~ ^#[[:space:]]Appendix ]]; then
        LATEX=0
        LAOZI=0
        COMMENTARY=0
        BLOCKS=0
        echo "$line"
        continue
    fi

    # Print the line if not processing.
    if [[ $LATEX -ne 1 ]]; then
        echo "$line"
        continue
    fi

    # Empty lines end LAOZI and COMMENTARY blocks.
    if [[ "$line" = "" ]]; then
        if [[ $BLOCKS -ne 1 ]]; then
            echo "$line"
            continue
        fi
        if [[ $COMMENTARY -eq 1 ]]; then
            COMMENTARY=0
            echo "$line"
            continue
        elif [[ $LAOZI -eq 1 ]]; then
            LAOZI=0
            echo -n "$line"
            echo '\normalsize'
            echo
            continue
        fi
    fi

    # Blockquote lines start a COMMENTARY block.
    if [[ "$line" =~ ^\>[[:space:]] ]]; then
        COMMENTARY=1
        BLOCKS=1
        echo "$line"
        continue
    fi

    # Non-empty lines start LAOZI blocks.
    if [[ $LAOZI -eq 0 ]] && [[ $COMMENTARY -eq 0 ]]; then
        LAOZI=1
        if [[ $BLOCKS -eq 1 ]]; then
            echo '\bigskip'
        fi
        BLOCKS=1
        echo '\large'
        echo "$line"
        continue
    fi

    echo "$line"

done < "$1"
