/* Headers. */
#include "mex.h"
#include <mil.h> 
#include "matrix.h"

/* Maximum number of images in the buffering grab queue of each digitizer.
   Generally, increasing the number of buffers prevents missing frames.
 */
#define BUFFERING_SIZE_MAX  20  // 2 is minimum

/* Draw annotation in the Grab image buffers. This can increase CPU
   usage significantly. This is especially true for on-board buffers.
 */
#define DRAW_ANNOTATION M_NO


/* Main function: */
/* -------------- */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) 
   {
   MIL_ID MilApplication;
   MIL_ID MilSystem;
   MIL_ID MilDigitizer;
   MIL_ID MilDisplay;
   MIL_ID MilImageDisp;
   MIL_ID MilGrabBufferList[BUFFERING_SIZE_MAX];
   MIL_INT m, BufferLocation = M_NULL;
   MIL_INT LastAllocatedM = M_NULL;
   MIL_INT MilGrabBufferListSize = M_NULL;
   MIL_INT ProcessFrameCount;
   double ProcessFrameRate;
   mwSize *dims;
   int TFRAMES = 3;
   unsigned short* buf;

  // MdigControlFeature(MilDigitizer, M_FEATURE_VALUE_AS_STRING, MIL_TEXT("LinkConfig"), M_TYPE_ENUMERATION, MIL_TEXT("x2_CXP_6"));
       /* Allocate the grab buffers for each digitizer and clear them. */

   /* Allocate application and system. */
   MappAlloc(M_NULL, M_DEFAULT, &MilApplication);
   MsysAlloc(M_DEFAULT, M_SYSTEM_DEFAULT, M_DEFAULT, M_DEFAULT, &MilSystem);

   /* Allocate digitizers using the default DCF. */
       MdigAlloc(MilSystem, 0, MIL_TEXT("M_DEFAULT"), M_DEFAULT, &MilDigitizer);
	   MdigControlFeature(MilDigitizer, M_FEATURE_VALUE_AS_STRING, MIL_TEXT("LinkConfig"), M_TYPE_ENUMERATION, MIL_TEXT("x2_CXP_6"));
	/* Put digitizer in asynchronous mode */
	   MdigControl(MilDigitizer, M_GRAB_MODE, M_ASYNCHRONOUS);  // check if it works
   /* Allocate displays. */
       MdispAlloc(MilSystem, M_DEV0, MIL_TEXT("M_DEFAULT"), M_DEFAULT, &MilDisplay);

   /* Allocate display buffers and clear them. */
    MbufAlloc2d(MilSystem,
                   MdigInquire(MilDigitizer, M_SIZE_X, M_NULL),
                   MdigInquire(MilDigitizer, M_SIZE_Y, M_NULL),
                   8+M_UNSIGNED, M_IMAGE+M_GRAB+M_PROC+M_DISP+BufferLocation,
                   &MilImageDisp);
    MbufClear(MilImageDisp, 0);

   /* Allocate the grab buffers for each digitizer and clear them. */
    MappControl(M_DEFAULT, M_ERROR, M_PRINT_DISABLE);

    /* Init table. */
    for(m = 0; m < BUFFERING_SIZE_MAX; m++)
          MilGrabBufferList[m] = M_NULL;

	int xx,yy, zz, z;
    xx = MdigInquire(MilDigitizer, M_SIZE_X, M_NULL);
	yy = MdigInquire(MilDigitizer, M_SIZE_Y, M_NULL);
    zz = TFRAMES;
    /* Try to allocate as many buffers as possible */
    for(m = M_NULL; m < BUFFERING_SIZE_MAX; m++)
    {
         /* Try to allocate a buffer. */
         MbufAlloc2d(MilSystem,
                     xx, yy,
                     MdigInquire(MilDigitizer, M_TYPE, M_NULL),
                     M_IMAGE+M_GRAB+M_PROC+BufferLocation,
		//		     M_IMAGE+M_GRAB+M_PROC+M_DISP+BufferLocation,
                     &MilGrabBufferList[m]);

         
         if (MilGrabBufferList[m]) // If allocation is successful, clear the buffer. 
         {
            MbufClear(MilGrabBufferList[m], 0xFF);
            LastAllocatedM = m;  // Keep index in table, in case it is the last allocated buffer. 
			MilGrabBufferListSize++;  // If allocation worked, increase the number of buffers
         }
         else   break; // Allocation failed, stop immediately. 
    }
   MappControl(M_DEFAULT, M_ERROR, M_PRINT_ENABLE);

   /* Free the last allocated buffer to leave space for possible temporary buffer. */
   MbufFree(MilGrabBufferList[LastAllocatedM]);
   MilGrabBufferList[LastAllocatedM] = M_NULL;

   /* If other digitizers have a buffer allocated at same index, delete them for symmetry. */
   if(MilGrabBufferList[LastAllocatedM])
   {
       MbufFree(MilGrabBufferList[LastAllocatedM]);
       MilGrabBufferList[LastAllocatedM] = M_NULL;
   }
   MilGrabBufferListSize--;
//   mexPrintf("\n\txx=%d; yy=%d; zz=%d ", xx,yy,zz);

   dims =  new mwSize[3];
   dims[0] = zz; dims[1] = xx; dims[2] = yy; 
    long imsz = xx*yy;
    long bufsz = imsz*zz;
   /* Start processing jobs. */
   for(m = M_NULL; m < zz; m++)
      {
	   MdigGrab(MilDigitizer, MilGrabBufferList[m]); 
 //      MbufGet2d ( MilGrabBufferList[m], 0,0,xx,yy, (void *) buf[m] );
      }

    /* Create a local array and load data */
//    dynamicData = (UINT16_T *) mxCalloc(imsz+1, sizeof(UINT16_T));
    UINT16_T ** dynamicData = (UINT16_T **) mxCalloc(zz, sizeof(UINT16_T *));
    for ( z = 0; z < zz; z++ ) {
        dynamicData[z] = (UINT16_T *) mxCalloc(imsz, sizeof(UINT16_T ));
    }
    
    buf = new unsigned short[imsz+1];
    for (z = 0; z < zz; z++) {
        MbufGet2d ( MilGrabBufferList[z], 0,0,xx,yy, (void *) buf );
        for (long j = 0; j < imsz; j++) {
//            dynamicData[z][j] = ((UINT16_T *) buf[z])[j];
            dynamicData[z][j] = (UINT16_T) buf[j];
        }
    }    

    /* Create a 0-by-0 mxArray; you will allocate the memory dynamically */
    plhs[0] = mxCreateNumericArray(3, dims, mxUINT16_CLASS, mxREAL);  // 3 array

    /* Point mxArray to dynamicData */
    mxSetData(plhs[0], dynamicData);

    /* Free the grab buffers and MIL objects. */
    MappControl(M_DEFAULT, M_ERROR, M_PRINT_DISABLE);

	for (m = 0; m < BUFFERING_SIZE_MAX-1; m++)
    {
      if(MilGrabBufferList[m])
      {
         MbufFree(MilGrabBufferList[m]);
         MilGrabBufferList[m] = 0;
      }
   }
    
   MbufFree(MilImageDisp);
   MdispFree(MilDisplay);
   MdigFree(MilDigitizer);

   /* Free buffers. */
   MsysFree(MilSystem);
   MappFree(MilApplication);
   free(buf);
   }