FROM amazonlinux:2

# Install development tools and dependencies
RUN yum update -y && \
    yum groupinstall -y "Development Tools" && \
    yum install -y \
    cmake \
    git \
    gcc-c++ \
    make \
    lapack-devel \
    blas-devel \
    && yum clean all

# Install .NET 6.0 SDK
RUN rpm -Uvh https://packages.microsoft.com/config/centos/7/packages-microsoft-prod.rpm && \
    yum install -y dotnet-sdk-6.0

# Set up working directory
WORKDIR /app

# Copy the source code
COPY . .

# Build G2O C++ library
WORKDIR /app/External
RUN cmake -B build -DCMAKE_BUILD_TYPE=Release && \
    cmake --build build --config Release

# Build .NET solution
WORKDIR /app
RUN dotnet build G2O.sln -c net6-release -p:Platform=x64

# Run the tests
CMD ["dotnet", "test", "Fugro.G2O.Test/Fugro.G2O.Test.csproj", "-c", "net6-release", "-p:Platform=x64"] 