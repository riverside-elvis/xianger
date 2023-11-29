# Add css to the raw markdown.
while IFS= read -r line; do
    if [[ "$line" =~ ^#[[:space:]]Chapter* ]]; then
        echo "${line} {.chapter}"
    else
        echo "$line"
    fi
done < "$1"
