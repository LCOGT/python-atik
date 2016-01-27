%module atik
%{
#include <atikccdusb.h>
%}

%include "typemaps.i";
%include "cstring.i";

%ignore AtikCamera::list;

%apply bool *OUTPUT { bool *hasShutter, bool* hasGuidePort, bool* has8BitMode, bool* hasFilterWheel }
%apply unsigned *OUTPUT { unsigned *lineCount, unsigned* pixelCountX, unsigned* pixelCountY, unsigned* maxBinX, unsigned* maxBinY, unsigned *tempSensorCount }
%apply int *OUTPUT { CAMERA_TYPE* type, COOLER_TYPE* cooler }
%apply double *OUTPUT { double* pixelSizeX, double* pixelSizeY }
%cstring_output_allocate(char **name, free(*$1))

%include <atikccdusb.h>


AtikCamera *getCamera(const int deviceNumber);
int numberOfCameras();

%inline
%{

#define MAX_CAMERA_COUNT 16

bool AtikDebug = true;

AtikCamera *getCamera(const int deviceNumber)
{
    AtikCamera *cameras = (AtikCamera*) alloca(sizeof(AtikCamera) * MAX_CAMERA_COUNT);
    const int cameraCount = AtikCamera::list(&cameras, MAX_CAMERA_COUNT);
    if(cameraCount < deviceNumber + 1)
    {
        return NULL;
    }
    return &cameras[deviceNumber];
}

int numberOfCameras()
{
    AtikCamera *cameras = (AtikCamera*) alloca(sizeof(AtikCamera) * MAX_CAMERA_COUNT);
    return AtikCamera::list(&cameras, MAX_CAMERA_COUNT);
}
%}
