#include "mex.h"
#include <math.h>

#define OUT plhs[0]
void py_dist(double *a, mwSize xDim, mwSize yDim, double *output) {
    int x, y;
    for(x = 0; x<=xDim; ++x)
        for (y = 0; y<=yDim; ++y)
        { double t = *a++;
          *output++ = t*t;
        }
}

void mexFunction(int nlhs, mxArray* plhs[], int nrhs, const mxArray* prhs[]) {
    double *output, *a;
    mwSize xDim, yDim;
    
    xDim = mxGetM(prhs[0]);
    yDim = mxGetN(prhs[0]);
    /*do the matlab stuff*/
    mexPrintf("x Dimensions = %u.\n", xDim);
    mexPrintf("y Dimensions = %u.\n", yDim);
    OUT = mxCreateDoubleMatrix(xDim, yDim, mxREAL); // mxArray is transpose of c matrix
    output = mxGetPr(OUT);
    a = mxGetPr(prhs[0]);
    py_dist(a, xDim, yDim, output);
}