#include <cuda.h>
#include <cuda_runtime.h>
#include <iostream>
#include <device_launch_parameters.h>

__global__ void W4W(int *w, int *out)
{
	int tid = blockIdx.x;
	int weight[sizeof(w)/sizeof(int)];
		char c1 = (w[tid]/100)+48;
		char c2 = ((w[tid]%100)/10)+48;
		char c3 = w[tid]%10+48;
		weight[tid]=(w[tid]/100)+ ((w[tid] % 100) / 10) + w[tid] % 10;
		printf("%d, %c, %c, %c, %d\n", w[tid], c1, c2, c3, weight[tid]);
		if (tid != 0)
		{
			if (weight[tid - 1] > weight[tid])
			{
				int x,y;
				x=w[tid -1];y=w[tid];//collapsed to reserve pixels
				out[tid -1]=y;out[tid]=x;
				x=0;y=0;
				x=weight[tid -1];y=weight[tid];
				weight[tid -1]=y;weight[tid]=x;
			}
			if (weight[tid - 1] = weight[tid])
			{

			}
		}
}

int main()
{
	//weight is the sum of the numbers
	//like numbers differentiated by string
	const int size = 9;
	int weights[size] = {56, 65, 74, 100, 99, 68, 86, 180, 90};
	int *out, *w, output[size];
	cudaMalloc((void**)&w, size * sizeof(int));
	cudaMalloc((void**)&out, size * sizeof(int));
	cudaMemcpy(w, &weights, size * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(out, &output, size * sizeof(int), cudaMemcpyHostToDevice);
	W4W<<<size,1>>>(w, out);
	cudaMemcpy(&output, out, size * sizeof(int), cudaMemcpyDeviceToHost);
	for(int i=0;i<size;i++){printf("%d\n",output[i]); }
	cudaFree(out);
	cudaFree(w);
	return 0;
}