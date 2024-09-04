# Notes

To build the tffold image, run the following command under the root directory of the project:

```bash
# run under the root directory of the project
docker build -t tfold:latest -f ./dockerize/tffold .
```

## Runtime

- mount data directory at `/tfold-src/data` (inside the container)