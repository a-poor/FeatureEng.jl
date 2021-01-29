test-module: 
	@echo "Running test..."
	julia -e "using Pkg; Pkg.activate(\".\"); Pkg.test()"