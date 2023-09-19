#!/bin/sh

# Parcellation on pial surface
# Parcellation on white matter surface
# "Scaled CNR" on white matter surface

# Get Freesurfer screenshots
cd "${SUBJECTS_DIR}"/SUBJECT
freeview -cmd ${src_dir}/page1_cmd.txt
mv *.png ${tmp_dir}
cd ${tmp_dir}

# Trim, change background to white, resize
for p in \
lh_lat_pial lh_med_pial rh_lat_pial rh_med_pial \
lh_lat_white lh_med_white rh_lat_white rh_med_white \
; do
	convert ${p}.png \
	-fill none -draw "color 0,0 floodfill" -background white \
	-trim -bordercolor white -border 20x20 -resize 400x400 \
	${p}.png
done

# Get CNR
mri_cnr "${SUBJECTS_DIR}"/SUBJECT/surf \
"${SUBJECTS_DIR}"/SUBJECT/mri/nu.mgz \
| tr -d '\t' > nu_cnr.txt
cnrtxt="$(cat nu_cnr.txt)"

# Make montage
montage -mode concatenate \
lh_lat_pial.png lh_med_pial.png rh_lat_pial.png rh_med_pial.png \
lh_lat_white.png lh_med_white.png rh_lat_white.png rh_med_white.png \
-tile 2x -quality 100 -background white -gravity center \
-trim -border 20 -bordercolor white -resize 600x eight.png

# Add info
# 8.5 x 11 at 144dpi is 1224 x 1584
# inside 15px border is 1194 x 1554
convert \
-size 1224x1584 xc:white \
-gravity South \( eight.png -resize 1194x1194 -geometry +0+100 \) -composite \
-gravity NorthEast -interline-spacing 28 -pointsize 24 -annotate +20+50 "${cnrtxt}" \
-gravity SouthEast -pointsize 24 -annotate +20+20 "$the_date" \
-gravity SouthWest -pointsize 24 -annotate +20+20 "$(cat $FREESURFER_HOME/build-stamp.txt)" \
-gravity NorthWest -pointsize 24 -annotate +20+50 "${label_info}" \
page1.png

