
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

       /* Create an m-by-n mxArray; you will copy existing data into it */
    plhs[0] = (void* ) grabber;
    
   int x = MdigInquire(MilDigitizer, M_SIZE_X, M_NULL);
   int y = MdigInquire(MilDigitizer, M_SIZE_Y, M_NULL);
   /* Monoshot grab. */

   long imsz = x*y;
   unsigned short* buf = new unsigned short[imsz + 1];
//  return (unsigned short*) buf;    
    
    pointer = mxGetPr(buf[0]);
    plhs[1] = (unsigned short *)mxGetData(pointer);

    return;
}

