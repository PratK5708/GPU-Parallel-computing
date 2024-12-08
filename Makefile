CXX = nvcc
CXXFLAGS = -O3 -arch=sm_30

# Directories
SRC_DIR = src
BIN_DIR = bin
OBJ_DIR = build

# Executable name
EXEC = main

# Source files
SRCS = $(wildcard $(SRC_DIR)/*.cu)
OBJS = $(SRCS:$(SRC_DIR)/%.cu=$(OBJ_DIR)/%.o)

# Default target
all: $(BIN_DIR)/$(EXEC)

# Build the executable
$(BIN_DIR)/$(EXEC): $(OBJS)
	$(CXX) $(OBJS) -o $(BIN_DIR)/$(EXEC)

# Compile CUDA files
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cu
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Clean up
clean:
	rm -rf $(OBJ_DIR)/*.o $(BIN_DIR)/$(EXEC)

