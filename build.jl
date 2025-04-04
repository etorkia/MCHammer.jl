using Pkg

# Clean and reinstall the General registry
Pkg.Registry.rm("General")
Pkg.Registry.add("General")