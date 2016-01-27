%module atik
%{
#include <atikccdusb.h>
%}

%include "typemaps.i";

class AtikCamera {
  public:
    static int list(AtikCamera **cameras, int max);
    virtual const char *getName() = 0;
    virtual bool open() = 0;
    virtual void close() = 0;
    virtual bool setParam(PARAM_TYPE code, long value) = 0;
    virtual bool getCapabilities(const char **name, CAMERA_TYPE *type, bool *hasShutter, bool* hasGuidePort, bool* has8BitMode, bool* hasFilterWheel, unsigned *lineCount, unsigned* pixelCountX, unsigned* pixelCountY, double* pixelSizeX, double* pixelSizeY, unsigned* maxBinX, unsigned* maxBinY, unsigned *tempSensorCount, COOLER_TYPE* cooler) = 0;
    virtual bool getTemperatureSensorStatus(unsigned sensor, float *currentTemp) = 0;
    virtual bool getCoolingStatus(COOLING_STATE *state, float* targetTemp, float *power) = 0;
    virtual bool setCooling(float targetTemp) = 0;
    virtual bool initiateWarmUp() = 0;
    virtual bool getFilterWheelStatus(unsigned *filterCount, bool *moving, unsigned *current, unsigned *target) = 0;
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
    virtual bool getGPIO(unsigned short *mask) = 0;
    virtual bool setGPIO(unsigned short mask) = 0;
    virtual bool getGain(int *gain, int* offset) = 0;
    virtual bool setGain(int gain, int offset) = 0;
    virtual unsigned delay(double delay) = 0;
    virtual unsigned imageWidth(unsigned width, unsigned binX) = 0;
    virtual unsigned imageHeight(unsigned height, unsigned binY) = 0;
    virtual ~AtikCamera() { };
};

%inline
%{

#define MAX_CAMERA_COUNT 16

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
