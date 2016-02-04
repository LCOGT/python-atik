/*
* atik.i - SWIG interface file to the atik ccd sdk.
*
* This file defines the swig wrappings for the AtikCamera class
* defined in the atikccdusb.h file.
*
* The wrapped C++ method are converted from camel case to under score
* naming convention.
*
* To make the API 'pythonic', all output arguments are typemapped
* as OUTPUT, such that they are returned by the function call e.g.
*
* A C call to get the temperature status would be:-
*
*   int sensor = 0;
*   float temperature;
*   success = camera->getTemperatureSensorStatus(sensor, &temperature)
*
* The corresponding Python call would be:-
*
*    success, temperature = camera.get_temperature_sensor_status(0)
*
* Author:
*    Martin Norbury
*
* February 2016
*/

/* Module imports */
%module atik %{
   #define SWIG_FILE_WITH_INIT
   #include <atikccdusb.h>
%}

/* Module initialisation */
%init %{
   import_array();
%}

/* Swig imports */
%include "typemaps.i";
%include "numpy.i";

/* Swig configuration */
%feature("autodoc", 1);
%rename("%(utitle)s") "";

/* Output mapping (enumerations are mapped to integers) */
%apply int *OUTPUT {CAMERA_TYPE *type}
%apply int *OUTPUT {COOLER_TYPE *cooler}
%apply int *OUTPUT {COOLING_STATE *state}

/* Special mapping to handle char ** output argument */
%typemap(in, numinputs=0) char **name (char *temp) {
    $1 = &temp;
}
%typemap(argout) char **name {
    %append_output(PyString_FromString(*$1));
}

/* Mapping image data directly to numpy array */
%apply (unsigned short *ARGOUT_ARRAY1, int DIM1) {
   (unsigned short* imgBuf, unsigned imgSize)
}

/* Class and members to be wrapped (taken from atikccdusb.h) */
class AtikCamera {
  public:
    static int list(AtikCamera **cameras, int max);
    virtual const char *getName() = 0;
    virtual bool open() = 0;
    virtual void close() = 0;
    virtual bool setParam(PARAM_TYPE code, long value) = 0;
    virtual bool getCapabilities(const char **name, CAMERA_TYPE *type, bool *OUTPUT, bool* OUTPUT, bool* OUTPUT, bool* OUTPUT, unsigned *OUTPUT, unsigned* OUTPUT, unsigned* OUTPUT, double* OUTPUT, double* OUTPUT, unsigned* OUTPUT, unsigned* OUTPUT, unsigned *OUTPUT, COOLER_TYPE* cooler) = 0;
    virtual bool getTemperatureSensorStatus(unsigned sensor, float *OUTPUT) = 0;
    virtual bool getCoolingStatus(COOLING_STATE *state, float* OUTPUT, float *OUTPUT) = 0;
    virtual bool setCooling(float targetTemp) = 0;
    virtual bool initiateWarmUp() = 0;
    virtual bool getFilterWheelStatus(unsigned *OUTPUT, bool *OUTPUT, unsigned *OUTPUT, unsigned *OUTPUT) = 0;
    virtual bool setFilter(unsigned index) = 0;
    virtual bool setPreviewMode(bool useMode) = 0;
    virtual bool set8BitMode(bool useMode) = 0;
    virtual bool startExposure(bool amp) = 0;
    virtual bool abortExposure() = 0;
    virtual bool readCCD(unsigned startX, unsigned startY, unsigned sizeX, unsigned sizeY, unsigned binX, unsigned binY) = 0;
    virtual bool readCCD(unsigned startX, unsigned startY, unsigned sizeX, unsigned sizeY, unsigned binX, unsigned binY, double delay) = 0;
    virtual bool getImage(unsigned short* imgBuf, unsigned imgSize) = 0;
    virtual bool setShutter(bool open) = 0;
    virtual bool setGuideRelays(unsigned short mask) = 0;
    virtual bool setGPIODirection(unsigned short mask) = 0;
    virtual bool getGPIO(unsigned short *OUTPUT) = 0;
    virtual bool setGPIO(unsigned short mask) = 0;
    virtual bool getGain(int *OUTPUT, int* OUTPUT) = 0;
    virtual bool setGain(int gain, int offset) = 0;
    virtual unsigned delay(double delay) = 0;
    virtual unsigned imageWidth(unsigned width, unsigned binX) = 0;
    virtual unsigned imageHeight(unsigned height, unsigned binY) = 0;
    virtual ~AtikCamera() { };
};

/* Utility function for easier access to static function AtikCamera::list */
%inline %{
    #define MAX_CAMERA_COUNT 16

    bool AtikDebug = 0;

    AtikCamera *getCamera(const int deviceNumber) {
        AtikCamera *cameras = (AtikCamera*) alloca(sizeof(AtikCamera) * MAX_CAMERA_COUNT);
        const int cameraCount = AtikCamera::list(&cameras, MAX_CAMERA_COUNT);
        if(cameraCount < deviceNumber + 1) {
            return NULL;
        }
        return &cameras[deviceNumber];
    }

    int numberOfCameras() {
        AtikCamera *cameras = (AtikCamera*) alloca(sizeof(AtikCamera) * MAX_CAMERA_COUNT);
        return AtikCamera::list(&cameras, MAX_CAMERA_COUNT);
    }

%}
