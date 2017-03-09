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
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) 
   {
   MIL_ID MilApplication;
   MIL_ID MilSystem;
   MIL_ID MilDigitizer;
   MIL_ID MilDisplay;
   mwSize *dims;
   int TFRAMES = 3;

   /* Allocate application and system. */
   MappAlloc(M_NULL, M_DEFAULT, &MilApplication);
   MsysAlloc(M_DEFAULT, M_SYSTEM_DEFAULT, M_DEFAULT, M_DEFAULT, &MilSystem);

   /* Allocate digitizers using the default DCF. */
   MdigAlloc(MilSystem, 0, MIL_TEXT("M_DEFAULT"), M_DEFAULT, &MilDigitizer);

   /* Allocate displays. */
   MdispAlloc(MilSystem, M_DEV0, MIL_TEXT("M_DEFAULT"), M_DEFAULT, &MilDisplay);
   MdigControlFeature(MilDigitizer, M_FEATURE_VALUE_AS_STRING, MIL_TEXT("LinkConfig"), M_TYPE_ENUMERATION, MIL_TEXT("x2_CXP_6"));
	int xx,yy, zz;
    xx = MdigInquire(MilDigitizer, M_SIZE_X, M_NULL);
	yy = MdigInquire(MilDigitizer, M_SIZE_Y, M_NULL);
    zz = TFRAMES;

    dims =  new mwSize[3];
    dims[0] = xx; dims[1] = yy; dims[2] = zz; 
    
//    plhs[0] = mxCreateDoubleMatrix(3, 1, mxREAL);
    plhs[0] = mxCreateNumericMatrix(3, 1, mxUINT16_CLASS, mxREAL);
    /* Point mxArray to dynamicData */
    mxSetData(plhs[0], dims);
    mxSetM(plhs[0], 3);
    mxSetN(plhs[0], 1);    
       
   MdispFree(MilDisplay);
   MdigFree(MilDigitizer);
   MsysFree(MilSystem);
   MappFree(MilApplication);
   }
