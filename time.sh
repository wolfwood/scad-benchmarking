#!/usr/bin/env bash

#set -x

# where's the binary?
OPENSCAD=${OPENSCAD:=${HOME}/Downloads/OpenSCAD-2023.01.23.ai13617-x86_64.AppImage}

# this is how I normally render
OPENSCAD_ARGS=${OPENSCAD_ARGS:="-q --render"}

WARNINGS=${WARNINGS:=""} #--hardwarnings

# supply some vars
OPENSCAD_EXTRA_ARGS=${OPENSCAD_EXTRA_ARGS:=""}
#'-D \$prerendered_keycaps=true -D \$disable_keycap_render=true'


# the sets of parameters to explore
LAZY_UNION=${LAZY_UNION:=,--enable=lazy-union}
REMESH=${REMESH:=,--enable=fast-csg-remesh}
FAST_CSG=${FAST_CSG:=",--enable=manifold,--enable=fast-csg,--enable=fast-csg --enable=fast-csg-exact,--enable=fast-csg --enable=fast-csg-exact-callbacks,--enable=fast-csg --enable=fast-csg-trust-corefinement,--enable=fast-csg --enable=fast-csg-trust-corefinement --enable=fast-csg-exact,--enable=fast-csg --enable=fast-csg-trust-corefinement --enable=fast-csg-exact-callbacks"}

#NO_HYPE=1
HYPER_ARGS=${HYPER_ARGS:="-m 2 -M 20"}

# the different file possibilities
FILES=${FILES:=""}

mkdir -p things/

if command -v hyperfine &> /dev/null && [ -z ${NO_HYPE} ]
then
    for FILE in ${FILES}
    do
	hyperfine ${HYPER_ARGS} -L lazy "${LAZY_UNION}" -L remesh "${REMESH}" -L rend "${FAST_CSG}" "${OPENSCAD} ${OPENSCAD_ARGS} ${WARNINGS} ${OPENSCAD_EXTRA_ARGS} {lazy} {rend} {remesh} -o things/test_${FILE}.stl ${FILE}.scad" -c "bash -c \"[ -s things/test_${FILE}.stl ] || echo \\\"ERROR: render {lazy} {rend} {remesh} of ${FILE} produced empty .stl\\\"\""
    done
else

    echo "please 'cargo install hyperfine' for a better experience"
    #exit 1;

    for FILE in ${FILES//,/ }
    do
	FOO=${FAST_CSG// /%}
	for REND in ""${FOO//,/ }
	do
	    for MESH in ""${REMESH//,/ }
	    do
		for LAZY in ""${LAZY_UNION//,/ }
		do
		    echo " > ${FILE} ${REND//%/ } ${MESH} ${LAZY}"
		    time "${OPENSCAD}" ${OPENSCAD_ARGS} ${WARNINGS} ${OPENSCAD_EXTRA_ARGS} ${LAZY} ${MESH} ${REND//%/ } -o things/test_${FILE}.stl ${FILE}.scad

		    [ -s things/test_${FILE}.stl ] || echo "ERROR: render ${LAZY} ${MESH} ${REND} of ${FILE} produced empty .stl"
		done
	    done
	done
    done
fi
