/* Headers. */
#include "mex.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) 
   {
    unsigned short *dims;
    dims =  new unsigned short[3];
    dims[0] = 10; dims[1] = 20; dims[2] = 5; 
    
//    plhs[0] = mxCreateDoubleMatrix(3, 1, mxREAL);
    plhs[0] = mxCreateNumericMatrix(0, 0, mxUINT16_CLASS, mxREAL);
    /* Point mxArray to dynamicData */
    mxSetData(plhs[0], dims);
    mxSetM(plhs[0], 3);
    mxSetN(plhs[0], 1);    
       
   }
