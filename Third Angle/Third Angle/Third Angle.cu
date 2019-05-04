#include <cuda.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>
#include <iostream>

__global__ void ThirdAngle(int *a1, int *a2, int *a3)
{
	*a3 = (180-*a1-*a2);
}

int main()
{
	int *a3, *a2, *a1;
	int var1, var2, angle3;

	printf("Enter angle1\n");
	scanf("%d", &var1);
	printf("Enter angle2\n");
	scanf("%d", &var2);

	//Cuda goodness
	cudaMalloc((void**)&a3, sizeof(int));
	cudaMalloc((void**)&a2, sizeof(int));
	cudaMalloc((void**)&a1, sizeof(int));
	//Copy read vars to cuda vars
	cudaMemcpy(a1, &var1, sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(a2, &var2, sizeof(int), cudaMemcpyHostToDevice);
	ThirdAngle<<<1,1>>>(a1, a2, a3);//Run Cuda function on single block
	cudaMemcpy(&angle3, a3, sizeof(int), cudaMemcpyDeviceToHost);//Nab the angle back to angle3

	printf("Third Angle:\n %d", angle3);
	getchar();
	return 0;
}