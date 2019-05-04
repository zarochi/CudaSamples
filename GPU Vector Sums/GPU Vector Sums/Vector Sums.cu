#include <iostream>
#include <cuda.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

#define N 10

__global__ void add(int *a, int *b, int *c)
{
	//blockIdx is the value of the block index for whichever block is running the code
	int tid = blockIdx.x;//handle the data at this index
	//blockIdx has 2 dimensions; x and y. We only need one dimension
	if(tid < N)
		c[tid] = a[tid] + b[tid];
}

int main(void)
{
	int a[N], b[N], c[N];
	int *dev_a, *dev_b, *dev_c;

	//GPU memory allocation
	//cudaMalloc((return type)&pointer, size in memory);
	cudaMalloc((void**)&dev_a, N * sizeof(int));
	cudaMalloc((void**)&dev_b, N * sizeof(int));
	cudaMalloc((void**)&dev_c, N * sizeof(int));

	//fill arrays a and b on the CPU with arbitrary values
	for (int x = 0; x < N; x++)
	{
		a[x] = -x;
		b[x] = x*x;
	}

	//Copy arrays to GPU
	//cudaMemcpy(to, from, size in memory, direction);
	cudaMemcpy(dev_a, a, N * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(dev_b, b, N * sizeof(int), cudaMemcpyHostToDevice);

	//N - the number of parallel blocks in which we would like the device to execute the kernel
	add<<<N, 1 >>>(dev_a, dev_b, dev_c);

	//Copy array c back from the GPU
	cudaMemcpy(c, dev_c, N * sizeof(int), cudaMemcpyDeviceToHost);

	for (int i = 0; i < N; i++)
	{
		printf("%d + %d = %d\n", a[i], b[i], c[i]);
	}

	cudaFree(dev_a);
	cudaFree(dev_b);
	cudaFree(dev_c);

	getchar();
	return 0;
	//page 59 - 80 in pdf
}