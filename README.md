# docker-flow
Alpine linux based facebook flow docker containers.

# Troubleshooting

### If you experience some `Worked exited (code: 15) error on Linux host`

Then run the container like that:
```shell
docker run --rm -it -v $(pwd):/app -v /dev/shm:/dev/shm rezzza/docker-flow:latest flow check
```

If it still don't work, try with tmpfs:
```shell
docker run --rm -it -v $(pwd):/app --tmpfs=/tmp rezzza/docker-flow:latest flow check
```
