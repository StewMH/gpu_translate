curl -L https://cuda-tutorial.readthedocs.io/en/latest/tutorials/tutorial01/solutions/vector_add.cu -o vector_add.cu
curl -L https://github.com/alpaka-group/alpaka/archive/refs/tags/2.0.0.tar.gz -o 2.0.0.tar.gz
tar xzvf 2.0.0.tar.gz
cp alpaka-2.0.0/example/vectorAdd/src/vectorAdd.cpp .
curl -L https://raw.githubusercontent.com/oneapi-src/oneAPI-samples/master/DirectProgramming/C%2B%2BSYCL/DenseLinearAlgebra/vector-add/src/vector-add-buffers.cpp -o vector-add-buffers.cpp
