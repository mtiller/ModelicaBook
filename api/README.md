# Purpose

This directory contains the source for an API that can be invoked to run
simulations associated with the book.  Orginally, these simulations were
invoked in the browser by cross-compiling the simulation code into
Javascript.  While very cool, this was problematic for a couple of
reasons:

    1. The cross-compilation tool chain is not stable and made
       reliable builds and CI/CD difficult.
    2. It made simulation on mobile devices, for example, a bit
       unreliable because the memory required may not be available.

So, I've decided to move the interactive simulation of the examples out
of the browser to a publically accessible service.  This adds more 
moving parts (because I now have to run code in the cloud instead of
merely serving static files to everybody).  But basic services like
this have become a commodity and I think I can integrate them better
into my CI/CD process than the Javascript code generation I did 
previously.

# Libraries

The `./libs` directory contains the shared libraries necessary to 
run the OM generated executables.