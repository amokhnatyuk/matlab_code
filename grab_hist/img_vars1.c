/* ==========================================================================
 * img_vars.c 
 * manipulating structure and cell array
 *
 * takes a image variables and returns a new structure (1x1)
 *==========================================================================*/

#include "mex.h"
void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
      mxArray *mydouble,*mystring;
      double *dblptr;
      int i;
      const char *fieldnames[2]; 
      if((nlhs!=1)||(nrhs!=0))
      {
      mexErrMsgTxt("One output and no input needed");
      return;
      }
      //Create mxArray data structures to hold the data
      //to be assigned for the structure.
      mystring  = mxCreateString("nframes, width, heigth, frametime");
      mydouble  = mxCreateDoubleMatrix(1,4, mxREAL);  // 4 is dimension of array dblptr[i]
      dblptr    = mxGetPr(mydouble);
      dblptr[0] = (double) 10;  // nframes
      dblptr[1] = (double) 20;  // width
      dblptr[2] = (double) 30;  // heigth
      dblptr[3] = (double) 40.5;  // frametime
      
      //Assign field names
      fieldnames[0] = (char*)mxMalloc(20);
      fieldnames[1] = (char*)mxMalloc(20);
      memcpy(fieldnames[0],"dblData",sizeof("dblData"));
      memcpy(fieldnames[1],"VarNames", sizeof("VarNames"));
      //Allocate memory for the structure
      plhs[0] = mxCreateStructMatrix(1,1,2,fieldnames);
      //Deallocate memory for the fieldnames
      mxFree( fieldnames[0] );
      mxFree( fieldnames[1] );
      //Assign the field values
      mxSetFieldByNumber(plhs[0],0,0, mydouble);
      mxSetFieldByNumber(plhs[0],0,1, mystring);
}