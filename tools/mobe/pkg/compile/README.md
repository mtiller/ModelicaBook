# Notes

Generated exes have an additional 16 bytes appended to them. These bytes are
the hash of the original "save total" modelica model that the executable was
built from. In this way, we can efficiently determine whether the executable
needs to be recompiled or not.

By default, the executables should include the architecture they were built for
but there should also be an option to suppress that.
