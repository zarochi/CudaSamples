#include <cuda.h>
#include <cuda_runtime.h>
#include <iostream>
#include <device_launch_parameters.h>

#define N 32

__global__ void Turtle(int *v1, int *v2, int *lead)
{
	if (*v1 >= *v2)
	{
		printf("%d, %d, %d", -1, -1,-1);
	}
	else
	{
		printf("%d, %d, %d\n", *v1, *v2, *lead);
		double _result = ((float)*lead)/(((float)*v2)-((float)*v1));
		int h = _result;
		int m = _result * 60 - h*60;
		int s = (_result * 3600) -m*60;
		printf("%.3f\n",_result);
		printf("%d, %d, %d\n", h, m, s);
		
	}
}

int main()
{
	int _v1 = 720;
	int _v2 = 850;
	int _lead = 70;
	int *v1, *v2, *lead;

	cudaMalloc((void**)&v1, sizeof(int));
	cudaMalloc((void**)&v2, sizeof(int));
	cudaMalloc((void**)&lead, sizeof(int));

	cudaMemcpy(v1, &_v1, sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(v2, &_v2, sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(lead, &_lead, sizeof(int), cudaMemcpyHostToDevice);

	Turtle<<<1, 1>>>(v1, v2, lead);

	cudaFree(v1);
	cudaFree(v2);
	cudaFree(lead);

	return 0;
}

//lead 70 feet
//how long to catch A
//hour min and sec return value
//-1, -1, -1 if v1>=v2