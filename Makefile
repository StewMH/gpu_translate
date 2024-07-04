.PHONY: clean download
download: download.sh 
	./download.sh

cuda_vector_add: vector_add.cu
	nvcc -o cuda_vector_add vector_add.cu

hipify_vector_add: vector_add.cu
	hipify-perl vector_add.cu > vector_add.hip
	hipcc -o hipify_vector_add vector_add.hip

#SYCL seems to be happiest if clang is there already
#On CERN lxplus
#source /cvmfs/projects.cern.ch/intelsw/oneAPI/linux/all-setup.sh
#setupATLAS; lsetup clang
sycl_cpu_vector_add: vector-add-buffers.cpp
	icpx -fsycl -o sycl_cpu_vector_add vector-add-buffers.cpp

sycl_intel_vector_add: vector-add-buffers.cpp
	icpx -fsycl -fsycl-targets=spir64 -o sycl_intel_vector_add vector-add-buffers.cpp

sycl_cuda_vector_add: vector-add-buffers.cpp
	icpx -fsycl -fsycl-targets=nvptx64-nvidia-cuda -o sycl_cuda_vector_add vector-add-buffers.cpp

sycl_amd_vector_add: vector-add-buffers.cpp
	icpx -fsycl -fsycl-targets=amdgcn-amd-amdhsa -Xsycl-target-backend --offload-arch=gfx1031 -o sycl_amd_vector_add vector-add-buffers.cpp

alpaka_cpu_vector_add: vectorAdd.cpp
	g++ -o alpaka_cpu_vector_add -std=c++20 vectorAdd.cpp -I alpaka-1.1.0/include -DALPAKA_ACC_CPU_B_SEQ_T_SEQ_ENABLED

alpaka_hip_vector_add: vectorAdd.cpp
	hipcc -o alpaka_hip_vector_add -std=c++20 vectorAdd.cpp -I alpaka-1.1.0/include -DALPAKA_ACC_GPU_HIP_ENABLED

BOOST_INCLUDE_DIR=/cvmfs/atlas-nightlies.cern.ch/repo/sw/main_Athena_x86_64-centos7-gcc11-opt/sw/lcg/releases/LCG_104c_ATLAS_5/Boost/1.82.0/x86_64-centos7-gcc11-opt/include
NVCC_OPTS=-forward-unknown-to-host-compiler -ccbin=/cvmfs/sft.cern.ch/lcg/releases/gcc/13.1.0-b3d18/x86_64-centos7/bin/g++ -DALPAKA_BLOCK_SHARED_DYN_MEMBER_ALLOC_KIB=47 --extended-lambda --expt-relaxed-constexpr --display-error-number -Xcompiler -pthread -MD -x cu

alpaka_cuda_vector_add: vectorAdd.cpp
	nvcc -o alpaka_cuda_vector_add vectorAdd.cpp -I alpaka-1.1.0/include -DALPAKA_ACC_GPU_CUDA_ENABLED -I $(BOOST_INCLUDE_DIR) $(NVCC_OPTS)

alpaka_sycl_cpu_vector_add: vectorAdd.cpp
	icpx -fsycl -o alpaka_sycl_cpu_vector_add vectorAdd.cpp -I alpaka-1.1.0/include -DALPAKA_SYCL_ONEAPI_CPU -DALPAKA_ACC_SYCL_ENABLED

alpaka_sycl_intel_vector_add: vectorAdd.cpp
	icpx -fsycl -o alpaka_sycl_intel_vector_add vectorAdd.cpp -I alpaka-1.1.0/include -DALPAKA_SYCL_ONEAPI_GPU -DALPAKA_ACC_SYCL_ENABLED

alpaka_sycl_cuda_vector_add: vectorAdd.cpp
	icpx -fsycl -o alpaka_sycl_intel_vector_add vectorAdd.cpp -I alpaka-1.1.0/include -DALPAKA_SYCL_ONEAPI_GPU -DALPAKA_ACC_SYCL_ENABLED


clean:
	rm -rf alpaka-1.1.0
	rm -rf *tgz
	rm -f *vector_add
	rm -f *.cu *.hip *sycl *cpp
