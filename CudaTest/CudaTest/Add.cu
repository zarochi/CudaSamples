#include <iostream>
#include <cuda.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

static void HandleError(cudaError_t err, const char *file, int line)
{
	if (err != cudaSuccess)
	{
		printf("%s in %s at line %d\n", cudaGetErrorString(err), file, line);
		exit(EXIT_FAILURE);
	}
}

#define HANDLE_ERROR(err)(HandleError(err, __FILE__, __LINE__))

//star character is a pointer
__global__ void add(int a, int b, int *c)
{
	*c = a + b;
}

int main(void)
{
	/*int c;
	int *dev_c; //pointer declaration
	HANDLE_ERROR(cudaMalloc((void**)&dev_c, sizeof(int)));

	add<<<1, 1 >>>(2, 7, dev_c);

	HANDLE_ERROR(cudaMemcpy(&c, dev_c, sizeof(int), cudaMemcpyDeviceToHost));*/

	int count;
	cudaDeviceProp prop;
	HANDLE_ERROR(cudaGetDeviceCount(&count));
	for (int x = 0; x < count; x++)
	{
		HANDLE_ERROR(cudaGetDeviceProperties(&prop, x));
		printf("Device %d \n", x);
		printf("Name: %s\n", prop.name);
		printf("Compute Capability: %d.%d\n", prop.major, prop.minor);
		printf("Clock rate: %d\n", prop.clockRate);
		if (prop.deviceOverlap) { printf("Overlap Enabled\n"); };
		if (prop.kernelExecTimeoutEnabled) { printf("Kernal Timeout Enabled\n"); };
		printf("Memory Info\n");
		printf("Total global mem: %ld\n", prop.totalGlobalMem);	
		printf("Total constant mem: %ld\n", prop.totalConstMem);
		printf("Max mem pitch: %ld\n", prop.memPitch);
		printf("Texture Alignment: %ld\n", prop.textureAlignment);
		printf("Multiprocessor info\n");
		printf("Multiprocessor count: %d\n", prop.multiProcessorCount);
		printf("Shared mem per mp %d\n", prop.sharedMemPerBlock);
		printf("Registers per mp %d\n", prop.regsPerBlock);
		printf("Threads in warp: %d\n", prop.warpSize);
		printf("Memory per block: %d\n", prop.sharedMemPerBlock);
		printf("Max threads per block: %d\n", prop.maxThreadsPerBlock);
		printf("Max thread dimensions (%d, %d, %d)\n", prop.maxThreadsDim[0], prop.maxThreadsDim[1], prop.maxThreadsDim[2]);
		printf("Max grid dimensions: (%d, %d, %d)\n", prop.maxGridSize[0], prop.maxGridSize[1], prop.maxGridSize[2]);
	}
	//page 34 - 55 in pdf
	//printf("%d",count);
	//printf("2 + 7 = %d\n", c);
	//cudaFree(dev_c);
	getchar();
	return 0;
}