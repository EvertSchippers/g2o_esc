# Build the Docker image
docker build -t g2o-aws-linux .

# Run the container and execute the tests
docker run --rm g2o-aws-linux 