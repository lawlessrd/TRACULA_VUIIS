#!/bin/bash
#
# Full T1 pipeline:
#    recon-all
#    volume computations/reformatting
#    PDF creation

# Defaults
export config_file="/INPUTS/tracula.config"
export trac_opts=""

# Parse inputs
while [[ $# -gt 0 ]]
do
  key="$1"
  case $key in
    --config_file)
        export config_file="$2"; shift; shift;;
    --trac_opts)
        export trac_opts="$2"; shift; shift;;
    *)
		echo "Unknown argument $key"; shift;;
  esac
done

# Show what we got
echo config_file    = "${config_file}"
echo trac_opts  = "${trac_opts}"

# Set freesurfer subjects dir and others
#export SUBJECTS_DIR="${out_dir}"
#export tmp_dir="${SUBJECTS_DIR}"/SUBJECT/tmp
#export mri_dir="${SUBJECTS_DIR}"/SUBJECT/mri
#export surf_dir="${SUBJECTS_DIR}"/SUBJECT/surf

# trac-all
trac-all -prep -c "${config_file}" ${trac_opts}
trac-all -bedp -c "${config_file}"
trac-all -path -c "${config_file}"

# Subregion modules (xvfb needed)
#segmentBS.sh SUBJECT
#segmentHA_T1.sh SUBJECT
#segmentThalamicNuclei.sh SUBJECT

# Produce additional outputs and organize
#volume_computations.sh
#create_MM_labelmaps.sh
#make_outputs.sh
