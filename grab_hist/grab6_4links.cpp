// mex -I'C:\Program Files\Matrox Imaging\MIL\Include' -L'C:\Program Files\Matrox Imaging\MIL\LIB' grab4.cpp -lmil -lmilim
#include "mex.h"
#include <mil.h> 
#include "matrix.h"
#define BUFFERING_SIZE_MAX  4  // 2 is minimum

void* AllocMilSystem(void);
unsigned short* AllocBuf_16b(void* grabsetup);
unsigned short* GrabImage(unsigned short* buf, void* grabsetup, int nBuf);
int FreeGrabber( void* grabsetup );

struct MilSetup
{
   	MIL_ID MilApplication;  /* Application identifier.  */
    MIL_ID MilSystem;       /* System identifier.       */
    MIL_ID MilDisplay;      /* Display identifier.      */
    MIL_ID MilDigitizer;    /* Digitizer identifier.    */ 
	MIL_ID MilGrabBufferList[BUFFERING_SIZE_MAX];        /* Image buffer identifier. */
	int nCols;        /* Image buffer number of columns. */
	int nRows;        /* Image buffer number of rows. */
    int nFrames;      /* Image buffer number of frames. */
};

// Usage:
// grab5(0) - allocation and initialization of MilSystem
// grab5(-1) - closing MilSytem milSystem
// grab5 - grabbing single frame

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) 
{
   static void* grabsetup;
   static  int imNum;
   mwSize *dims;
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
          mexPrintf("\n MilSystem released, pointer is %04x .\n", grabsetup);
       }
       return;
   } else if ((nrhs == 0) && (grabsetup != NULL) ) {
       mexPrintf("Capture Image #%d.\n", imNum);
//       mexPrintf("\n MilSystem grab image # .\n");
       MilSetup* grabber = (MilSetup*) grabsetup;
       int x = grabber->nCols;
       int y = grabber->nRows;
       int z = grabber->nFrames;
       long imsz = x*y;
       long bufsz = imsz*z;
       
       unsigned short* buf = AllocBuf_16b(grabsetup);
       UINT16_T *dynamicData;
       mwSize index;
       

        /* Create a local array and load data */
       dynamicData = (UINT16_T *) mxCalloc(bufsz+1, sizeof(UINT16_T));
       for ( int jj = 0; jj < 1; jj++ ) {  // should be jj < 1; here, but this crashes for some reason
    //       GrabImage( &buf[imsz*jj], grabsetup, jj);
           GrabImage( buf, grabsetup, jj);
           for ( index = 0; index < imsz; index++ ) {
               dynamicData[index+imsz*jj] = buf[index+imsz*jj];
           }
       }
       dims[0] = x;  
       dims[1] = y;
       dims[2] = z; 
        /* Create a 0-by-0 mxArray; you will allocate the memory dynamically */
       plhs[0] = mxCreateNumericArray(3, dims, mxUINT16_CLASS, mxREAL);  // 3 array
    //    plhs[0] = mxCreateNumericMatrix(0, 0, mxDOUBLE_CLASS, mxREAL);

        /* Point mxArray to dynamicData */
       mxSetData(plhs[0], dynamicData);
//       mxSetM(plhs[0], x);
//       mxSetN(plhs[0], y);    

       delete buf;
       imNum++;
       return ;
   }
}

