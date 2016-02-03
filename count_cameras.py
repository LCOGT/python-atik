import atik
import datetime as dt
import time

number_of_cameras = atik.numberOfCameras()

print 'Found {} cameras.'.format(number_of_cameras)

if number_of_cameras:
    camera = atik.getCamera(0)
    name = camera.getName()
    print name

    open = camera.open()
    print open

    capabilities = camera.getCapabilities()
    print list(enumerate(capabilities))

    pixelCountX = capabilities[8]
    pixelCountY = capabilities[9]

    width  = camera.imageWidth(pixelCountX, 1)
    height = camera.imageHeight(pixelCountY, 1)

    print 'Width = {}, Height = {}'.format(width, height)

    camera.startExposure(False)
    time.sleep(2)
    start = dt.datetime.utcnow()
    success = camera.readCCD(0, 0, pixelCountX, pixelCountY, 1, 1)
    time.sleep(2)
    end = dt.datetime.utcnow()
    print 'Camera readout {}'.format(success)
    print 'Duration {}s'.format((end - start).total_seconds())

    success, data = camera.getImage(width*height)
    print data
    print 'Mean = {}'.format(data.mean())

    print camera.getTemperatureSensorStatus(0)

    close = camera.close()
    print close
