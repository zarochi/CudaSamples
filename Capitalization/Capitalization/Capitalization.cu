#include <cuda.h>
#include <cuda_runtime.h>
#include <iostream>
#include <device_launch_parameters.h>

#define N 32 //allocate space for vars; this will end up being the number of blocks to iterate over (we want this to be multiples of 32)

__global__ void Caps(char *c, int *b)
{
	int tid = blockIdx.x;
	if (tid < N)
	{
		if (b[tid] == 1)
		{
			int ascii = (int)c[tid];
			ascii -= 32;
			c[tid] = (char)ascii;
		}
	}
	
}

int main()
{
	int a[] = {1, 4, 6, 8, 11, 30};
	char String[N];
	int *b;
	char *c;
	
	//geneate 32 character string
	for(int i=0;i<N;i++){
		if (i % 5 == 0) { String[i] = 'a'; }
		if (i % 5 == 1) { String[i] = 'b'; }
		if (i % 5 == 2) { String[i] = 'c'; }
		if (i % 5 == 3) { String[i] = 'd'; }
		if (i % 5 == 4) { String[i] = 'e'; }
	}

	int temp[sizeof(String)/sizeof(char)];
	for (int i = 0; i < (sizeof(String)/sizeof(char)); i++)
	{
		temp[i]=0;
	}
	for (int i = 0; i < (sizeof(a)/sizeof(int)); i++)
	{
		int val=a[i];
		temp[val]=1;
	}

	cudaMalloc((void**)&c, N * sizeof(char));
	cudaMalloc((void**)&b, N * sizeof(int));
	cudaMemcpy(b, &temp, N * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(c, &String, N * sizeof(char), cudaMemcpyHostToDevice);

	Caps<<<N, 1>>>(c, b);

	cudaMemcpy(&String, c, N * sizeof(char), cudaMemcpyDeviceToHost);
	
	for (int i = 0; i < N; i++)
	{
		printf("%c", String[i]);
	}
	printf("\n");

	cudaFree(b);
	cudaFree(c);

	return 0;
}