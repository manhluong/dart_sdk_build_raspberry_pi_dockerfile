## How to run

Simply build the docker image:
```
docker build .
```

By default it will build version 2.0.0-dev.55.0.

To build another version, pass it as an argument:
```
docker build --build-arg dart_version=VERSION .
```

It is recommended to set Docker to have 3 GB of memory, otherwise g++ will fail to compile.

## How to retrieve the built dart sdk

You can find a Docker image with the binaries inside, [here](https://hub.docker.com/r/luongbui/dart-vm_armv6/).

If you build the image yourself, the created image will contain a zip file with the dart binaries.
The zip file will be at the root (/) folder of the image.

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

