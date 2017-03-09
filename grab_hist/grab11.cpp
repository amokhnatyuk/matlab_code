/* Headers. */
#include <mil.h>
#include "mex.h"
#include "matrix.h"

/* Maximum number of images in the buffering grab queue of each digitizer.
   Generally, increasing the number of buffers prevents missing frames.
 */
#define BUFFERING_SIZE_MAX  30
#define DRAW_ANNOTATION M_NO

/* User's processing function prototype and hook parameter structure. */
MIL_INT MFTYPE ProcessingFunction(MIL_INT HookType, MIL_ID HookId, void* HookDataPtr);

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

   /* Allocate application and system. */
   MappAlloc(M_NULL, M_DEFAULT, &MilApplication);
   MsysAlloc(M_DEFAULT, M_SYSTEM_DEFAULT, M_DEFAULT, M_DEFAULT, &MilSystem);

   /* Allocate digitizers using the default DCF. */
   MdigAlloc(MilSystem, 0, MIL_TEXT("M_DEFAULT"), M_DEFAULT, &MilDigitizer);

   /* Allocate displays. */
   MdispAlloc(MilSystem, M_DEV0, MIL_TEXT("M_DEFAULT"), M_DEFAULT, &MilDisplay);
   MdigControlFeature(MilDigitizer, M_FEATURE_VALUE_AS_STRING, MIL_TEXT("LinkConfig"), M_TYPE_ENUMERATION, MIL_TEXT("x2_CXP_6"));
	int xx,yy, zz, z;
    xx = MdigInquire(MilDigitizer, M_SIZE_X, M_NULL);
	yy = MdigInquire(MilDigitizer, M_SIZE_Y, M_NULL);
    zz = TFRAMES;

   /* Allocate display buffers and clear them. */
    MbufAlloc2d(MilSystem,
               xx,yy,
               8+M_UNSIGNED, M_IMAGE+M_GRAB+M_PROC+M_DISP+BufferLocation,
               &MilImageDisp);
       MbufClear(MilImageDisp, 0);

   /* Allocate the grab buffers for each digitizer and clear them. */
//    MappControl(M_DEFAULT, M_ERROR, M_PRINT_DISABLE);

    /* Init table. */
    for(m = 0; m < BUFFERING_SIZE_MAX; m++)
          MilGrabBufferList[m] = M_NULL;

    
    /* Try to allocate as many buffers as possible */
    for(m = M_NULL; m < BUFFERING_SIZE_MAX; m++)
    {
        MbufAlloc2d(MilSystem,   // Try to allocate a buffer. 
            xx,yy,
            MdigInquire(MilDigitizer, M_TYPE, M_NULL),
            M_IMAGE+M_GRAB+M_PROC+BufferLocation,
            &MilGrabBufferList[m]);

         /* If allocation is successful, clear the buffer. */
         if (MilGrabBufferList[m])
         {
            MbufClear(MilGrabBufferList[m], 0xFF);
            LastAllocatedM = m;     // Keep index in table, in case it is the last allocated buffer.
            MilGrabBufferListSize++;  // If allocation worked, increase the number of buffers
         }
         else break; // Allocation failed, stop immediately. 
      }
//   MappControl(M_DEFAULT, M_ERROR, M_PRINT_ENABLE);

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

   // Display the target image. 
   MdispSelect(MilDisplay, MilImageDisp);
   // Start the processing. The processing function is called for every grabbed frame. 
   MdigProcess(MilDigitizer, MilGrabBufferList, MilGrabBufferListSize,
                             M_SEQUENCE,  //       M_START, 
                             M_DEFAULT, ProcessingFunction, M_NULL);


   // NOTE: Now display the image 
       for (m = 0; m < BUFFERING_SIZE_MAX; m++)   
       {
          if(MilGrabBufferList[m])
             {
		      MbufCopy(MilGrabBufferList[m], MilImageDisp);
             }
       }
       /* Print statistics. */
       MdigInquire(MilDigitizer, M_PROCESS_FRAME_COUNT,  &ProcessFrameCount);
       MdigInquire(MilDigitizer, M_PROCESS_FRAME_RATE,   &ProcessFrameRate);
