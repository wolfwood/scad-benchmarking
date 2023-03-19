# OpenSCAD Benchmarking
This script is for benchmarking `openscad` optimization and parallelization efforts, which are guarded by feature flags. Ideally, it operates as a wrapper for `hyperfine`, wrangling the various sets of feature flags. `hyperfine` will execute multiple runs to ensure reliable measurements and print a nice summary of the results highlighting the best combinations. However, there is fallback code to time single runs of every combination, if `hyperfine` is missing. See https://github.com/sharkdp/hyperfine for details.

## Use
First, you should download a development release of OpenSCAD from https://openscad.org/downloads.html#snapshots and point `OPENSCAD` at it. If using an AppImage, remember to `chmod +x` it before running.

For benchmarking the [tryadactyl](https://github.com/wolfwood/tryadactyl/tree/fast-csg-test) files *rest.scad*, *thumb.scad*, *plate.scad*, *fingers.scad* and *assembly.scad*, I use the command `FILES="rest thumb plate fingers assembly" ../scad-benchmarking/time.sh`, from the root of the *tryadactyl* repo, assuming *scad-benchmarking* is in a sibling directory.

For benchmarking *CS.scad* from [trackpoint-keycap-mods](https://github.com/wolfwood/trackpoint-keycap-mods) , I use the command `OPENSCAD_WARNINGS=" " LAZY_UNION=--enable=lazy-union FILES="CS" ../scad-benchmarking/time.sh`. `OPENSCAD_WARNINGS` is overridden (with a space, so the script know it was set) to remove the option `--hardwarnings`, since my file has a dependency with a lot of warnings. `LAZY_UNION` is overridden because the original value tests both with and without lazy union, using a leading ',' to indicate an empty string: `LAZY_UNION=,--enable=lazy-union`. However, my test was (temporarily) failing without lazy union so I needed to force its use.

Any of the variables in the beginning of the script can be overridden similarly.

Note: the environment variable `OPENSCADPATH` can be used to add to the locations where `openscad` searchs for *include<>*s, which might help you avoid copying around files to ease your benchmarking effort.

## Manifold (parallel renderer) TL;DR
  1. get a [build from PR 4533](https://github.com/openscad/openscad/pull/4533), and `chmod +x`

  2. for benchmarking manifold against the unmodified CGAL renderer run `OPENSCAD=<path-to-build-from-PR-4533> FILES="<name without extension of each .scad file to benchmark>" FAST_CSG=",--enable=manifold" REMESH=" " LAZY_UNION=" " ../scad-benchmarking/time.sh`

  3. manually launch the build, select manifold on the feature pane. and render. visually inspect the result to ensure it matches expectations.

## Catching Regressions
If any of the configurations crash for you, there are missing or incomplete parts, or if `--enable=manifold` or `--enable=fast-csg --enable=fast-csg-remesh` is slower than a plain run, open an issue with OpenSCAD: https://github.com/openscad/openscad/issues
