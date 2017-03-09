/********************************************************************************/
/* 
 * File name: MDigGrab.cpp 
 *
 * Synopsis:  This program demonstrates how to grab from a camera in
 *            continuous and monoshot mode.
 */
// mex -I'C:\Program Files\Matrox Imaging\MIL\Include' -L'C:\Program Files\Matrox Imaging\MIL\LIB' grab4.cpp -lmil -lmilim
#include "mex.h"
#include <mil.h> 
#include "matrix.h"

void* AllocMilSystem(void);
unsigned short* AllocBuf_16b(void* grabsetup);
unsigned short* GrabImage(unsigned short* buf, void* grabsetup);
int FreeGrabber( void* grabsetup );

struct MilSetup
{
   	MIL_ID MilApplication;  /* Application identifier.  */
    MIL_ID MilSystem;       /* System identifier.       */
    MIL_ID MilDisplay;      /* Display identifier.      */
    MIL_ID MilDigitizer;    /* Digitizer identifier.    */ 
	MIL_ID MilImage;        /* Image buffer identifier. */
	MIL_INT nCols;        /* Image buffer number of columns. */
	MIL_INT nRows;        /* Image buffer number of rows. */
};

// Usage:
// grab5(0) - allocation and initialization of MilSystem
// grab5(-1) - closing MilSytem milSystem
// grab5 - grabbing single frame

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) 
{
   static void* grabsetup;
   static  int imNum;
   static unsigned short* buf;
//   static UINT16_T sarr[2];
   if (nrhs == 1) {
       double *input;
       input = mxGetPr(prhs[0]);
       if ((*input == 0) && (grabsetup == NULL)) {  // if MilSystem is not allocated
          grabsetup = AllocMilSystem( );
          imNum = 0;
          mexPrintf("\n MilSystem has been allocated with static pointer %04x .\n", grabsetup);
       } else if ((*input == -1) && (grabsetup != NULL)) {  // if MilSystem is allocated them close it
          FreeGrabber( grabsetup );
          delete grabsetup;
          grabsetup = NULL;
//          delete sarr;
     //     free(buf);
          buf = NULL; 
          mexPrintf("\n MilSystem released, pointer is %04x .\n", grabsetup);
       }
       return;
   } else if ((nrhs == 0) && (grabsetup != NULL) ) {
       mexPrintf("Capture Image #%d.\n", imNum);
//       mexPrintf("\n MilSystem grab image # .\n");
       MilSetup* grabber = (MilSetup*) grabsetup;
       buf = AllocBuf_16b(grabsetup);
       UINT16_T *dynamicData;
       mwSize index;

       GrabImage( buf, grabsetup);
       int x = grabber->nCols;
       int y = grabber->nRows;
       long imsz = x*y;

        /* Create a local array and load data */
       dynamicData = (UINT16_T *) mxCalloc(imsz+1, sizeof(UINT16_T));
       for ( index = 0; index < imsz; index++ ) {
           dynamicData[index] = buf[index];
       }

        /* Create a 0-by-0 mxArray; you will allocate the memory dynamically */
       plhs[0] = mxCreateNumericMatrix(0, 0, mxUINT16_CLASS, mxREAL);
    //    plhs[0] = mxCreateNumericMatrix(0, 0, mxDOUBLE_CLASS, mxREAL);

        /* Point mxArray to dynamicData */
       mxSetData(plhs[0], dynamicData);
       mxSetM(plhs[0], x);
       mxSetN(plhs[0], y);    

       delete buf;
       imNum++;
       return ;
   }
}

void* AllocMilSystem( void )
{
	MIL_ID MilImage;        /* Image buffer identifier. */

   MilSetup* grabber = new MilSetup;
//	MilSetup* mgrabber = (MilSetup*) grabber;

   MappAllocDefault(M_DEFAULT, &grabber->MilApplication, &grabber->MilSystem, &grabber->MilDisplay, &grabber->MilDigitizer,  M_NULL);

	MIL_ID MilSystem = (MIL_ID) grabber->MilSystem;
	MIL_ID MilDigitizer = (MIL_ID) grabber->MilDigitizer;

   /* Allocate defaults. */
   MdigControlFeature(MilDigitizer, M_FEATURE_VALUE_AS_STRING, MIL_TEXT("LinkConfig"), M_TYPE_ENUMERATION, MIL_TEXT("x2_CXP_6"));

   int x = MdigInquire(MilDigitizer, M_SIZE_X, &grabber->nCols);
   int y = MdigInquire(MilDigitizer, M_SIZE_Y, &grabber->nRows);
   MbufAlloc2d(MilSystem, x,y, 16L+M_UNSIGNED, M_IMAGE+M_GRAB, &MilImage);
   grabber->MilImage = MilImage;

   return grabber;
}

unsigned short* AllocBuf_16b(void* grabsetup)
{
   MilSetup* grabber = (MilSetup*) grabsetup;
   MIL_ID MilDigitizer = (MIL_ID) grabber->MilDigitizer;

   int x = MdigInquire(MilDigitizer, M_SIZE_X, M_NULL);
   int y = MdigInquire(MilDigitizer, M_SIZE_Y, M_NULL);
   /* Monoshot grab. */

  long imsz = x*y;
  unsigned short* buf = new unsigned short[imsz + 1];
  return (unsigned short*) buf;
}

unsigned short* GrabImage(unsigned short* buf, void* grabsetup)
{
//   MIL_ID MilImage;        /* Image buffer identifier. */

   MilSetup* grabber = (MilSetup*) grabsetup;
   MIL_ID MilImage = (MIL_ID) grabber->MilImage;
   MIL_ID MilDigitizer = (MIL_ID) grabber->MilDigitizer;

   MdigGrab(MilDigitizer, MilImage);

   int x = grabber->nCols;
   int y = grabber->nRows;
   long imsz = x*y;
//   buf = new unsigned short[imsz + 1];
   MbufGet2d ( MilImage, 0,0,x,y, (void *) buf );

   return (unsigned short*) buf;
}

int FreeGrabber( void* grabsetup )
{
   MilSetup* grabber = (MilSetup*) grabsetup;
   MIL_ID MilApplication = grabber->MilApplication;
   MIL_ID MilSystem = grabber->MilSystem;
   MIL_ID MilDisplay = grabber->MilDisplay;
   MIL_ID MilDigitizer = grabber->MilDigitizer;
   MIL_ID MilImage =     grabber->MilImage;
   /* Free defaults. */
//   MappFreeDefault(MilApplication, MilSystem, MilDisplay, MilDigitizer, MilImage);
   /* Free allocations. */
   MbufFree(MilImage);
   MdispFree(MilDisplay);
   MdigFree(MilDigitizer);
   MsysFree(MilSystem);
   MappFree(MilApplication);
   return 0;
}