void* AllocMilSystem( void )
{
   int TFRAMES = 3;
   MIL_INT m, BufferLocation = M_NULL;
   MIL_ID MilGrabBufferList[BUFFERING_SIZE_MAX];  // Image buffers identifier. 

   MilSetup* grabber = new MilSetup;

   /* Allocate application and system. */
//   MappAlloc(M_NULL, M_DEFAULT, &grabber->MilApplication);
//   MsysAlloc(M_DEFAULT, M_SYSTEM_DEFAULT, M_DEFAULT, M_DEFAULT, &grabber->MilSystem);
   
   MappAllocDefault(M_DEFAULT, &grabber->MilApplication, &grabber->MilSystem, &grabber->MilDisplay, &grabber->MilDigitizer,  M_NULL);
  /* Allocate digitizers using the default DCF. */
//   MdigAlloc(MilSystem, 0, MIL_TEXT("M_DEFAULT"), M_DEFAULT, &grabber->MilDigitizer);
   MdigControlFeature(grabber->MilDigitizer, M_FEATURE_VALUE_AS_STRING, MIL_TEXT("LinkConfig"), M_TYPE_ENUMERATION, MIL_TEXT("x4_CXP_6"));
	/* Put digitizer in asynchronous mode */
   MdigControl(grabber->MilDigitizer, M_GRAB_MODE, M_ASYNCHRONOUS);  // check if it works
       
   MIL_ID MilSystem = (MIL_ID) grabber->MilSystem;
   MIL_ID MilDigitizer = (MIL_ID) grabber->MilDigitizer;


   /* Allocate the grab buffers for each digitizer and clear them. */
   MappControl(M_DEFAULT, M_ERROR, M_PRINT_DISABLE);
   
   int xx = MdigInquire(MilDigitizer, M_SIZE_X, &grabber->nCols);
   int yy = MdigInquire(MilDigitizer, M_SIZE_Y, &grabber->nRows);
   grabber->nFrames = TFRAMES;
   
    /* Init table. */
   for(m = 0; m < BUFFERING_SIZE_MAX; m++) {
          MilGrabBufferList[m] = M_NULL;
    }  
   
    //  Try to allocate a buffer. 
    for(m = M_NULL; m < BUFFERING_SIZE_MAX; m++)
      {
         MbufAlloc2d(MilSystem,     
                     xx, yy,
                     16L+M_UNSIGNED,
                     M_IMAGE+M_GRAB+BufferLocation,
            //       MdigInquire(MilDigitizer, M_TYPE, M_NULL),
		//		     M_IMAGE+M_GRAB+M_PROC+M_DISP+BufferLocation,
                     &MilGrabBufferList[m]);
//   MbufAlloc2d(MilSystem, xx,yy, 16L+M_UNSIGNED, M_IMAGE+M_GRAB, &MilImage);
         grabber->MilGrabBufferList[m] =  MilGrabBufferList[m];
   
         /* If allocation is successful, clear the buffer. */
         if (MilGrabBufferList[m])
         {
            MbufClear(MilGrabBufferList[m], 0xFF);
         }
         else break; /* Allocation failed, stop immediately. */
      }
   MappControl(M_DEFAULT, M_ERROR, M_PRINT_ENABLE);   
   

   return grabber;
}

unsigned short* AllocBuf_16b(void* grabsetup)
{
   MilSetup* grabber = (MilSetup*) grabsetup;
   MIL_ID MilDigitizer = (MIL_ID) grabber->MilDigitizer;

   int x = grabber->nCols;
   int y = grabber->nRows;
   int z = grabber->nFrames;
   /* Monoshot grab. */

  long bufsz = x*y*z;
  unsigned short* buf = new unsigned short[bufsz + 1];
  return (unsigned short*) buf;
}

unsigned short* GrabImage(unsigned short* buf, void* grabsetup, int nBuf)
{
   MIL_INT m;
   MilSetup* grabber = (MilSetup*) grabsetup;
   MIL_ID* MilGrabBufferList = grabber->MilGrabBufferList;
   MIL_ID MilDigitizer = (MIL_ID) grabber->MilDigitizer;
   int x = grabber->nCols;
   int y = grabber->nRows;
//   int z = grabber->nFrames;

//   for(m = M_NULL; m < z; m++)
//   {
//      MdigGrab(MilDigitizer, MilGrabBufferList[m]);
//   }
      MdigGrab(MilDigitizer, MilGrabBufferList[nBuf]);

   long imsz = x*y;
//   long bufsz = imsz*z;
   buf = new unsigned short[imsz + 1];
   MbufGet2d ( MilGrabBufferList[nBuf], 0,0,x,y, (void *) buf );

   return (unsigned short*) buf;
}

int FreeGrabber( void* grabsetup )
{
   MIL_INT m;
   MilSetup* grabber = (MilSetup*) grabsetup;
   MIL_ID MilApplication = grabber->MilApplication;
   MIL_ID MilSystem = grabber->MilSystem;
   MIL_ID MilDisplay = grabber->MilDisplay;
   MIL_ID MilDigitizer = grabber->MilDigitizer;

   int z = grabber->nFrames;

   /* Free defaults. */
//   MappFreeDefault(MilApplication, MilSystem, MilDisplay, MilDigitizer, MilImage);
   /* Free allocations. */
	for (m = 0; m < BUFFERING_SIZE_MAX; m++)
          {
          if(grabber->MilGrabBufferList[m])
             {
             MbufFree(grabber->MilGrabBufferList[m]);
             grabber->MilGrabBufferList[m] = M_NULL;
             }
          }
   
   
//   MbufFree(MilGrabBufferList[BUFFERING_SIZE_MAX]);
//   MilGrabBufferList[z] = M_NULL;
   MdispFree(MilDisplay);
   MdigFree(MilDigitizer);
   MsysFree(MilSystem);
   MappFree(MilApplication);
   return 0;
}