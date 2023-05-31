# Notes

Each generated executable has a hash associated with it. This hash is the hash
of the original "save total" modelica model that the executable was built from.
The value is stored in the `..._info.json` file for future reference. In this
way, we can efficiently determine whether the executable needs to be recompiled
or not.

By default, the executables should include the architecture they were built for
but there should also be an option to suppress that.
