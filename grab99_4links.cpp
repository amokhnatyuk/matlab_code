/********************************************************************************/
/* 
 * File name: grab56_4links.cpp 
 *
 * Synopsis:  This program demonstrates how to grab from a camera in
 *            continuous and monoshot mode.
 */
// mex -I'C:\Program Files\Matrox Imaging\MIL\Include' -L'C:\Program Files\Matrox Imaging\MIL\LIB' grab99_4links.cpp -lmil -lmilim
#include "mex.h"
#include <mil.h> 
#include "matrix.h"

#define BUFFERING_SIZE_MAX  30

void* AllocMilSystem(void);
unsigned short* AllocBuf_16b(void* grabsetup);
unsigned short* GrabImage(unsigned short* buf, void* grabsetup);
int FreeGrabber( void* grabsetup );
MIL_INT MFTYPE ProcessingFunction(MIL_INT HookType, MIL_ID HookId, void* HookDataPtr);

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
   static double FrameRate = 0;
   static double *FrameRatePtr = &FrameRate;
   
//   static UINT16_T sarr[2];
   if (nrhs == 1) {
       double *input;
       input = mxGetPr(prhs[0]);
       if ((*input == 0) && (grabsetup == NULL)) {  // if MilSystem is not allocated
          grabsetup = AllocMilSystem( );
          imNum = 0;
          mexPrintf(" MilSystem has been allocated with static pointer %04x .\n", grabsetup);
       } else if ((*input == -1) && (grabsetup != NULL)) {  // if MilSystem is allocated them close it
          FreeGrabber( grabsetup );
          delete grabsetup;
          grabsetup = NULL;
//          delete sarr;
//          free(buf);
          buf = NULL; 
          mexPrintf(" MilSystem released, pointer is %04x .\n", grabsetup);
       } else if ((*input == -2) && (grabsetup != NULL)) {  // if MilSystem is allocated them close it
          //Create mxArray data structures to hold the data
          //to be assigned for the structure.
          mxArray *mydouble,*mystring;
          double *dblptr;
          const char *fieldnames[2]; 
          
//          mexPrintf("Creating image variables.\n");
          mystring  = mxCreateString("nframes, width, heigth, frametime");
          mydouble  = mxCreateDoubleMatrix(1,4, mxREAL);  // 4 is dimension of array dblptr[i]
          dblptr    = mxGetPr(mydouble);
          
          MIL_ID MilDigitizer = (MIL_ID) ((MilSetup*) grabsetup)->MilDigitizer;

          dblptr[0] = (double) MdigInquire(MilDigitizer, M_PROCESS_FRAME_COUNT, M_NULL);  // nframes
          dblptr[1] = (double) MdigInquire(MilDigitizer, M_SIZE_X, M_NULL);  // width
          dblptr[2] = (double) MdigInquire(MilDigitizer, M_SIZE_Y, M_NULL);  // heigth
          MdigInquire(MilDigitizer, M_PROCESS_FRAME_RATE, &FrameRate);
//          mexPrintf("Frames captured with frame rate %.1f fps.\n", FrameRate);
          dblptr[3] = (double) FrameRate;  // framerate

          //Assign field names
          fieldnames[0] = (char*)mxMalloc(20);
          fieldnames[1] = (char*)mxMalloc(20);
          fieldnames[0] = "dblData";
          fieldnames[1] = "VarNames";
          //Allocate memory for the structure
          plhs[0] = mxCreateStructMatrix(1,1,2,fieldnames);
          //Deallocate memory for the fieldnames
//          mxFree( (void *) fieldnames[0] );  // matlab takes care of freeing memory
//          mxFree( (void *) fieldnames[1] );
          //Assign the field values
          mxSetFieldByNumber(plhs[0],0,0, mydouble);
          mxSetFieldByNumber(plhs[0],0,1, mystring);
          
       } else if ((*input > 0) && (grabsetup != NULL)) {  // if MilSystem is allocated them close it
           
//           MIL_ID MilImageDisp;
           MIL_ID MilGrabBufferList[BUFFERING_SIZE_MAX];
           MIL_INT m, BufferLocation = M_NULL;
           MIL_INT LastAllocatedM = M_NULL;
           MIL_INT MilGrabBufferListSize = M_NULL;
           MIL_INT ProcessFrameCount;
           mwSize *dims;
           unsigned short* buf;

           MilSetup* grabber = (MilSetup*) grabsetup;
           MIL_ID MilApplication = grabber->MilApplication;
           MIL_ID MilSystem = grabber->MilSystem;
           MIL_ID MilDisplay = grabber->MilDisplay;
           MIL_ID MilDigitizer = grabber->MilDigitizer;
           int xx = grabber->nCols;
           int yy = grabber->nRows;
           int zz = (int) *input;


           /* Allocate the grab buffers for each digitizer and clear them. */
           MappControl(M_DEFAULT, M_ERROR, M_PRINT_DISABLE);

            /* Init table. */
            for(m = 0; m < BUFFERING_SIZE_MAX; m++) {
                  MilGrabBufferList[m] = M_NULL;
            }

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

           // Start the processing. The processing function is called for every grabbed frame. 
           MdigProcess(MilDigitizer, MilGrabBufferList, MilGrabBufferListSize,
                                     M_SEQUENCE,  
                                     M_DEFAULT, ProcessingFunction, M_NULL);

               /* Print statistics. */
//               MdigInquire(MilDigitizer, M_PROCESS_FRAME_COUNT,  &ProcessFrameCount);
          MdigInquire(MilDigitizer, M_PROCESS_FRAME_RATE, &FrameRate);
          mexPrintf(" Frames captured with frame rate %.1f fps.\n", FrameRate);
          FrameRatePtr = &FrameRate;
        //     MappControl(M_DEFAULT, M_ERROR, M_PRINT_ENABLE);
        //     MosPrintf(MIL_TEXT("Processing #%ld: %ld frames grabbed at %.2f frames/sec ")
        //                 MIL_TEXT("(%.1f fps).\n"), n+1, ProcessFrameCount, *FrameRatePtr,
        //                 1000.0/(*FrameRatePtr));


            dims =  new mwSize[3];
            dims[0] = zz; dims[1] = xx; dims[2] = yy; 
            long imsz = xx*yy;
            long bufsz = imsz*zz;

            UINT16_T * dynamicData = (UINT16_T *) mxCalloc(bufsz, sizeof(UINT16_T ));

            int k=0;
            for (int z = 0; z < zz; z++) {
                buf = new unsigned short[imsz+1];
                MbufGet2d ( MilGrabBufferList[z], 0,0,xx,yy, (void *) buf );
                for (int x = 0; x < xx; x++) {
                for (int y = 0; y < yy; y++) {
                    k = imsz*z + xx*y +x;
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

            /* Free the grab buffers and MIL objects. */
           for (m = 0; m < BUFFERING_SIZE_MAX; m++)
              {
              if(MilGrabBufferList[m])
                 {
                 MbufFree(MilGrabBufferList[m]);
                 MilGrabBufferList[m] = 0;
                 }
              }
       }
   } else if ((nrhs == 0) && (grabsetup != NULL) ) {
       mexPrintf(" Capture Image #%d.\n", imNum);
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
   }
   return;
}

void* AllocMilSystem( void )
{
	MIL_ID MilImage;        /* Image buffer identifier. */

   MilSetup* grabber = new MilSetup;
//	MilSetup* mgrabber = (MilSetup*) grabber;
//	MilSetup* mgrabber = (MilSetup*) grabber;

////////////////////////////
   /* Allocate a system for a Matrox Morphis board. Use a different */
   /* value or "M_DEFAULT" for other types of systems.              */
   MappAlloc(M_DEFAULT, &grabber->MilApplication);
    
//   MsysAlloc(M_DEFAULT, MIL_TEXT("M_DEFAULT"), M_DEFAULT, M_DEFAULT, &grabber->MilSystem);
   MsysAlloc(M_DEFAULT, M_SYSTEM_RADIENTCXP, M_DEFAULT, M_DEFAULT, &grabber->MilSystem);
   MIL_ID MilSystem = (MIL_ID) grabber->MilSystem;
   MdispAlloc(MilSystem, M_DEFAULT, MIL_TEXT("M_DEFAULT"), M_WINDOWED, &grabber->MilDisplay);

   /* Allocate a digitizer for RS170 camera. Use a different */ 
   /* value or "M_DEFAULT" for other types of cameras.       */
//   MdigAlloc(grabber->MilSystem, M_DEV0, MIL_TEXT("M_RS170"), M_DEFAULT, &grabber->MilDigitizer);
   MdigAlloc(MilSystem, M_DEV0, MIL_TEXT("C:\\project\\RaijinMat\\matlab\\dcf\\DCF1.dcf"), M_DEFAULT, &grabber->MilDigitizer);
   MIL_ID MilDigitizer = (MIL_ID) grabber->MilDigitizer;
///////////////////////

//   MappAllocDefault(M_DEFAULT, &grabber->MilApplication, &grabber->MilSystem, &grabber->MilDisplay, &grabber->MilDigitizer,  M_NULL);

//	MIL_ID MilSystem = (MIL_ID) grabber->MilSystem;
//	MIL_ID MilDigitizer = (MIL_ID) grabber->MilDigitizer;

   /* Allocate defaults. */
   MdigControlFeature(MilDigitizer, M_FEATURE_VALUE_AS_STRING, MIL_TEXT("LinkConfig"), M_TYPE_ENUMERATION, MIL_TEXT("x4_CXP_6"));

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

MIL_INT MFTYPE ProcessingFunction(MIL_INT HookType, MIL_ID HookId, void* HookDataPtr)
{
   return 0;
}
