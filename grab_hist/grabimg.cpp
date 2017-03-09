
/*=================================================================
 * grabimg.c - function used to gram image from Matrox fgramegrabber into an mxArray
 *
 * Create an mxArray and use mxGetPr to point to the starting
 * address of its real data. Fill mxArray with the contents 
 * of "data" and return it in plhs[0].
 *
 * Input:   none
 * Output:  mxArray
 *
 * Copyright December 2015 Altasens.
 * $Revision: 1.0.0 $ 
 *	
 *=================================================================*/

#include "mex.h"
#include <mil.h>
#define ROWS 4112
#define COLUMNS 6160


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
    unsigned short* pointer;          /* pointer to unsigned short data in new array */

    /* Check for proper number of arguments. */
    if ( nrhs != 0 ) {
        mexErrMsgIdAndTxt("MATLAB:grabimg:rhs","This function takes no input arguments.");
    }; 

   MIL_ID MilImage;        /* Image buffer identifier. */

    struct MilSetup
    {
        MIL_ID MilApplication;  /* Application identifier.  */
        MIL_ID MilSystem;       /* System identifier.       */
        MIL_ID MilDisplay;      /* Display identifier.      */
        MIL_ID MilDigitizer;    /* Digitizer identifier.    */ 
        MIL_ID MilImage;        /* Image buffer identifier. */
    };

   MilSetup* grabber = new MilSetup;
//	MilSetup* mgrabber = (MilSetup*) grabber;

   MappAllocDefault(M_DEFAULT, &grabber->MilApplication, &grabber->MilSystem, &grabber->MilDisplay, &grabber->MilDigitizer,  M_NULL);

	MIL_ID MilSystem = (MIL_ID) grabber->MilSystem;
	MIL_ID MilDigitizer = (MIL_ID) grabber->MilDigitizer;

   /* Allocate defaults. */
   MdigControlFeature(MilDigitizer, M_FEATURE_VALUE_AS_STRING, MIL_TEXT("LinkConfig"), M_TYPE_ENUMERATION, MIL_TEXT("x2_CXP_6"));

   int x = MdigInquire(MilDigitizer, M_SIZE_X, M_NULL);
   int y = MdigInquire(MilDigitizer, M_SIZE_Y, M_NULL);
   MbufAlloc2d(MilSystem, x,y, 16L+M_UNSIGNED, M_IMAGE+M_GRAB, &MilImage);
   grabber->MilImage = MilImage;

   long imsz = x*y;
   unsigned short* buf = new unsigned short[imsz + 1];
//  return (unsigned short*) buf;    
    
   /* Return pointers for initialized data */
//   plhs[0] = mxCreateNumericMatrix(0, 0, mxUINT16_CLASS, mxREAL);
   
   
void* gpu_dp = NULL;   
void** dpp;

plhs[0] = mxCreateNumericMatrix(1, 1, mxUINT64_CLASS, mxREAL);
        dpp = (void**) mxGetData(plhs[0]);
        *dpp = gpu_dp;

        gpu_dp = (void* ) grabber;
//        mexLock();


//        plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
//    double * outp = mxCreateNumericMatrix(1,1,mxINT64_CLASS,mxREAL);
//    mxArray* outp = mxCreateNumericMatrix(1,1,mxDOUBLE_CLASS,mxREAL);
//    outp = mxGetData(plhs[0]);
    
//    mxSetData(outp, (void* ) grabber);
//    plhs[0] = outp;

    /* Point mxArray to dynamicData */
//    mxSetData(plhs[0], buf);
//    mxSetM(plhs[0], ROWS);
//    mxSetN(plhs[0], COLUMNS);

//   mxSetData(plhs[0], grabber);
//   plhs[0] = grabber;
//   plhs[1] = (void*) buf;
//   pointer = mxGetPr(buf[0]);
//  plhs[1] = (unsigned short *)mxGetData(pointer);
//    **plhs[0]
    return;
}

