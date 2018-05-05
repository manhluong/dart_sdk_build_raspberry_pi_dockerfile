## How to run

Simply build the docker image:
```
docker build .
```

By default it will build version 1.24.3.

To build another version, pass it as an argument:
```
docker build --build-arg dart_version=VERSION .
```

Bear in mind that I made this Dockerfile mainly to build 1.24.3 which is the last known version for me that is buildable for armv6.

## How to retrieve the built dart sdk

The created image will contain a zip file with the dart binaries. The zip file will be at the root (/) folder of the image.

To copy, create a container from the image and run cp:
```
docker images
docker create IMAGE_ID
docker cp CONTAINER_ID:/dart-sdk.zip .
```

Then unzip the archive and copy to your raspberry:
```
unzip dart-sdk.zip
scp -r dart-sdk user@raspberry.zero.ip:/path/remote/folder 
```

## How to test the sdk

In the `test` folder of this repo you can find some very simple dart file.

Remember to run `pub get` before run them with dart.

