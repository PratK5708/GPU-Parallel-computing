// src/main.cu
#include <iostream>
#include <cuda_runtime.h>

// CUDA kernel to add two arrays
__global__ void add_arrays(int *a, int *b, int *result, int n) {
    int index = threadIdx.x + blockIdx.x * blockDim.x;
    if (index < n) {
        result[index] = a[index] + b[index];
    }
}

int main() {
    int n = 1000; // Size of the arrays
    int *a, *b, *result;
    int *d_a, *d_b, *d_result;

    // Allocate host memory
    a = new int[n];
    b = new int[n];
    result = new int[n];

    // Initialize the arrays
    for (int i = 0; i < n; ++i) {
        a[i] = i;
        b[i] = i * 2;
    }

    // Allocate device memory
    cudaMalloc((void**)&d_a, n * sizeof(int));
    cudaMalloc((void**)&d_b, n * sizeof(int));
    cudaMalloc((void**)&d_result, n * sizeof(int));

    // Copy data from host to device
    cudaMemcpy(d_a, a, n * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, n * sizeof(int), cudaMemcpyHostToDevice);

    // Launch kernel with enough blocks and threads
    int threadsPerBlock = 256;
    int blocksPerGrid = (n + threadsPerBlock - 1) / threadsPerBlock;
    add_arrays<<<blocksPerGrid, threadsPerBlock>>>(d_a, d_b, d_result, n);

    // Copy result from device to host
    cudaMemcpy(result, d_result, n * sizeof(int), cudaMemcpyDeviceToHost);

    // Print a few results
    for (int i = 0; i < 10; ++i) {
        std::cout << "Result[" << i << "] = " << result[i] << std::endl;
    }

    // Free memory
    delete[] a;
    delete[] b;
    delete[] result;
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_result);

    return 0;
}
