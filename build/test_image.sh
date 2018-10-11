#!/bin/bash

NP=0
NF=0

function testV() {
	if [ "$( eval $2 )" == "$3" ]
	then
		echo "PASSED - $1"
		NP=$((NP+1))
	else
		echo "FAILED - $1"
		echo $2 != "$3"
		NF=$((NF+1))
	fi
}
function testO() {
	if [[ -z $( diff <( $2 2>/dev/null) <( $3 2>/dev/null) ) ]]
	then
		echo "PASSED - $1"
		NP=$((NP+1))
	else
		echo "FAILED - $1"
		diff <( $2 ) <( $3 )
		echo $2 != "$3"
		NF=$((NF+1))
	fi
}
function testT() {
	$2 &> /dev/null
	RET=$?
	case $RET in
	0)
		echo "PASSED - $1"
		NP=$((NP+1))
		;;
	124)
		echo "PASSED - $1"
		NP=$((NP+1))
		;;
	*)
		echo "FAILED - $RET - $1"
		NF=$((NF+1))
	esac
#&>/dev/null
#	then
#		echo "PASSED - $1"
#		NP=$((NP+1))
#	else
#		echo "$? FAILED - $1"
#		NF=$((NF+1))
#	fi
}
function testF() {
	if $2 &> /dev/null
	then
		echo "FAILED - $1"
		echo "$2"
		NF=$((NF+1))
	else
		echo "PASSED - $1"
		NP=$((NP+1))
	fi
}

function getStatus() {
	sd2e-jupyter show | grep "Status" | cut -f 2 -d " "
}
function exeNB() {
	timeout 10 jupyter nbconvert --execute --ExecutePreprocessor.timeout=2000 "$@"
}
export -f testT exeNB

auth-tokens-refresh -S &>/dev/null
taccname=$(profiles-list me | cut -f 1 -d "@" || echo "Greg Zynda")
fullname=$(profiles-list me | jq -r '"\(.first_name) \(.last_name)"' 2>/dev/null || echo "Greg Zynda")

testV "Running as jupyter user" 'echo $USER' "jupyter"
testV "JUPYTERHUB_USER matches TACC user" 'echo ${JUPYTERHUB_USER}' "$taccname"
testV "JPY_USER matches TACC user" 'echo ${JPY_USER}' "$taccname"
testV "GIT_COMMITTER_NAME is set to TACC user" 'echo $GIT_COMMITTER_NAME' "$fullname"
testV "GIT_COMMITTER_EMAIL is set to real email" 'echo $GIT_COMMITTER_EMAIL' "${taccname}@tacc.utexas.edu"
# Make sure user can write in each folder
for f in */ \.[^\.]*/; do
	case $f in
	sd2e-community/)
		testF "${f%/} is NOT writable" "touch ${f}/cats"
		;;
	.agave/)
		testF "${f%/} is NOT writable" "touch ${f}/cats"
		;;
	sd2e-partners/)
		testF "${f%/} is NOT writable" "touch ${f}/cats"
		;;
	sd2e-projects/)
		testF "${f%/} is NOT writable" "touch ${f}/cats"
		;;
	*)
		testT "${f%/} is writable" "touch ${f}/cats"
		;;
	esac
	[ -e ${f}/cats ] && rm ${f}/cats
done
# Make sure agave works
testT "Can refresh token" "auth-tokens-refresh -S"
# Make sure abaco works
testT "Can poll abaco reactors" "abaco ls"
# Maverick notebooks
testT "Start maverick notebook" "sd2e-jupyter start"
# Test local python installation
for pV in python2 python3; do
	v="${pV:(-1)}"
	testT "Installing ${pV} pysam" "pip${v} install --user pysam"
	testT "$pV pysam was installed to tacc-work/jupyter_packages" "ls -d $( echo ~/tacc-work/jupyter_packages/lib/${pV}*/site-packages/pysam)"
	#testT "pysam can be loaded in ${pV} env" "( [ ${v} -eq 2 ] && source activate ${pV} && echo 'activated' && python -c 'import pysam')"
	if [ "$v" == "2" ]; then
		( source activate python2 && testT "pysam can be loaded in $pV env" "python -c 'import\spysam;'" )
	else
		testT "pysam can be loaded in $pV env" "python -c 'import\spysam;'"
	fi
	rm -rf ~/tacc-work/jupyter_packages
done
# Test example notebooks
for dir in `ls -d $HOME/examples/*/`; do
	find ${dir} -maxdepth 1 -type f -name \*ipynb | head -n 2 | xargs -L 1 -I {} bash -c "cp \"{}\" $(dirname \"{}\")/tmp.ipynb && testT \"{} notebook works\" \"exeNB tmp.ipynb\" && rm $(dirname \"{}\")/tmp.ipynb"
done
for nb in $HOME/examples/*ipynb; do
	#nn=$(echo $nb | tr -s " " "\\ ")
	cp "$nb" tmp.ipynb
	testT "$nb notebook works" "exeNB tmp.ipynb"
	rm tmp.ipynb
done
# Kill notebook job
while [ ! "$(getStatus)" == "RUNNING" ]; do
	sleep 1
done
ID=$(sd2e-jupyter show | grep "Session" | cut -f 3 -d " ")
testT "Stopped sd2e-jupyter job" "sd2e-jupyter stop $ID"

# Summary
echo -e "\n## Summary ##"
echo "$NP tests passed"
echo "$NF tests failed"
