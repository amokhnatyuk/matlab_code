/********************************************************************************/
/* 
 * File name: MDigGrab.cpp 
 *
 * Synopsis:  This program demonstrates how to grab from a camera in
 *            continuous and monoshot mode.
 */
#include "mex.h"
#include <mil.h> 
#include "matrix.h"
#define ROWS 4112
#define COLUMNS 6160

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
};


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) 
{ 
   
   void* grabsetup = AllocMilSystem( );
   MilSetup* grabber = (MilSetup*) grabsetup;
   unsigned short* buf = AllocBuf_16b(grabsetup);

   buf = GrabImage( buf, grabsetup);

//   unsigned short* dp = NULL;   

   plhs[0] = mxCreateNumericMatrix(0, 0, mxUINT16_CLASS, mxREAL);
//   unsigned short* dp = (unsigned short*) mxGetData(plhs[0]);
//        *dpp = gpu_dp;

    /* Point mxArray to dynamicData */
//unsigned short* HST = (unsigned short*) mxGetPr(prhs[0]);   
   
//   mxSetData(plhs[0], buf);
   mxSetM(plhs[0], ROWS);
   mxSetN(plhs[0], COLUMNS);
   mxSetPr(plhs[0], (double*) buf);
//   plhs[0] = (mxArray*) buf;

//   dp = (unsigned short* ) buf;
   
/*   
unsigned short* gpu_dp = NULL;   
unsigned short** dpp;

plhs[0] = mxCreateNumericMatrix(1, 1, mxUINT16_CLASS, mxREAL);
        dpp = (unsigned short**) mxGetData(plhs[0]);
        *dpp = gpu_dp;

        gpu_dp = (unsigned short* ) buf;
//        mexLock();   
*/   
        
//  FreeGrabber( grabsetup );
//   delete buf;
   return ;
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

   int x = MdigInquire(MilDigitizer, M_SIZE_X, M_NULL);
   int y = MdigInquire(MilDigitizer, M_SIZE_Y, M_NULL);
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

   int x = MdigInquire(MilDigitizer, M_SIZE_X, M_NULL);
   int y = MdigInquire(MilDigitizer, M_SIZE_Y, M_NULL);
   long imsz = x*y;
   buf = new unsigned short[imsz + 1];
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
   MappFreeDefault(MilApplication, MilSystem, MilDisplay, MilDigitizer, MilImage);
//   MbufFree(MilImage);

   return 0;
}