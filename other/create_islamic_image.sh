#!/bin/bash

# Variables
# IMAGE="/media/ahmed/Ahmed/أحاديث/حديث.png"
IMAGE="/home/ahmed/Pictures/103fb81b71bcfdd4ad67070144896b14.jpg"
OUTPUT="output_image.png"

HEADER="قال رسول الله صلى الله عليه وسلم:"
TEXT="لا تَحْقِرَنَّ مِنَ المَعروفِ شيئًا ولو أنْ تَلْقَى أخاكَ بوَجْهٍ طَلْقٍ."
FOOTER="الراوي : أبو ذر الغفاري | المصدر : صحيح مسلم"

# Font settings
HEADER_FONT="Janna-LT-Bold"
HEADER_FONT_SIZE="35"
TEXT_FONT="Janna-LT-Bold"
TEXT_FONT_SIZE="65"
FOOTER_FONT="Janna-LT-Bold"
FOOTER_FONT_SIZE="25"

# Colors
TEXT_COLOR="black"

# Canvas dimensions
CANVAS_WIDTH=500
CANVAS_HEIGHT=1600

# Padding (in pixels)
HEADER_PADDING_TOP=80    # Padding above the header
HEADER_PADDING_BOTTOM=20 # Padding below the header
TEXT_PADDING_TOP=60      # Padding above the main text
TEXT_PADDING_BOTTOM=65   # Padding below the main text
FOOTER_PADDING_TOP=30    # Padding above the footer
FOOTER_PADDING_BOTTOM=0 # Padding below the footer

# Create temporary files for header, text, and footer
TMP_HEADER=$(mktemp XXXXXX_header.png)
TMP_TEXT=$(mktemp XXXXXX_text.png)
TMP_FOOTER=$(mktemp XXXXXX_footer.png)

# Ensure temporary files are removed on exit
cleanup() {
    rm -f "$TMP_HEADER" "$TMP_TEXT" "$TMP_FOOTER"
}
trap cleanup EXIT

# Create header image with padding
magick -background none -fill "$TEXT_COLOR" -font "$HEADER_FONT" -pointsize $HEADER_FONT_SIZE \
       -size ${CANVAS_WIDTH}x -gravity North caption:"$HEADER" \
       -bordercolor none -border 0x${HEADER_PADDING_BOTTOM} "$TMP_HEADER"

# Create main text image with padding
magick -background none -fill "$TEXT_COLOR" -font "$TEXT_FONT" -pointsize $TEXT_FONT_SIZE \
       -size ${CANVAS_WIDTH}x -gravity Center caption:"$TEXT" \
       -bordercolor none -border 0x${TEXT_PADDING_BOTTOM} "$TMP_TEXT"

# Create footer image with padding
magick -background none -fill "$TEXT_COLOR" -font "$FOOTER_FONT" -pointsize $FOOTER_FONT_SIZE \
       -size ${CANVAS_WIDTH}x -gravity South caption:"$FOOTER" \
       -bordercolor none -border 0x${FOOTER_PADDING_TOP} "$TMP_FOOTER"

# Create a blank canvas with the same dimensions as the background image
magick "$IMAGE" -alpha set -background none temp_canvas.png

# Composite header onto the canvas
HEADER_HEIGHT=$(magick identify -format "%h" "$TMP_HEADER")
magick temp_canvas.png "$TMP_HEADER" -gravity North -geometry +0+${HEADER_PADDING_TOP} -composite temp_canvas.png

# Composite main text onto the canvas
TEXT_HEIGHT=$(magick identify -format "%h" "$TMP_TEXT")
TEXT_Y=$((HEADER_PADDING_TOP + HEADER_HEIGHT + HEADER_PADDING_BOTTOM + TEXT_PADDING_TOP))
magick temp_canvas.png "$TMP_TEXT" -gravity North -geometry +0+${TEXT_Y} -composite temp_canvas.png

# Composite footer onto the canvas
FOOTER_HEIGHT=$(magick identify -format "%h" "$TMP_FOOTER")
FOOTER_Y=$((TEXT_Y + TEXT_HEIGHT + TEXT_PADDING_BOTTOM + FOOTER_PADDING_TOP))
magick temp_canvas.png "$TMP_FOOTER" -gravity North -geometry +0+${FOOTER_Y} -composite temp_canvas.png

# Composite the final canvas over the original image
magick composite -gravity center temp_canvas.png "$IMAGE" "$OUTPUT"

# Clean up all temporary files
rm temp_canvas.png

echo "Image created: $OUTPUT"
