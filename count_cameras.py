import atik

number_of_cameras = atik.numberOfCameras()

print 'Found {} cameras.'.format(number_of_cameras)

if number_of_cameras:
    camera = atik.getCamera(0)
    name = camera.getName()
    print name

    open = camera.open()
    print open

    capabilities = camera.getCapabilities()

    close = camera.close()
    print close
