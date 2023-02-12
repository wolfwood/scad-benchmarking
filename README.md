# OpenSCAD Benchmarking
This script is for benchmarking `openscad` optimization and parallelization efforts, which are guarded by feature flags. Ideally, it operates as a wrapper for `hyperfine`, rangling the various sets of feature flags. `hyperfine` will execute multiple runs to ensure reliable measurements and print a nice summary of the results highlighting the best combinations. However, there is fallback code to time single runs of every combination, if `hyperfine` is missing. See https://github.com/sharkdp/hyperfine for details.


## Use
First, you should download a development release of OpenSCAD from https://openscad.org/downloads.html#snapshots and point `OPENSCAD_NIGHTLY` at it. If using an AppImage, remember to `chmod +x` it before running.

For benchmarking the [tryadactyl](https://github.com/wolfwood/tryadactyl/tree/fast-csg-test) files *rest.scad*, *thumb.scad*, *plate.scad*, *fingers.scad* and *assembly.scad*, I use the command `FILES="rest thumb plate fingers assembly" ../scad-benchmarking/time.sh`, from the root of the *tryadactyl* repo, assuming *scad-benchmarking* is in a sibling directory.

For benchmarking *CS.scad* from [trackpoint-keycap-mods](https://github.com/wolfwood/trackpoint-keycap-mods) , I use the command `OPENSCAD_ARGS="-q --render" LAZY_UNION=--enable=lazy-union FILES="CS" ../scad-benchmarking/time.sh`. `OPENSCAD_ARGS` is overridden to remove the option `--hardwarnings`, since my file has a dependency with a lot of warnings. `LAZY_UNION` is overridden because the original tests both with and without lazy union using a leading ',' to indicate an empty string: `LAZY_UNION=,--enable=lazy-union`. However, my test was (temporarily) failing without lazy union.

Any of the variables in the begining of the script can be overridden similarly.

Note: the environment variable `OPENSCADPATH` can be used to add to the locations where `openscad` searchs for *include<>*s, which might help you avoid copying around files to ease your benchmarking effort.