//       MosPrintf(MIL_TEXT("Processing #%ld: %ld frames grabbed at %.2f frames/sec ")
//                 MIL_TEXT("(%.1f ms/frame).\n"), n+1, ProcessFrameCount, ProcessFrameRate,
//                 1000.0/ProcessFrameRate);


    dims =  new mwSize[3];
    dims[0] = zz; dims[1] = xx; dims[2] = yy; 
    long imsz = xx*yy;
    long bufsz = imsz*zz;
   
    /* Create a local array and load data */
//    dynamicData = (UINT16_T *) mxCalloc(imsz+1, sizeof(UINT16_T));
/*    
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
    // Create a 0-by-0 mxArray; you will allocate the memory dynamically 
    plhs[0] = mxCreateNumericArray(3, dims, mxUINT16_CLASS, mxREAL);  // 3 array

*/
    UINT16_T * dynamicData = (UINT16_T *) mxCalloc(bufsz, sizeof(UINT16_T ));
    
    int k=0;
    for (z = 0; z < zz; z++) {
        buf = new unsigned short[imsz+1];
        MbufGet2d ( MilGrabBufferList[z], 0,0,xx,yy, (void *) buf );
        for (int x = 0; x < xx; x++) {
        for (int y = 0; y < yy; y++) {
            k = imsz*z + xx*y +x;
//            dynamicData[z][j] = ((UINT16_T *) buf[z])[j];
            dynamicData[k] = (UINT16_T) buf[xx*y +x];
        }
        }
        free(buf);
    }    

    plhs[0] = mxCreateNumericMatrix(0, 0, mxUINT16_CLASS, mxREAL);
    /* Point mxArray to dynamicData */
    mxSetData(plhs[0], dynamicData);
    mxSetM(plhs[0], imsz);
    mxSetN(plhs[0], zz);    

//    plhs[1] = mxCreateNumericMatrix(0, 0, mxUINT16_CLASS, mxREAL);
    /* Point mxArray to dynamicData */
//    mxSetData(plhs[1], dims);
//    mxSetM(plhs[1], 3);
//    mxSetN(plhs[1], 1);    
    
    /* Free the grab buffers and MIL objects. */
//    MappControl(M_DEFAULT, M_ERROR, M_PRINT_DISABLE);
   for (m = 0; m < BUFFERING_SIZE_MAX; m++)
      {
      if(MilGrabBufferList[m])
         {
         MbufFree(MilGrabBufferList[m]);
         MilGrabBufferList[m] = 0;
         }
      }
    
   // Free buffers. 
//   for ( z = 0; z < zz; z++ ) {
//        free(dynamicData[z]);
//   }
//   free(buf);
    
    
   MbufFree(MilImageDisp);
   MdispFree(MilDisplay);
   MdigFree(MilDigitizer);
   MsysFree(MilSystem);
   MappFree(MilApplication);
   }

/* Processing thread(s) function: */
/* ---------------------------------------------------------------- */
#define STRING_LENGTH_MAX  20
#define STRING_POS_X       20
#define STRING_POS_Y       20

MIL_INT MFTYPE ProcessingFunction(MIL_INT HookType, MIL_ID HookId, void* HookDataPtr)
   {
/*
   HookDataStruct *UserHookDataPtr = (HookDataStruct *)HookDataPtr;
   MIL_ID ModifiedBufferId;
   MIL_TEXT_CHAR Text[STRING_LENGTH_MAX]= {MIL_TEXT('\0'),};

   // Retrieve the MIL_ID of the grabbed buffer. 
   MdigGetHookInfo(HookId, M_MODIFIED_BUFFER+M_BUFFER_ID, &ModifiedBufferId);

   // Increase the frame count. 
   UserHookDataPtr->ProcessedImageCount++;

   // Draw the frame count (if enabled). 
   if (DRAW_ANNOTATION)
      {
      MosSprintf(Text, STRING_LENGTH_MAX, MIL_TEXT("%ld"),
                 UserHookDataPtr->ProcessedImageCount);
      MgraText(M_DEFAULT, ModifiedBufferId, STRING_POS_X, STRING_POS_Y, Text);
      }

   // Perform the processing and update the display. 
   MimArith(ModifiedBufferId, M_NULL, UserHookDataPtr->MilImageDisp, M_NOT);
*/
   return 0;
   }
